import 'package:flutter/material.dart';
import 'package:sikap/Services/pegawai.dart';
import '../Library/constant.dart';

class Profil extends StatelessWidget {
  Map data = {};

  Widget _textView(String title, String value) => Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13.0,
            color: Colors.white
          ),
        ),
        Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13.0,
            color: Colors.white
          ),
        ),
      ],
  );

  @override
  Widget build(BuildContext context) {

    data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;
    // print (data);
    Pegawai pegawai = new Pegawai(data['kode']);

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
          // print(snapshot.data);
          List<Widget> children;

          if (snapshot.hasData) {
            children = <Widget>[
              SizedBox(height: 10.0,),
              Center(
                child: Container(
                  width: 200.0,
                  height: 200.0,
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.orange),
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: snapshot.data['foto_peg'] != null ? NetworkImage(IMG_PEGAWAI+snapshot.data['foto_peg']) : AssetImage('assets/img/avatar.png'),
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Card(
                    color: Colors.orange.shade900,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          SizedBox(height: 3.0,),
                          Text(
                            snapshot.data['nama_peg'] != '' ? snapshot.data['nama_peg'] : '-',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white
                            ),
                          ),
                          SizedBox(height: 2.0,),
                          Text(
                            'NIP. '+snapshot.data['nip']+ ' / ID ' + snapshot.data['id_peg'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13.0,
                              color: Colors.white
                            ),
                          ),
                          Divider(height: 20, thickness: 1, indent: 10, endIndent: 10, color: Colors.grey.shade300,),
                          _textView('Bidang', snapshot.data['nama_bidang'] != '' ? snapshot.data['nama_bidang'] : '-'),
                          Divider(height: 10, thickness: 1, color: Colors.grey.shade300,),
                          _textView('Jabatan', snapshot.data['nama_jabatan'] != '' ? snapshot.data['nama_jabatan'] : '-'),
                          Divider(height: 10, thickness: 1, color: Colors.grey.shade300,),
                          _textView('Status', snapshot.data['nama_status'] != '' ? snapshot.data['nama_status'] : '-'),
                          Divider(height: 10, thickness: 1, color: Colors.grey.shade300,),
                          _textView('Email', snapshot.data['email_peg'] != '' ? snapshot.data['email_peg'] : '-'),
                          Divider(height: 10, thickness: 1, color: Colors.grey.shade300,),
                          _textView('Telepon', snapshot.data['tlp_peg'] != '' ? snapshot.data['tlp_peg'] : '-'),
                          
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children,
            ),
          );

        }
      ),
    );
  }
}