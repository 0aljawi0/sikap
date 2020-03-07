import 'package:background_fetch/background_fetch.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sikap/Model/message.dart';
import 'package:sikap/Services/absenService.dart';
import 'package:sikap/Services/profilService.dart';
import 'package:sikap/Services/storage.dart';

class Home extends StatefulWidget {

  final Storage storage;

  Home({Key key, @required this.storage}): super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  ProfilService profilService = new ProfilService();
  AbsenService absenService = new AbsenService();
  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  Map data = {};
  String kdPeg = '';
  final String dateString = DateFormat.yMMMMEEEEd().add_jms().format(DateTime.now());

  String bgImage = 'img/bghome.jpg';
  String logo = 'https://www.freeiconspng.com/uploads/no-image-icon-6.png';
  String namaInstansi = '';

  String jamMasuk = 'Belum Absen Hari Ini';
  String jamPulang = 'Belum Absen Hari Ini';

  final List<Message> messages = [];

  @override
  void initState() { 
    super.initState();
    _initBackground();
  }

  Future<Null> _refresh() {
    return absenService.getDataAbsen(kdPeg).then((res) {
      if (res['body'] != null) {
        setState(() {
          jamMasuk = res['jam_masuk'] == '' ? 'Belum Absen Hari Ini' : res['jam_masuk'];
          jamPulang = res['jam_pulang'] == '' ? 'Belum Absen Hari Ini' : res['jam_pulang'];
        });
      }
    });
  }

  Future<void> _initBackground() async {
    await widget.storage.readStorage().then((kode) {
      profilService.getProfilApp(kode).then((data) {
        setState(() {
          logo = 'https://bravosolutionindonesia.com/e-absen/images/profil/'+data['logo_ins'];
          namaInstansi = data['nama_ins'];
        });
      });

      absenService.getDataAbsen(kode).then((res) {
        if (res['body'] != null) {
          setState(() {
            jamMasuk = res['jam_masuk'] == '' ? 'Belum Absen Hari Ini' : res['jam_masuk'];
            jamPulang = res['jam_pulang'] == '' ? 'Belum Absen Hari Ini' : res['jam_pulang'];
          });
        }
      });

      setState(() {
        kdPeg = kode;
      });
    });

    _firebaseMessaging.onTokenRefresh.listen(sendTokenToServer);
    _firebaseMessaging.subscribeToTopic('all');

    BackgroundFetch.configure(BackgroundFetchConfig(
        minimumFetchInterval: 15,
        stopOnTerminate: false,
        enableHeadless: true,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresStorageNotLow: false,
        requiresDeviceIdle: false,
        requiredNetworkType: NetworkType.ANY
    ), (String taskId) async {
      // This is the fetch-event callback.
      print("[BackgroundFetch] Event received $taskId");

      BackgroundFetch.finish(taskId);
    }).then((int status) {
      print('[BackgroundFetch] configure success: $status');
     
    }).catchError((e) {
      print('[BackgroundFetch] configure ERROR: $e');
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        //print("onMessage: $message");
        final notification = message['notification'];
        //print(notification);
        setState(() {
          messages.add(Message(
            title: notification['title'], body: notification['body']
          ));
        });
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        final notification = message['notification'];
        setState(() {
          messages.add(Message(
            title: notification['title'], body: notification['body']
          ));
        });
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        final notification = message['notification'];
        setState(() {
          messages.add(Message(
            title: notification['title'], body: notification['body']
          ));
        });
      },
    );

    _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true)
    );
  }

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
    Choice(title: 'Rekap Apel', icon: Icons.assignment, link: '/data-apel'),
    Choice(title: 'Profil', icon: Icons.assignment_ind, link: '/profil' ),
    // Choice(title: 'Keluar', icon: Icons.arrow_forward, link: 'keluar' )
  ];


  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;

    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      child: SafeArea(
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
              Image(image: NetworkImage(logo), height: 100.0,),
              SizedBox(height: 5.0),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Text(namaInstansi,
                style: TextStyle(
                  fontSize: 10.0,
                  color: Colors.white
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
              ),
              SizedBox(height: 5.0),
              Card(
                color: Colors.brown,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        //Text(dateString, style: TextStyle(color: Colors.black),),
                        Container(
                          child: Text(data['nama'], style: TextStyle(fontSize: 12.0, color: Colors.white), softWrap: true, textAlign: TextAlign.left,),
                        ),
                        
                        VerticalDivider(width: 20, thickness: 1, color: Colors.white,),

                        Container(
                          child: Column (
                            children: <Widget>[
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text('Jam Masuk : ', style: TextStyle(color: Colors.white, fontSize: 10),),
                                    SizedBox(height: 8.0,),
                                    Text(jamMasuk, style: TextStyle(color: Colors.white, fontSize: 10),),
                                ],),
                              ),
                              SizedBox(height: 5.0,),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text('Jam Pulang : ', style: TextStyle(color: Colors.white, fontSize: 10),),
                                    SizedBox(height: 8.0,),
                                    Text(jamPulang, style: TextStyle(color: Colors.white, fontSize: 10),),
                                ],),
                              ),
                            ]
                          )
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
                          onTap: () async {
                            if (choices[index].link == 'keluar') {
                              _logout();
                            } else {
                              dynamic res = await Navigator.pushNamed(context, choices[index].link, arguments: {'kode': data['kode']});
                              if (res != null) {
                                if (res['status'] == 200) {
                                   _refresh();
                                }
                              }
                            }
                          },
                          child: Card(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(child:Icon(choices[index].icon, size: 30.0, color: Colors.orange.shade500)),
                                      Text(choices[index].title, style: TextStyle(fontSize: 10.0, color: Colors.black), textAlign: TextAlign.center, softWrap: true,),
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
      ),
    );
  }

  void sendTokenToServer(String fcmToken) {
    // print('Token: $fcmToken');
    // print('KdPEG: $kdPeg');
    // send key to your server to allow server to use
    // this token to send push notifications
    profilService.postToken(fcmToken, kdPeg).then((res) {
      print(res['message']);
    });
  }
}

class Choice {
  const Choice({this.title, this.icon, this.link});

  final String title;
  final IconData icon;
  final String link;
}