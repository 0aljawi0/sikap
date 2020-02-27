import 'package:http/http.dart';
import 'dart:async';
import 'dart:convert';
import '../Library/constant.dart';

class IjinService {
  Future<List> getIjin (String kdPeg) async {
    List output;

    try {
      Uri url = Uri.parse(GETIJIN+'?kd_peg='+kdPeg);
      Response response = await get(url);
      Map data = await jsonDecode(response.body);
      List body = data['body'];
      output = body;
    } catch (e) {
      print(e);
    }

    return output;
  }

  Future<List> getIjinKet () async {
    List output;

    try {
      Uri url = Uri.parse(GETIJINKET);
      Response response = await get(url);
      Map data = await jsonDecode(response.body);
      List body = data['body'];
      output = body;
      
    } catch (e) {
      print(e);
    }

    return output;
  }

  Future<Map> postIjinPengajuan (String kdPeg, String jenisIjin, String startDate, String endDate, String keperluan, String keterangan) async {
    Map output;

    try {
      Uri url = Uri.parse(POSTIJINPENGAJUAN);
      var body = {
        'kd_peg': kdPeg,
        'nama_ijin': jenisIjin,
        'start_date': startDate,
        'end_date': endDate,
        'keperluan': keperluan,
        'keterangan': keterangan
      };
      Response response = await post(url, body: body);
      Map data = await jsonDecode(response.body);
      output = data;
    } catch (e) {
      print(e);
    }

    return output;
  }

  Future<Map> deleteIjinPengajuan (String kdIjin) async {
    Map output;

    try {
      Uri url = Uri.parse(DELETEIJINPENGAJUAN+'?kd_ijin='+kdIjin);
      Response response = await get(url);
      Map data = await jsonDecode(response.body);
      output = data;
      
    } catch (e) {
      print(e);
    }

    return output;
  }

  Future<Map> rejectIjinPengajuan (String kdIjin) async {
    Map output;

    try {
      Uri url = Uri.parse(REJECTIJINPENGAJUAN+'?kd_ijin='+kdIjin);
      Response response = await get(url);
      Map data = await jsonDecode(response.body);
      output = data;
      
    } catch (e) {
      print(e);
    }

    return output;
  }

  Future<Map> approveIjinPengajuan (String kdIjin) async {
    Map output;

    try {
      Uri url = Uri.parse(APPROVEIJINPENGAJUAN+'?kd_ijin='+kdIjin);
      Response response = await get(url);
      Map data = await jsonDecode(response.body);
      output = data;
      
    } catch (e) {
      print(e);
    }

    return output;
  }
}