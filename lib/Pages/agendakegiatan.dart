import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
      agendaService.getAgenda(kode).then((list) {
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
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Text(
            text,
            softWrap: true,
            textAlign: TextAlign.left,
            style: TextStyle(color: color, fontSize: 14.0),
          ),
        )
      ],
    );
  }

  Widget _listData(String kdPeg, String kdKegiatan, String acara, String status, String tglKegiatan, String lokasi, String keterangan) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              acara,
              style: TextStyle(color: Colors.orange.shade600, fontSize: 20.0),
            ),
            
            _textView(tglKegiatan, Icons.date_range, Colors.grey.shade500),
            
            _textView(lokasi, Icons.map, Colors.green.shade500),

            _textView(keterangan, Icons.details, Colors.green.shade500),
            
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment:  MainAxisAlignment.end,
              children: <Widget>[
                Icon(int.parse(status) == 1  ? Icons.check : Icons.remove,
                  color: int.parse(status) == 1 ? Colors.green.shade500 : Colors.red.shade500,
                  size: 12,
                ),
                Text(int.parse(status) == 1 ? 'Aktif' : 'Nonaktif',
                  style: TextStyle(color: int.parse(status) == 1 ? Colors.green.shade500 : Colors.red.shade500),
                ),
                SizedBox(width: 8.0),
                kdPeg == '' ? SizedBox.shrink() : _deleteButtons(kdKegiatan)
              ],
            ),

            
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
              data[index]['kd_peg'] != '' ? data[index]['kd_peg'] : '',
              data[index]['kd_kegiatan'],
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

  Widget _deleteButtons(String kdKegiatan) {
    return IconButton(
      onPressed: () {
        agendaService.deleteAgenda(kdKegiatan).then((body) {
          if(body['message'] != null || body['message'] != '') {
            Fluttertoast.showToast(msg: body['message'], gravity: ToastGravity.TOP);
            agendaService.getAgenda(kdPeg).then((list) {
              setState(() {
                data = list;
              });
            });
          }
        });
      },
      icon: Icon(Icons.remove_circle_outline),
      color: Colors.red.shade500,
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
                agendaService.getAgenda(kdPeg).then((list) {
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