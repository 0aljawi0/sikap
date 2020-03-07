import 'dart:io';

import 'package:http/http.dart';
import 'package:async/async.dart';
import 'package:path/path.dart';
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

  Future<Map> updateProfilPegawai(String kdPeg, String email, String telepon, File image) async {
    Map output;
    
    try {

      Uri url = Uri.parse(UPDATEPROFILPEGAWAI);
      MultipartRequest request = new MultipartRequest('POST', url);

      if (image == null) {
        request.fields['kd_peg'] = kdPeg;
        request.fields['email'] = email;
        request.fields['telepon'] = telepon;
        request.fields['isImage'] = 'tidak';

      } else {
        ByteStream stream = new ByteStream(DelegatingStream.typed(image.openRead()));
        var length = await image.length();
        MultipartFile multipartFile = new MultipartFile('image', stream, length, filename: basename(image.path));

        request.fields['kd_peg'] = kdPeg;
        request.fields['email'] = email;
        request.fields['telepon'] = telepon;
        request.fields['isImage'] = 'ada';
        request.files.add(multipartFile);
      }
      
      StreamedResponse response = await request.send();
      String resString = await response.stream.bytesToString();
      print(resString);
      Map data = await jsonDecode(resString);
      output = data;
    } catch (e) {
      print(e);
    }
    //print(output);
    return output;
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