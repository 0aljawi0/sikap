import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sikap/Services/storage.dart';

class Home extends StatefulWidget {

  final Storage storage;

  Home({Key key, @required this.storage}): super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = {};
  final String dateString = DateFormat.yMMMMEEEEd().add_jms().format(DateTime.now());

  String bgImage = 'img/sunrise.jpg';

  Future<Null> _logout() async {
    await widget.storage.writeStorage('');
    Navigator.pushReplacementNamed(context, '/login');
  }

  List<Choice> choices = <Choice>[
    Choice(title: 'Absen', icon: Icons.check_box, link: '/absen' ),
    Choice(title: 'Absen Apel', icon: Icons.check_circle, link: '/absen-apel' ),
    Choice(title: 'Pengajuan Izin', icon: Icons.format_list_bulleted, link: '/pengajuan-ijin' ),
    Choice(title: 'Dinas Luar', icon: Icons.directions_bus, link: '/dinas-luar' ),
    Choice(title: 'Data Kehadiran', icon: Icons.view_list, link: '/data-kehadiran' ),
    Choice(title: 'Agenda Kegiatan', icon: Icons.assignment, link: '/agenda-kegiatan'),
    Choice(title: 'Profil', icon: Icons.assignment_ind, link: '/profil' ),
    Choice(title: 'Keluar', icon: Icons.arrow_forward, link: 'keluar' )
  ];


  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;

    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/$bgImage'),
            fit: BoxFit.cover
          )
        ),
        child: Column(
          children: <Widget>[
            SizedBox(height: 30.0),
            Card(
              color: Color.fromARGB(100, 0, 0, 0),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(data['nama'],
                      style: TextStyle(fontSize: 18.0, color: Colors.white)),
                      SizedBox(height: 5.0),
                      Text(dateString, style: TextStyle(color: Colors.white),),
                      SizedBox(height: 5.0),
                      Image(image: AssetImage('assets/img/cilegon.png'), height: 100.0,),
                      SizedBox(height: 5.0),
                      Text('Selamat Datang di Sistem Kehadiran Pegawai Dinas Komunikasi dan Informasi Kota Cilegon',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.white
                        ),
                        textAlign: TextAlign.center,
                        )
                    ]
                  ),
                ),
              ),
            ),
            Expanded(
              child: GridView.count(
              crossAxisCount: 4,
              children: List.generate(choices.length, (index) {
                return Center(
                  child: GestureDetector(
                        onTap: () {
                          if (choices[index].link == 'keluar') {
                            _logout();
                          } else {
                            Navigator.pushNamed(context, choices[index].link, arguments: {'kode': data['kode']});
                          }
                        },
                        child: Card(
                          color: Color.fromARGB(102, 0, 0, 0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(child:Icon(choices[index].icon, size: 50.0, color: Colors.orange.shade500)),
                                    Text(choices[index].title, style: TextStyle(fontSize: 10.0, color: Colors.white), textAlign: TextAlign.center, softWrap: true,),
                                    SizedBox(height: 5.0)
                                  ]),
                            ),
                          )
                        ),
                  ),
                );
              })),
            ),
          ],
        ),
      ),
    );
  }
}

class Choice {
  const Choice({this.title, this.icon, this.link});

  final String title;
  final IconData icon;
  final String link;
}


