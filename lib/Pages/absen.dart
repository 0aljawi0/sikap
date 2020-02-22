import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Absen extends StatefulWidget {
  //Absen({Key key}) : super(key: key);

  @override
  _AbsenState createState() => _AbsenState();
}

class _AbsenState extends State<Absen> {

  File _image;

  Future getImageFromCamera() async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() => {
      _image = imageFile
    });

    print(_image);
  }

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
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: RaisedButton(
                  onPressed: (() => {
                    print('submit')
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
