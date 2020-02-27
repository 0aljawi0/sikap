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

class AbsenApel extends StatefulWidget {
  final Storage storage;
  AbsenApel({Key key, @required this.storage}) : super(key: key);

  @override
  _AbsenApelState createState() => _AbsenApelState();
}

class _AbsenApelState extends State<AbsenApel> {
  var absenService = AbsenService();

  File _image;
  String kode = '';
  String latitude = '';
  String longitude = '';
  Map<String, dynamic> settings = {};
  bool isButtonDisabled = true;

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
    });

    absenService.postAbsenApel(kode, settings, _image, latitude, longitude)
      .then((res) {
        //print(res);
        if(res['body'] == null) {
          Fluttertoast.showToast(msg: res['message'], gravity: ToastGravity.TOP);
          setState(() {
            _image = null;
          });
        }
      });
  }

  Future<void> getImageFromCamera() async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.camera);

    final tempDir =await getTemporaryDirectory();
    final path = tempDir.path;
    int rand= new Random().nextInt(100000);

    File compressImg;

    if (imageFile != null) {
      Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
      Img.Image smallerImg = Img.copyResize(image, width: 500);

      compressImg= new File("$path/image_$rand.jpg")
      ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 85));
    } else {
      compressImg = null;
    }
    
    setState(() {
      _image = compressImg;
      isButtonDisabled = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[700],
        title: Text('Absen Apel'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: GestureDetector(
                  onTap: () => {
                    getImageFromCamera()
                  },
                  child: Container(
                    child: _image == null ? Image.asset('assets/img/avatar.png') : Image.file(_image),
                ),
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
                onPressed: (isButtonDisabled ? () {
                  Fluttertoast.showToast(msg: 'Ambil Foto Terlebih Dahulu', gravity: ToastGravity.TOP);
                } : () {
                  postData();
                }),
                child: Text('Submit'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
