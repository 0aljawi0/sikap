import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sikap/Services/absenService.dart';
import 'package:sikap/Services/storage.dart';

class DataKehadiran extends StatefulWidget {
  final Storage storage;
  DataKehadiran({Key key, @required this.storage}) : super(key: key);

  @override
  _DataKehadiranState createState() => _DataKehadiranState();
}

class _DataKehadiranState extends State<DataKehadiran> {
  AbsenService absenService = new AbsenService();
  String kdPeg;
  Map data = {
    'jumlah_dl': 0,
    'jumlah_ijin': 0,
    'jumlah_masuk': 0,
    'jumlah_sakit': 0,
    'jumlah_alfa': 0,
    'jumlah_cuti': 0,
    'jumlah_dt': 0,
    'jumlah_pti': 0
  };
  List dataAbsensi = [];

  @override
  void initState() { 
    super.initState();
    widget.storage.readStorage().then((kode) {
      setState(() {
        kdPeg = kode;
      });

      absenService.getDataKehadiran(kode).then((res) {
        setState(() {
          data = {
            'jumlah_dl': res['jumlahDL'],
            'jumlah_ijin': res['jumlahIjin'],
            'jumlah_masuk': res['jumlahMasuk'],
            'jumlah_sakit': res['jumlahSakit'],
            'jumlah_alfa': res['jumlahAlfa'],
            'jumlah_cuti': res['jumlahCuti'],
            'jumlah_dt': res['jumlahDT'],
            'jumlah_pti': res['jumlahPTI']
          };
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
                  DateFormat.yMMMMd().add_jms().format(DateTime.parse(value['tgl_absen'])),
                  softWrap: true,
                ),
              )
            ),
            DataCell(Text(value['jam_masuk'])),
            DataCell(Text(value['ket_absen'])),
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
            child: Text(data['jumlah_dl'].toString()),
          ),
          label: Text('Dinas Luar')
        ),

        Chip(
          avatar: CircleAvatar(
            backgroundColor: Colors.blue.shade500,
            child: Text(data['jumlah_ijin'].toString()),
          ),
          label: Text('Ijin')
        ),

        Chip(
          avatar: CircleAvatar(
            backgroundColor: Colors.green.shade500,
            child: Text(data['jumlah_masuk'].toString()),
          ),
          label: Text('Masuk')
        ),

        Chip(
          avatar: CircleAvatar(
            backgroundColor: Colors.yellow.shade500,
            child: Text(data['jumlah_sakit'].toString()),
          ),
          label: Text('Sakit')
        ),

        Chip(
          avatar: CircleAvatar(
            backgroundColor: Colors.red.shade500,
            child: Text(data['jumlah_alfa'].toString()),
          ),
          label: Text('Alfa')
        ),

        Chip(
          avatar: CircleAvatar(
            backgroundColor: Colors.purple.shade500,
            child: Text(data['jumlah_cuti'].toString()),
          ),
          label: Text('Cuti')
        ),

        Chip(
          avatar: CircleAvatar(
            backgroundColor: Colors.purple.shade500,
            child: Text(data['jumlah_dt'].toString()),
          ),
          label: Text('DT')
        ),

        Chip(
          avatar: CircleAvatar(
            backgroundColor: Colors.purple.shade500,
            child: Text(data['jumlah_pti'].toString()),
          ),
          label: Text('PTI')
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
          backgroundColor: Colors.orange[700],
          title: Text('Data Kehadiran'),
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