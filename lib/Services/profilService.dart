import 'package:http/http.dart';
import 'dart:async';
import 'dart:convert';
import '../Library/constant.dart';

class ProfilService {
  Future<Map> getProfilApp() async {
    Map output;

    try {
      Uri url = Uri.parse(PROFILAPP);
      Response response = await get(url);
      Map data = jsonDecode(response.body);
      output =  data['body'];
    } catch (e) {
      print(e);
    }

    return output;
  }
}