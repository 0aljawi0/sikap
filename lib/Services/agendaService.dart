import 'package:http/http.dart';
import 'dart:async';
import 'dart:convert';
import '../Library/constant.dart';

class AgendaService {
  Future<List> getAgenda (String kdPeg) async {
    List output;

    try {
      Uri url = Uri.parse(GETAGENDA+'?kd_peg=$kdPeg');
      Response response = await get(url);
      Map data = await jsonDecode(response.body);
      List body = data['body'];
      output = body;
    } catch (e) {
      print(e);
    }

    return output;
  }

  Future<Map> postAgenda (String kdPeg, String tglKegiatan, String acara, String lokasi, String keterangan) async {
    Map output;

    try {
      Uri url = Uri.parse(POSTAGENDA);
      var body = {
        'kd_peg': kdPeg,
        'tgl_kegiatan': tglKegiatan,
        'acara': acara,
        'lokasi_keg': lokasi,
        'ket_keg': keterangan
      };
      Response response = await post(url, body: body);
      Map data = await jsonDecode(response.body);
      output = data;
    } catch (e) {
      print(e);
    }

    return output;
  }

  Future<Map> deleteAgenda(String kdKegiatan) async {
    Map output;

    try {
      Uri url = Uri.parse(DELETEAGENDA+'?kd_kegiatan=$kdKegiatan');
      Response response = await get(url);
      Map data = await jsonDecode(response.body);
      output = data;
    } catch (e) {
      print(e);
    }

    return output;
  }

}