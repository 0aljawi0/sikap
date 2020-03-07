import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sikap/Pages/absenapel.dart';
import 'package:sikap/Pages/addAgenda.dart';
import 'package:sikap/Pages/addPengajuanIjin.dart';
import 'package:sikap/Pages/agendakegiatan.dart';
import 'package:sikap/Pages/dataApel.dart';
import 'package:sikap/Pages/datakehadiran.dart';
import 'package:sikap/Pages/dinasluar.dart';
import 'package:sikap/Pages/ijin.dart';
import 'package:sikap/Pages/pengajuanijin.dart';
import 'package:sikap/Pages/profil.dart';
import 'package:sikap/Pages/absen.dart';
import 'package:sikap/Pages/home.dart';
import 'package:sikap/Pages/login.dart';
import 'package:sikap/Pages/updatePegawai.dart';
import 'package:sikap/Services/storage.dart';

import 'package:background_fetch/background_fetch.dart';

import 'Services/pegawai.dart';

Storage storage = new Storage();

void backgroundFetchHeadlessTask(String taskId) async {
  print('[BackgroundFetch] Headless event received.');

  storage.readStorage().then((kode) async {
    if(kode != null){
      Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      Pegawai pegawai = new Pegawai(kode);
      pegawai.updatePosisiPegawai(kode, position.latitude.toString(), position.longitude.toString());
    }
  });

  BackgroundFetch.finish(taskId);
}

void main() {
  runApp(MaterialApp(
      initialRoute: '/login',
      routes: {
        '/home': (BuildContext context) => new Home(storage: storage),
        '/login': (BuildContext context) => new Login(storage: storage),
        '/profil': (BuildContext context) => new Profil(),
        '/absen': (BuildContext context) => new Absen(storage: storage),
        '/absen-apel': (BuildContext context) => new AbsenApel(storage: storage),
        '/pengajuan-ijin': (BuildContext context) => new PengajuanIjin(storage: storage),
        '/dinas-luar': (BuildContext context) => new DinasLuar(storage: storage),
        '/data-kehadiran': (BuildContext context) => new DataKehadiran(storage: storage),
        '/agenda-kegiatan': (BuildContext context) => new AgendaKegiatan(storage: storage),
        '/ijin' : (BuildContext context) => new Ijin(storage: storage),
        '/data-apel' : (BuildContext context) => new DataApel(storage: storage),
        // add pages
        '/add-pengajuan-ijin' : (BuildContext context) => new AddPengajuanIjin(storage: storage),
        '/add-agenda' : (BuildContext context) => new AddAgenda(storage: storage),
        // update pages
        '/update-pegawai' : (BuildContext context) => new UpdatePegawai(storage: storage),
      },
    )
  );

  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}
