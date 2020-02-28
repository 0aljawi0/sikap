import 'package:http/http.dart';
import 'dart:async';
import 'dart:convert';
import '../Library/constant.dart';

class Pegawai {
  String kdPeg;
  String namaPeg;
  String msg;

  Pegawai (this.kdPeg);

  Future<void> auth() async {
    //print(kdPeg);
    try {
      Response response = await post(AUTH, body: { 'kode' : kdPeg });
      Map data = jsonDecode(response.body);
      //print(data);
      if (data['body'] != null) {
        namaPeg = data['body']['nama_peg'];
        msg = "Sukses mengambil data";
      } else {
        msg = "Data tidak ada";
      }
    } catch (e) {
      msg = 'Cek koneksi internet anda!';
    }
  }

  Future<Map> getProfil() async {
    Map data = {};

    try {
      String url = PROFIL+'?kode='+kdPeg;
      Response response = await get(url);
      data = await jsonDecode(response.body);

      if (data['body'] != null) {
        data = data['body'];
        msg = "Sukses mengambil data";
      } else {
        data = {};
        msg = "Data tidak ada";
      }
    } catch (e) {
      msg = 'Cek koneksi internet anda!';
    }

    return data;
  }

  Future<void> updatePosisiPegawai(String kdPeg, String latitude, String longitude) async {
    try {
      Uri url = Uri.parse(UPDATEPOSPEGAWAI);
      Response response = await post(url, body: {
        'kd_peg': kdPeg,
        'latitude': latitude,
        'longitude': longitude
      });

      Map data = jsonDecode(response.body);
      print(data['message']);
    } catch (e) {
      print(e);
    }
    return null;
  }
}