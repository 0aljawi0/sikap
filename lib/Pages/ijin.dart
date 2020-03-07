import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:sikap/Services/absenService.dart';
import 'package:sikap/Services/storage.dart';

class Ijin extends StatefulWidget {
  final Storage storage;
  Ijin({Key key, @required this.storage}) : super(key: key);

  @override
  _IjinState createState() => _IjinState();
}

class _IjinState extends State<Ijin> {
  var absenService = AbsenService();
  Map data = {};
  String kdPeg = '';

  final String dateString = DateFormat.yMMMMEEEEd().format(DateTime.now());

  TextEditingController keperluan = new TextEditingController();
  TextEditingController keterangan = new TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.storage.readStorage().then((kode) {
      setState(() {
        kdPeg = kode;
      });
    });
  }

  Future<void> _submitIjin() async {
    absenService
        .postIjin(kdPeg, data['kdunik'], data['ijin'], keperluan.text,
            keterangan.text)
        .then((res) {
      //print(res);
      if (res != '' || res != null) {
        Fluttertoast.showToast(msg: res, toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.TOP);
        Navigator.pop(context);
      }
    });
  }

  // ENTRY FIELD
  Widget _entryField(String title, TextEditingController kontrol,
      {bool isPassword = false, bool isTextArea = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 15,
                color: Colors.grey.shade800),
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

  //SUBMIT BUTTON
  Widget _submitButton() {
    return SizedBox(
      width: double.infinity,
      child: RaisedButton(
        onPressed: (() {
          _submitIjin();
        }),
        color: Colors.orange,
        child: Text(
          'Submit',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[700],
        title: Text('Pengajuan Ijin'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
          padding: EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 5.0),
                Text(
                  data['ijin'] == 1 ? 'Masuk Telat' : 'Pulang Cepat',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.orange.shade600,
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(height: 5.0),
                Text(
                  dateString,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14.0,
                  ),
                ),
                SizedBox(height: 5.0),
                _entryField('Keperluan', keperluan),
                SizedBox(height: 5.0),
                _entryField('Keterangan', keterangan, isTextArea: true),
                SizedBox(height: 5.0),
                _submitButton(),
              ],
            ),
          )),
    );
  }
}
