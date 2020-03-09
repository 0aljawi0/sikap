import 'dart:io';
import 'package:image/image.dart' as Img;
import 'dart:math';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import 'package:sikap/Library/constant.dart';
import 'package:sikap/Services/pegawai.dart';
import 'package:sikap/Services/storage.dart';

class UpdatePegawai extends StatefulWidget {
  final Storage storage;
  UpdatePegawai({Key key, @required this.storage}) : super(key: key);

  @override
  _UpdatePegawaiState createState() => _UpdatePegawaiState();
}

class _UpdatePegawaiState extends State<UpdatePegawai> {

  Map peg = {
    'foto_peg': ''
  };
  File image;
  TextEditingController email = new TextEditingController();
  TextEditingController telepon = new TextEditingController();
  bool isButtonDisabled = true;
  bool isImageProcess = false;
  bool isSubmitProcess = false;

  @override
  void initState() { 
    super.initState();
    widget.storage.readStorage().then((kode) {
      Pegawai pegawai = new Pegawai(kode);
      pegawai.getProfil().then((res) {
        setState(() {
          peg = res;
          email.text = res['email_peg'];
          telepon.text = res['tlp_peg'];
        });
      });
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
      image = compressImg;
      isButtonDisabled = false;
      isImageProcess = false;
    });
  }

  Widget _defaultFoto() {
    return peg['foto_peg'] == '' ? Image.asset('assets/img/avatar.jpeg') : Image.network(IMG_PEGAWAI+peg['foto_peg']);
  }

  Widget _imagePreview() {
    return Container(
        child: image == null ? _defaultFoto() : Image.file(image),
    );
  }

  Widget _imageProcess() {
    return Container(
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
    );
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

  // Form
  Widget _form () {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 5.0),
          GestureDetector(
            onTap: () => {
              getImageFromCamera()
            },
            child: isImageProcess ? _imageProcess() : _imagePreview(),
          ),
          SizedBox(height: 5.0,),
          _entryField('Email', email),
          SizedBox(height: 5.0),
          _entryField('Telepon', telepon),
          SizedBox(height: 8.0),
          _submitButton()
        ],
      ),
    );
  }

  //SUBMIT BUTTON
  Widget _submitButton() {
    return SizedBox(
      width: double.infinity,
      child: RaisedButton(
        onPressed: (() {

          setState(() {
            isSubmitProcess = true;
          });

          Pegawai pegawai = new Pegawai(peg['kd_peg']);
          pegawai.updateProfilPegawai(peg['kd_peg'], email.text, telepon.text, image).then((res) {
            if (res['status'] == 200) {
              setState(() {
                isSubmitProcess = false;
              });
              Fluttertoast.showToast(msg: 'Update Profil Berhasil', toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.TOP);
              Navigator.pop(context, {
                'status': 200,
                'kode': peg['kd_peg']
              });
            } else {
              setState(() {
                isSubmitProcess = false;
              });
              Fluttertoast.showToast(msg: 'Update Profil Gagal, Cek Internet Anda', toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.TOP);
            }
          });
        }),
        color: Colors.orange,
        child: Text(
          'Submit',
          style: TextStyle(color: Colors.white),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[700],
        title: Text('Edit Profil'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: isSubmitProcess ? _submitProcess() : _form(),
      ),
    );
  }
}