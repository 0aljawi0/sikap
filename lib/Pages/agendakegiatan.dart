import 'package:flutter/material.dart';
import 'package:sikap/Services/agendaService.dart';
import 'package:sikap/Services/storage.dart';

class AgendaKegiatan extends StatefulWidget {
  final Storage storage;
  AgendaKegiatan({Key key, @required this.storage}) : super(key: key);

  @override
  _AgendaKegiatanState createState() => _AgendaKegiatanState();
}

class _AgendaKegiatanState extends State<AgendaKegiatan> {
  AgendaService agendaService = new AgendaService();

  String kdPeg = '';
  List data = [];

  @override
  void initState() {
    super.initState();
    _initIjin();
  }

  Future _initIjin() async {
    widget.storage.readStorage().then((kode) {
      agendaService.getAgenda().then((list) {
        setState(() {
          data = list;
          kdPeg = kode;
        });
      });
    });
  }

  Widget _textView(String text, IconData icon, Color color) {
    return Row (
      children: <Widget>[
        Icon(icon, size: 14.0, color: color),
        SizedBox(width: 3.0),
        Text(
          text,
          style: TextStyle(color: color, fontSize: 14.0),
        ),
      ],
    );
  }

  Widget _listData(String acara, String status, String tglKegiatan, String lokasi, String keterangan) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 5.0),
            Text(
              acara,
              style: TextStyle(color: Colors.orange.shade600, fontSize: 20.0),
            ),
            
            SizedBox(height: 5.0),
            _textView(tglKegiatan, Icons.date_range, Colors.grey.shade500),
            
            SizedBox(height: 5.0),
            _textView(lokasi, Icons.map, Colors.green.shade500),
            
            SizedBox(height: 5.0),
            _textView(keterangan, Icons.details, Colors.green.shade500),
            
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment:  MainAxisAlignment.end,
              children: <Widget>[
                Chip(
                  avatar: CircleAvatar(
                    backgroundColor: int.parse(status) == 1 ? Colors.green.shade500 : Colors.green.shade500,
                    child: Icon(int.parse(status) == 1  ? Icons.check : Icons.remove, color: Colors.white,),
                  ),
                  label: Text(int.parse(status) == 1 ? 'Aktif' : 'Nonaktif')
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _listViewAgenda(List data) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 75.0),
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          //print(data);
          return _listData (
              data[index]['acara'],
              data[index]['status_keg'],
              data[index]['tgl_kegiatan'],
              data[index]['lokasi_keg'],
              data[index]['ket_keg']
          );
        }
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
        body: _listViewAgenda(data),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            dynamic res = await Navigator.pushNamed(context, '/add-agenda');
            if (res != null) {
              if(res['status'] == 200) {
                agendaService.getAgenda().then((list) {
                  setState(() {
                    data = list;
                  });
                });
              }
            }
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.orange.shade600,
        ),
    );
  }
}