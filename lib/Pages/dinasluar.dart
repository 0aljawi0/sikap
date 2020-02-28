import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sikap/Services/absenService.dart';
import 'package:sikap/Services/storage.dart';
import 'package:image/image.dart' as Img;

class DinasLuar extends StatefulWidget {
  final Storage storage;
  DinasLuar({Key key, @required this.storage}) : super(key: key);

  @override
  _DinasLuarState createState() => _DinasLuarState();
}

class _DinasLuarState extends State<DinasLuar> {
  AbsenService absenService = AbsenService();

  File _image;
  String kode = '';
  String latitude = '';
  String longitude = '';
  Map<String, dynamic> settings = {};
  bool isButtonDisabled = true;
  bool isImageProcess = false;
  TextEditingController kdDinasLuar = new TextEditingController();

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

    absenService.postAbsenDinas(kode, kdDinasLuar.text, settings, _image, latitude, longitude)
      .then((res) {
        //print(res);
        if(res['body'] == null) {
          Fluttertoast.showToast(msg: res['message'], gravity: ToastGravity.TOP);
          setState(() {
            _image = null;
            kdDinasLuar.clear();
          });
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

      compressImg= new File("$path/image_$rand.jpg")
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

  // ENTRY FIELD
  Widget _entryField(String title, TextEditingController kontrol, {bool isPassword = false, bool isTextArea = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15, color: Colors.grey.shade800),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              maxLines: isTextArea ? 4 : 1,
              controller: kontrol,
              obscureText: isPassword,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  Widget _imagePreview() {
    return Container(
        child: _image == null ? Image.asset('assets/img/avatar.png') : Image.file(_image),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
          backgroundColor: Colors.orange[700],
          title: Text('Dinas Luar'),
          centerTitle: true,
          elevation: 0,
        ),
        body: SingleChildScrollView(
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
              SizedBox(height: 5.0,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _entryField('No Surat Dinas', kdDinasLuar),
              ),
              SizedBox(height: 5.0,),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: RaisedButton(
                    color: isButtonDisabled ? Colors.grey.shade300 : Colors.orange.shade600,
                    onPressed: (isButtonDisabled && kdDinasLuar.text == '' ? () {
                      Fluttertoast.showToast(msg: 'Ambil Foto Terlebih Dahulu & Isi Kode Dinas', gravity: ToastGravity.TOP);
                    } : () {
                      postData();
                    }),
                    child: Text('Submit'),
                  ),
                ),
              )
            ],
        ),
      ),
    );
  }
}