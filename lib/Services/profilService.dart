import 'package:http/http.dart';
import 'dart:async';
import 'dart:convert';
import '../Library/constant.dart';

class ProfilService {
  Future<Map> getProfilApp(String kdPeg) async {
    Map output;

    try {
      Uri url = Uri.parse(PROFILAPP+'?kd_peg=$kdPeg');
      Response response = await get(url);
      Map data = jsonDecode(response.body);
      output =  data['body'];
    } catch (e) {
      print(e);
    }

    return output;
  }

  Future<Map> getTokenAtasan(String kdPeg) async {
    Map output;

    try {
      Uri url = Uri.parse(TOKENATASAN+'?kd_peg=$kdPeg');
      Response response = await get(url);
      Map data = jsonDecode(response.body);
      output =  data['body'];
    } catch (e) {
      print(e);
    }

    return output;
  }
  
  Future<Map> postToken(String token, String kdPeg) async {
    Map output;

    try {
      Uri url = Uri.parse(TOKEN);
      Response response = await post(url, body: {
        'kd_peg': kdPeg,
        'fcm_token': token
      });
      Map data = jsonDecode(response.body);
      output =  data;
    } catch (e) {
      print(e);
    }

    return output;
  }
}