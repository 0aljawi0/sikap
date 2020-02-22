import 'package:flutter/material.dart';
import 'package:sikap/Pages/profil.dart';
import 'package:sikap/Pages/absen.dart';
import 'package:sikap/Pages/home.dart';
import 'package:sikap/Pages/login.dart';

void main() => runApp(MaterialApp(
  initialRoute: '/login',
  routes: {
    '/home': (BuildContext context) => new Home(),
    '/login': (BuildContext context) => new Login(),
    '/profil': (BuildContext context) => new Profil(),
    '/absen': (BuildContext context) => new Absen(),
  },
));
