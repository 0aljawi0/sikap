import 'package:flutter/material.dart';
import 'package:sikap/Services/pegawai.dart';
import '../Library/constant.dart';

class Profil extends StatelessWidget {
  Map data = {};
  Pegawai pegawai;

  @override
  Widget build(BuildContext context) {

    data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;
    pegawai = new Pegawai(data['kode']);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[700],
        title: Text('Profil'),
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder(
        future: pegawai.getProfil(),
        builder: (BuildContext context, AsyncSnapshot<Map<dynamic, dynamic>> snapshot) {
          //print(snapshot);
          List<Widget> children;

          if (snapshot.hasData) {
            children = <Widget>[
              SizedBox(height: 5.0,),
              Center(
                child: Container(
                  width: 200.0,
                  height: 200.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: snapshot.data['pegawai']['foto_peg'] != null ? NetworkImage(IMG_PEGAWAI+snapshot.data['pegawai']['foto_peg']) : AssetImage('assets/img/avatar.png'),
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          SizedBox(height: 3.0,),
                          Text(
                            snapshot.data['pegawai']['nama_peg'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.grey[800]
                            ),
                          ),
                          SizedBox(height: 2.0,),
                          Text(
                            'NIP. '+snapshot.data['pegawai']['nip']+ ' / ID ' + snapshot.data['pegawai']['id_peg'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13.0,
                              color: Colors.orange[500]
                            ),
                          ),
                          SizedBox(height: 8.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Bidang ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.grey[400]
                                ),
                              ),
                              Text(
                                snapshot.data['bidang']['nama_bidang'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.blue[500]
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Jabatan ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.grey[400]
                                ),
                              ),
                              Text(
                                snapshot.data['jabatan']['nama_jabatan'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.blue[500]
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Status ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.grey[400]
                                ),
                              ),
                              Text(
                                snapshot.data['status']['nama_status'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.blue[500]
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Email ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.grey[400]
                                ),
                              ),
                              Text(
                                snapshot.data['pegawai']['email_peg'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.blue[500]
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Telepon ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.grey[400]
                                ),
                              ),
                              Text(
                                snapshot.data['pegawai']['tlp_peg'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.blue[500]
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ];
          } else if (snapshot.hasError) {
            children = <Widget>[
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              )
            ];
          } else {
            children = <Widget>[
              SizedBox(
                child: CircularProgressIndicator(),
                width: 60,
                height: 60,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...'),
              )
            ];
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          );

        }
      ),
    );
  }
}