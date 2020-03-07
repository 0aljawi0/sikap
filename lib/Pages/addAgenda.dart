import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:sikap/Services/agendaService.dart';
import 'package:sikap/Services/storage.dart';

class AddAgenda extends StatefulWidget {
  final Storage storage;
  AddAgenda({Key key, @required this.storage}) : super(key: key);

  @override
  _AddAgendaState createState() => _AddAgendaState();
}

class _AddAgendaState extends State<AddAgenda> {
  AgendaService agendaServide = new AgendaService();

  String kdPeg = '';
  DateTime tglKegiatan = DateTime.now();
  TimeOfDay waktuStart = TimeOfDay.now();
  TimeOfDay waktuEnd = TimeOfDay.now();
  TextEditingController acara = new TextEditingController();
  TextEditingController lokasi = new TextEditingController();
  TextEditingController keterangan = new TextEditingController();

  String viewDate = DateFormat.yMMMd().format(DateTime.now());

  @override
  void initState() { 
    super.initState();
    widget.storage.readStorage().then((kode) {
      setState(() {
        kdPeg = kode;
      });
    });
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: tglKegiatan,
        firstDate:  DateTime.now().subtract(Duration(days: 1)),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        tglKegiatan = picked;
        viewDate = DateFormat.yMMMd().format(picked);
      });
  }

  Future<Null> _selectTimeStart(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: waktuStart,
    );
    if (picked != null)
      setState(() {
        waktuStart = picked;
      });
  }

  Future<Null> _selectTimeEnd(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: waktuEnd,
    );
    if (picked != null)
      setState(() {
        waktuEnd = picked;
      });
  }

  Widget _timePickerStart() {
    return RaisedButton(
      child: Text(waktuStart.format(context), style: TextStyle(color: Colors.white),),
      color: Colors.orange.shade500,
      onPressed: () => _selectTimeStart(context)
    );
  }

  Widget _timePickerEnd() {
    return RaisedButton(
      child: Text(waktuEnd.format(context), style: TextStyle(color: Colors.white),),
      color: Colors.orange.shade500,
      onPressed: () => _selectTimeEnd(context)
    );
  }

  Widget _datePicker() {
    return RaisedButton(
      child: Text(viewDate, style: TextStyle(color: Colors.white),),
      color: Colors.orange.shade500,
      onPressed: () => _selectDate(context)
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
          if(acara.text != '' && lokasi.text != '' && keterangan.text != '') {
            agendaServide.postAgenda(kdPeg, tglKegiatan.toString(), acara.text, lokasi.text, keterangan.text, waktuStart.format(context)+' s/d '+waktuEnd.format(context))
            .then((body) {
              if (body['message'] != null || body['message'] != '') {
                Fluttertoast.showToast(msg: body['message'], toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.TOP);
                Navigator.pop(context, {
                  'status': 200
                });
              }
            });
          } else {
            Fluttertoast.showToast(msg: 'Harap mengisi inputan data', toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.TOP);
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
          _entryField('Acara', acara),
          SizedBox(height: 5.0),
          Row (
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget> [
              _datePicker(),
            ]
          ),

          SizedBox(height: 5.0),
          Row (
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget> [
              _timePickerStart(),
              SizedBox(width: 5.0),
              _timePickerEnd()
            ]
          ),

          SizedBox(height: 5.0),
          _entryField('Lokasi', lokasi),
          SizedBox(height: 5.0),
          _entryField('Keterangan', keterangan, isTextArea: true),
          SizedBox(height: 8.0),
          _submitButton()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[700],
        title: Text('Agenda Kegiatan'),
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