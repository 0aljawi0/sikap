import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sikap/Services/absenService.dart';
import 'package:sikap/Services/storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image/image.dart' as Img;
import 'dart:math';

class Absen extends StatefulWidget {
  final Storage storage;
  Absen({Key key, @required this.storage}) : super(key: key);

  @override
  _AbsenState createState() => _AbsenState();
}

class _AbsenState extends State<Absen> {
  var absenService = AbsenService();

  File _image;
  String kode = '';
  String latitude = '';
  String longitude = '';
  Map<String, dynamic> settings = {};
  bool isButtonDisabled = true;
  bool isImageProcess = false;
  bool isSubmitProcess = false;

  @override
  void initState() { 
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    widget.storage.readStorage().then((value) {
      setState(() {
        kode = value;
      });

      absenService.getSetting(value).then((data) {
          setState(() {
            settings = data;
          });
        });
    });

    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      latitude = position.latitude.toString();
      longitude = position.longitude.toString();
    });

  }

  Future<void> postData() async {
    setState(() {
      isButtonDisabled = true;
      isSubmitProcess = true;
    });

    absenService.postAbsen(kode, settings, _image, latitude, longitude)
      .then((res) {
        //print('RESPONSE ABSEN SHIF: ' + res.toString());

        if(res['status'] == 200) {

          if(res['body'] == null) {

            Fluttertoast.showToast(msg: res['message'], toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.TOP);
            setState(() {
              isButtonDisabled = false;
              isSubmitProcess = false;
            });

            Navigator.pop(context, {
              'status': 200
            });

          }

        } else if (res['status'] == 203) {

          if(res['body'] == null) {

            Fluttertoast.showToast(msg: res['message'], toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.TOP);
            setState(() {
              isButtonDisabled = false;
              isSubmitProcess = false;
            });

          } else {
            setState(() {
              _image = null;
              isSubmitProcess = false;
            });

            Navigator.pushReplacementNamed(context, '/ijin', arguments: {
              'kdunik' : res['body']['kdunik'],
              'ijin' : res['body']['ijin']
            });
          }

        }

        

      });
  }

  Future<void> getImageFromCamera() async {
    setState(() {
      isImageProcess = true;
    });
    var imageFile = await ImagePicker.pickImage(source: ImageSource.camera);

    final tempDir =await getTemporaryDirectory();
    final path = tempDir.path;
    int rand= new Random().nextInt(100000);

    File compressImg;

    if (imageFile != null) {
      Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
      Img.Image smallerImg = Img.copyResize(image, width: 500);

      compressImg = new File("$path/image_$rand.jpg")
      ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 85));
    } else {
      compressImg = null;
    }

    setState(() {
      _image = compressImg;
      isButtonDisabled = false;
      isImageProcess = false;
    });
  }

  Widget _imagePreview() {
    return Container(
        child: _image == null ? Image.asset('assets/img/avatar.jpeg', width: 200,) : Image.file(_image, width: 200,),
    );
  }

  Widget _imageProcess() {
    return Center(
      child: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              child: CircularProgressIndicator(),
              width: 60,
              height: 60,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text('Gambar Diproses...'),
            )
          ],
        ),
      ),
    );
  }

  Widget _submitProcess() {
    return Center(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              child: CircularProgressIndicator(),
              width: 60,
              height: 60,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text('Submiting...'),
            )
          ],
        ),
      ),
    );
  }

  Widget _absenView() => SingleChildScrollView(
      child: Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: GestureDetector(
              onTap: () => {
                getImageFromCamera()
              },
              child: isImageProcess ? _imageProcess() : _imagePreview(),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            'Klik gambar untuk mengambil foto',
            style: TextStyle(fontSize: 12.0, color: Colors.grey.shade700),
          )
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: RaisedButton(
              color: isButtonDisabled ? Colors.grey.shade300 : Colors.orange.shade600,
              onPressed: isButtonDisabled ? null : () {
                postData();
              },
              child: Text('Submit'),
            ),
          ),
        )
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange[700],
          title: Text('Absen'),
          centerTitle: true,
          elevation: 0,
        ),
        body: isSubmitProcess ? _submitProcess() : _absenView()
      ),
    );
  }
}
