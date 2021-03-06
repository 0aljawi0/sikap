import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sikap/Services/storage.dart';
import '../Services/pegawai.dart';
import 'dart:async';

class Login extends StatefulWidget {
  final Storage storage;

  Login({Key key, @required this.storage}): super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController kode = new TextEditingController();
  String bgImage = 'img/login.jpeg';


  @override
  void initState() { 
    super.initState();
    _autoLogin();
  }

  void _autoLogin() async {
    widget.storage.readStorage()
      .then((String kode) async {
        //print(kode);
        if (kode != null || kode != '') {
          Pegawai peg = new Pegawai(kode);
          await peg.auth();

          if (peg.namaPeg != null) {
            Navigator.pushReplacementNamed(context, '/home', arguments: {
              'kode' : peg.kdPeg,
              'nama' : peg.namaPeg,
            });
          }
        }
      });
  }

  Future<void> _auth() async {
    if(kode.text.length == 0) {
      Fluttertoast.showToast(msg: 'Kode Pegawai Kosong', toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.TOP);
    } else {
      Pegawai instance = new Pegawai(kode.text);
      await instance.auth();
      
      if (instance.namaPeg == null) {
        Fluttertoast.showToast(msg: instance.msg, toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.TOP);
      } else {
        await widget.storage.writeStorage(instance.kdPeg);
        Navigator.pushReplacementNamed(context, '/home', arguments: {
            'kode' : instance.kdPeg,
            'nama' : instance.namaPeg,
          });
      }
    }
  }

  // ENTRY FIELD
  Widget _entryField(String title, TextEditingController kontrol, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
          ),
          SizedBox(height: 10,),
          TextField(
              controller: kontrol,
              obscureText: isPassword,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true
              )
          )
        ],
      ),
    );
  }

  //SUBMIT BUTTON
  Widget _submitButton() {
    return SizedBox(
      width: double.infinity,
      child: RaisedButton(
        onPressed: () => _auth(),
        color: Colors.orange,
        child: Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  //TITLE
  Widget _title() {
    return Column(
      children: <Widget>[
        Image(image: AssetImage('assets/img/cilegon.png'), width: 100),
        SizedBox(height: 8.0),
        Image(image: AssetImage('assets/img/e-absen2.png'), width: 100),
        SizedBox(height: 8.0),
        Text('Diskominfo Kota Cilegon', style: TextStyle(color: Colors.white),)
      ],
    );
  }

  //KODE
  Widget _kodeWidget() => _entryField("Masukan Kode Pegawai", kode);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/$bgImage'),
              fit: BoxFit.cover
            )
          ),
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal:20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(flex: 3, child: SizedBox()),
                    _title(),
                    SizedBox(height: 50),
                    _kodeWidget(),
                    SizedBox(height: 20),
                    _submitButton(),
                    Expanded(flex: 2, child: SizedBox())
                  ],
                ),
              )
            ],
          )
        )
      ),
    );
  }
}