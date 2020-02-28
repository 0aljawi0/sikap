import 'dart:io';
import 'package:http/http.dart';
import 'package:async/async.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'dart:convert';
import '../Library/constant.dart';

class AbsenService {

  String msg;

  Future<Map<String, dynamic>> getSetting(String kode) async {
    Map<String, dynamic> output;

    try {
      String url = '$SETTING?kode=$kode';
      Response response = await get(url);
      Map data = jsonDecode(response.body);
      output =  data['body'];
    } catch (e) {
      msg = 'check your internet connection';
    }

    return output;
  }

  Future<Map<String, dynamic>> postAbsen(String kode, Map<String, dynamic> settings, File image, String latitude, String longitude) async {
    Map<String, dynamic> output;
    
    try {
      ByteStream stream = new ByteStream(DelegatingStream.typed(image.openRead()));
      var length = await image.length();
      Uri url = Uri.parse(ABSEN);
      MultipartRequest request = new MultipartRequest('POST', url);
      MultipartFile multipartFile = new MultipartFile('image', stream, length, filename: basename(image.path));

      //"-6.180585","106.620201",
      request.fields['kd_peg'] = kode;
      request.fields['latitude'] = latitude;
      request.fields['longitude'] = longitude;
      request.fields['latitude_kantor'] = settings['lat_kantor'];
      request.fields['longitude_kantor'] = settings['long_kantor'];
      request.fields['jam_masuk'] = settings['jam_masuk'];
      request.fields['jam_pulang'] = settings['jam_pulang'];
      request.fields['radius'] = settings['radius_absen'];
      request.files.add(multipartFile);

      StreamedResponse response = await request.send();
      String resString = await response.stream.bytesToString();
      //print(resString);
      Map data = await jsonDecode(resString);
      output = data;
    } catch (e) {
      print(e);
    }
    //print(output);
    return output;
  }

  Future<Map<String, dynamic>> postAbsenApel(String kode, Map<String, dynamic> settings, File image, String latitude, String longitude) async {
    Map<String, dynamic> output;
    
    try {
      ByteStream stream = new ByteStream(DelegatingStream.typed(image.openRead()));
      var length = await image.length();
      Uri url = Uri.parse(ABSENAPEL);
      MultipartRequest request = new MultipartRequest('POST', url);
      MultipartFile multipartFile = new MultipartFile('image', stream, length, filename: basename(image.path));

      //"-6.180585","106.620201",
      request.fields['kd_peg'] = kode;
      request.fields['latitude'] = latitude;
      request.fields['longitude'] = longitude;
      request.fields['latitude_apel'] = settings['lat_apel'];
      request.fields['longitude_apel'] = settings['long_apel'];
      request.fields['jam_apel'] = settings['jam_apel'];
      request.fields['radius'] = settings['radius_apel'];
      request.files.add(multipartFile);

      StreamedResponse response = await request.send();
      String resString = await response.stream.bytesToString();
      //print(resString);
      Map data = await jsonDecode(resString);
      output = data;
    } catch (e) {
      print(e);
    }
    //print(output);
    return output;
  }

  Future<Map<String, dynamic>> postAbsenDinas(String kode, String kdDinasLuar, Map<String, dynamic> settings, File image, String latitude, String longitude) async {
    Map<String, dynamic> output;
    
    try {
      ByteStream stream = new ByteStream(DelegatingStream.typed(image.openRead()));
      var length = await image.length();
      Uri url = Uri.parse(POSTABSENDINAS);
      MultipartRequest request = new MultipartRequest('POST', url);
      MultipartFile multipartFile = new MultipartFile('image', stream, length, filename: basename(image.path));

      //"-6.180585","106.620201",
      request.fields['kd_peg'] = kode;
      request.fields['latitude'] = latitude;
      request.fields['longitude'] = longitude;
      request.fields['jam_masuk'] = settings['jam_masuk'];
      request.fields['kd_dinas_luar'] = kdDinasLuar;
      request.files.add(multipartFile);

      StreamedResponse response = await request.send();
      String resString = await response.stream.bytesToString();
      //print(resString);
      Map data = await jsonDecode(resString);
      output = data;
    } catch (e) {
      print(e);
    }
    //print(output);
    return output;
  }

  Future<String> postIjin (String kdPeg, String kdunik, int ijin, String keperluan, String keterangan) async {
    String output;

    try {

      Uri url = Uri.parse(IJINABSEN);
      var body = {
        'kd_peg' : kdPeg,
        'keterangan' : keterangan,
        'keperluan' : keperluan,
        'ijin' : ijin.toString(),
        'kdunik' : kdunik
      };
      Response response = await post(url, body: body);
      Map data = await jsonDecode(response.body);
      //print(data);
      output = data['message'];

    } catch (e) {
      print(e);
    }

    return output;
  }

  Future<Map> getDataKehadiran (String kdPeg) async {
    Map output;

    try {
      Uri url = Uri.parse(GETDATAKEHADIRAN+'?kd_peg='+kdPeg);
      Response response = await get(url);
      Map data = await jsonDecode(response.body);
      // print(data);
      output = data['body'];
    } catch (e) {
      print(e);
    }

    return output;
  }
}