import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = {};
  final String dateString = DateFormat.yMMMMEEEEd().add_jms().format(DateTime.now());

  List<Choice> choices = <Choice>[
    Choice(title: 'Absen', icon: Icons.check_box, link: '/absen' ),
    Choice(title: 'Absen Apel', icon: Icons.check_circle, link: '/absen-apel' ),
    Choice(title: 'Pengajuan Izin', icon: Icons.directions_boat, link: '/pengajuan-izin' ),
    Choice(title: 'Dinas Luar', icon: Icons.directions_bus, link: '/dinas-luar' ),
    Choice(title: 'Data Kehadiran', icon: Icons.directions_railway, link: 'data-kegiatan' ),
    Choice(title: 'Agenda Kegiatan', icon: Icons.directions_walk, link: 'agenda-kegiatan'),
    Choice(title: 'Profil', icon: Icons.directions_car, link: '/profil' )
  ];

  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;

    return Scaffold(
        body: Column(
          children: <Widget>[
            SizedBox(height: 30.0),
            Card(
              color: Colors.white,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(data['nama'],
                      style: TextStyle(fontSize: 18.0),),
                      SizedBox(height: 5.0),
                      Text(dateString),
                      SizedBox(height: 5.0),
                      Image(image: AssetImage('assets/img/cilegon.png'), height: 100.0,),
                      SizedBox(height: 5.0),
                      Text('Selamat Datang di Sistem Kehadiran Pegawai Dinas Komunikasi dan Informasi Kota Cilegon',
                        style: TextStyle(
                          fontSize: 12.0,
                        ),
                        textAlign: TextAlign.center,
                        )
                    ]
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Expanded(
              child: GridView.count(
              crossAxisCount: 3,
              children: List.generate(choices.length, (index) {
                return Center(
                  child: GestureDetector(
                        onTap: () => {
                          Navigator.pushNamed(context, choices[index].link, arguments: {
                            'kode': data['kode']
                          })
                        },
                        child: Card(
                        color: Colors.white,
                        child: Center(
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(child:Icon(choices[index].icon, size: 70.0, color: Colors.grey)),
                                Text(choices[index].title, style: TextStyle(fontSize: 14.0)),
                                SizedBox(height: 5.0)
                              ]),
                        )),
                  ),
                );
              })),
            ),
          ],
        ));
  }
}

class Choice {
  const Choice({this.title, this.icon, this.link});

  final String title;
  final IconData icon;
  final String link;
}


