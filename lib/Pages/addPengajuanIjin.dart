import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sikap/Services/ijinService.dart';
import 'package:sikap/Services/storage.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'package:intl/intl.dart';

class AddPengajuanIjin extends StatefulWidget {
  final Storage storage;
  AddPengajuanIjin({Key key, @required this.storage}) : super(key: key);

  @override
  _AddPengajuanIjinState createState() => _AddPengajuanIjinState();
}

class _AddPengajuanIjinState extends State<AddPengajuanIjin> {
  IjinService ijinService = new IjinService();

  String kdPeg = '';
  String jenisIjin;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(Duration(days: 2));
  TextEditingController keperluan = new TextEditingController();
  TextEditingController keterangan = new TextEditingController();

  String viewDate = DateFormat.yMMMd().format(DateTime.now()) + ' - ' + DateFormat.yMMMd().format(DateTime.now().add(Duration(days: 2)));
  
  List ijinKet = [];

  @override
  void initState() { 
    super.initState();
    _initIjin();
  }

  Future<void> _initIjin(){
    widget.storage.readStorage().then((kode) {
      setState(() {
        kdPeg = kode;
      });
    });

    ijinService.getIjinKet().then((body) {
      setState(() {
        ijinKet = body;
      });
    });

    return null;
  }

  Widget _datePicker() {
    return RaisedButton(
      child: Text(viewDate, style: TextStyle(color: Colors.white),),
      color: Colors.orange.shade500,
      onPressed: () async {
        final List<DateTime> picked = await DateRangePicker.showDatePicker(
          context: context,
          initialFirstDate: _startDate,
          initialLastDate: _endDate,
          firstDate: new DateTime(DateTime.now().year - 1),
          lastDate: new DateTime(DateTime.now().year + 10),
        );

        if (picked != null && picked.length == 2) {
          setState(() {
            _startDate = picked[0];
            _endDate = picked[1];
            viewDate = DateFormat.yMMMd().format(_startDate) + ' - ' + DateFormat.yMMMd().format(_endDate);
          });
        }
      },
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

  //SUBMIT BUTTON
  Widget _submitButton() {
    return SizedBox(
      width: double.infinity,
      child: RaisedButton(
        onPressed: (() {
          if(jenisIjin != null && keperluan.text != '' && keterangan.text != '') {
            ijinService.postIjinPengajuan(kdPeg, jenisIjin, _startDate.toString(), _endDate.toString(), keperluan.text, keterangan.text)
            .then((body) {
              if (body['message'] != null || body['message'] != '') {
                Fluttertoast.showToast(msg: body['message'], gravity: ToastGravity.TOP);
                Navigator.pop(context, {
                  'status': 200
                });
              }
            });
          } else {
            Fluttertoast.showToast(msg: 'Harap mengisi inputan data', gravity: ToastGravity.TOP);
          }
        }),
        color: Colors.orange,
        child: Text(
          'Submit',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  // Form
  Widget _formPengajuan () {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 5.0),
          Row (
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget> [
              _selectIjin(),
              SizedBox(width: 2.0),
              _datePicker(),
            ]
          ),
          SizedBox(height: 5.0),
          _entryField('Keterangan', keperluan),
          SizedBox(height: 5.0),
          _entryField('Keterangan', keterangan, isTextArea: true),
          SizedBox(height: 8.0),
          _submitButton()
        ],
      ),
    );
  }

  Widget _selectIjin() {
    return DropdownButton(
      hint:  Text("Pilih Ijin"),
      value: jenisIjin,
      elevation: 16,
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.orange.shade500,
      ),
      onChanged: (newValue) {
        setState(() {
          jenisIjin = newValue;
        });
      },
      items: ijinKet.map((map) {
         return DropdownMenuItem(
          value: map['id_ket'],
          child: Text(map['nama_ket'])
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[700],
        title: Text('Pengajuan Ijin'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: _formPengajuan(),
      ),
    );
  }
}