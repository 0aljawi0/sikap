import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sikap/Services/absenService.dart';
import 'package:sikap/Services/storage.dart';

class DataApel extends StatefulWidget {
  final Storage storage;
  DataApel({Key key, @required this.storage}) : super(key: key);

  @override
  _DataApelState createState() => _DataApelState();
}

class _DataApelState extends State<DataApel> {
  AbsenService absenService = new AbsenService();
  String kdPeg;
  Map data = {
    'jumlahMasuk': '',
    'jumlahTidak': ''
  };
  List dataAbsensi = [];

  @override
  void initState() { 
    super.initState();
    widget.storage.readStorage().then((kode) {
      setState(() {
        kdPeg = kode;
      });

      absenService.getDataApel(kode).then((res) {
        setState(() {
          data = res;
          dataAbsensi = res['dataAbsensi'];
        });
      });
    });
  }

  Widget _dataKehadiran() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(label: Text('Tanggal')),
          DataColumn(label: Text('Jam Absen')),
          DataColumn(label: Text('Ket')),
        ],
        rows: dataAbsensi.map((value) => DataRow(
          cells: [
            DataCell(
              SizedBox(
                width: 120.0,
                child: Text(
                  DateFormat.yMMMMd().add_jms().format(DateTime.parse(value['tgl_detail'])),
                  softWrap: true,
                ),
              )
            ),
            DataCell(Text(value['jam_masuk'])),
            DataCell(Text(value['ket_apel'])),
          ]
        )).toList(),
      ),
    );
  }

  Widget _jumlahKehadiran() {
    return Wrap(
      spacing: 5.0,
      runSpacing: 4.0,
      direction: Axis.horizontal,
      children: <Widget>[
        Chip(
          avatar: CircleAvatar(
            backgroundColor: Colors.indigo.shade500,
            child: Text(data['jumlahMasuk'].toString()),
          ),
          label: Text('Apel')
        ),

        Chip(
          avatar: CircleAvatar(
            backgroundColor: Colors.blue.shade500,
            child: Text(data['jumlahTidak'].toString()),
          ),
          label: Text('Tidak Apel')
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
          backgroundColor: Colors.orange[700],
          title: Text('Rekap Apel'),
          centerTitle: true,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _dataKehadiran(),
                Divider(height: 8.0, thickness: 1.0),
                _jumlahKehadiran()
              ],
            )
          ),
        ),
    );
  }
}