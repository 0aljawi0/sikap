import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sikap/Services/ijinService.dart';
import 'package:sikap/Services/pegawai.dart';
import 'package:sikap/Services/storage.dart';

class PengajuanIjin extends StatefulWidget {
  final Storage storage;
  PengajuanIjin({Key key, @required this.storage}) : super(key: key);

  @override
  _PengajuanIjinState createState() => _PengajuanIjinState();
}

class _PengajuanIjinState extends State<PengajuanIjin> {
  IjinService ijinService = new IjinService();

  String kdPeg = '';
  List data = [];
  Map pegawai = {};
  Map peg = {};

  @override
  void initState() {
    super.initState();
    _initIjin();
  }

  Future _initIjin() async {
    widget.storage.readStorage().then((kode) {
      ijinService.getIjin(kode).then((list) {
        setState(() {
          data = list;
          kdPeg = kode;
        });
      });

      Pegawai pegawaiService = new Pegawai(kode);
      pegawaiService.getProfil().then((data) {
        pegawai = data['pegawai'];
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

  Widget _deleteButtonAndStatus(String approvalOleh, String statusIjin, String kdIjin, String diketahui) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        _statusApproval(approvalOleh, int.parse(statusIjin)),
        SizedBox(width: 8.0),
        diketahui == '' || diketahui == null ? IconButton(
          onPressed: () {
            ijinService.deleteIjinPengajuan(kdIjin).then((body) {
              if(body['message'] != null || body['message'] != '') {
                Fluttertoast.showToast(msg: body['message'], gravity: ToastGravity.TOP);
                ijinService.getIjin(kdPeg).then((list) {
                  setState(() {
                    data = list;
                  });
                });
              }
            });
          },
          icon: Icon(Icons.remove_circle_outline),
          color: Colors.red.shade500,
        ) : null
      ],
    );
  }

  Widget _approveAndRejectButton(String kdIjin, String diketahui) {
    return Row (
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        diketahui != '' ? null
        : IconButton(
          onPressed: () {
            ijinService.rejectIjinPengajuan(kdIjin).then((body) {
              if(body['message'] != null || body['message'] != '') {
                Fluttertoast.showToast(msg: body['message'], gravity: ToastGravity.TOP);
                ijinService.getIjin(kdPeg).then((list) {
                  setState(() {
                    data = list;
                  });
                });
              }
            });
          },
          icon: Icon(Icons.remove_circle_outline),
          color: Colors.red.shade800
        ),
        SizedBox(width: 8.0),
        IconButton(
          onPressed: () {
            ijinService.approveIjinPengajuan(kdIjin).then((body) {
              if(body['message'] != null || body['message'] != '') {
                Fluttertoast.showToast(msg: body['message'], gravity: ToastGravity.TOP);
                ijinService.getIjin(kdPeg).then((list) {
                  setState(() {
                    data = list;
                  });
                });
              }
            });
          },
          icon: Icon(Icons.check_circle_outline),
          color: Colors.blue.shade800
        ),
      ],
    );
  }

  Widget _listData (
    String namaKet,
    String nip,
    String namaPeg,
    String namaJabatan,
    String tglIjin,
    String lamaIjin,
    String keperluanIjin,
    String ketIjin,
    String approvalOleh,
    String statusIjin,
    String diketahui,
    String kdIjin
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 5.0),
            Text(
              namaKet,
              style: TextStyle(color: Colors.orange.shade600, fontSize: 20.0),
            ),
            
            nip != '' ? SizedBox(height: 5.0) : SizedBox.shrink(),
            nip != '' ? _textView(nip + ' / ' + namaPeg, Icons.supervised_user_circle, Colors.grey.shade500) : SizedBox.shrink(),

            namaJabatan != '' ? SizedBox(height: 5.0) : SizedBox.shrink(),
            namaJabatan != '' ? _textView(namaJabatan, Icons.star, Colors.grey.shade500) : SizedBox.shrink(),
            
            SizedBox(height: 5.0),
            _textView(tglIjin, Icons.date_range, Colors.grey.shade500),
            
            SizedBox(height: 5.0),
            _textView(lamaIjin + ' Hari', Icons.calendar_view_day, Colors.grey.shade500),
            
            SizedBox(height: 5.0),
            _textView(keperluanIjin, Icons.directions_walk, Colors.green.shade500),
            
            SizedBox(height: 5.0),
            _textView(ketIjin, Icons.details, Colors.green.shade500),
            
            SizedBox(height: 10.0),
            approvalOleh == pegawai['kd_jabatan'] && int.parse(statusIjin) == 1 
            ? _approveAndRejectButton(kdIjin, diketahui)
            : _deleteButtonAndStatus(approvalOleh, statusIjin, kdIjin, diketahui),
            
            SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }

  Widget _statusApproval (String approvalOleh, int statusIjin) {

    Map approve = {'status': '', 'color': Colors.grey };

    if (approvalOleh != '') {
      if (statusIjin == 1) {
        approve = {'status': 'Tunggu Persetujuan', 'color': Colors.blue.shade400};
      } else if (statusIjin == 2) {
        approve = {'status': 'Disetujui', 'color': Colors.green.shade400};
      } else if (statusIjin == 3) {
        approve = {'status': 'Ditolak', 'color': Colors.red.shade400};
      }
    } else {
      if (statusIjin == 1) {
        approve = {'status': 'Terkirim', 'color': Colors.indigo.shade400};
      } else if (statusIjin == 2) {
        approve = {'status': 'Disetujui', 'color': Colors.green.shade400};
      } else if (statusIjin == 3) {
        approve = {'status': 'Ditolak', 'color': Colors.red.shade400};
      }
    }

    return Text (
      approve['status'],
      style: TextStyle(color: approve['color']),
    );
  }

  Widget _listViewIjin (List data) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 75.0),
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          //print(data);
          return _listData (
              data[index]['nama_ket'],
              data[index]['nip'] == '' ? data[index]['nip'] : '',
              data[index]['nama_peg'] == '' ? data[index]['nama_peg'] : '',
              data[index]['nama_jabatan'] == '' ? data[index]['nama_jabatan'] : '',
              data[index]['tgl_ijin'],
              data[index]['lama_ijin'],
              data[index]['keperluan_ijin'],
              data[index]['ket_ijin'],
              data[index]['approval_oleh'],
              data[index]['status_ijin'],
              data[index]['diketahui'] == '' ? data[index]['diketahui'] : '',
              data[index]['kd_ijin']
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
          title: Text('Pengajuan Ijin'),
          centerTitle: true,
          elevation: 0,
        ),
        body: _listViewIjin(data),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            dynamic res = await Navigator.pushNamed(context, '/add-pengajuan-ijin');
            if (res != null) {
              if(res['status'] == 200) {
                ijinService.getIjin(kdPeg).then((list) {
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