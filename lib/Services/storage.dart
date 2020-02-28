import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Storage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/auth.txt');
  }

  Future<File> get _localLocationFile async {
    final path = await _localPath;
    return File('$path/location.txt');
  }

  Future<String> readStorage() async {
    try {
      final file = await _localFile;

      // Read the file
      String kode = await file.readAsString();

      return kode;
    } catch (e) {
      // If encountering an error, return 0
      return '';
    }
  }

  Future<void> writeStorage(String kode) async {
    final file = await _localFile;
    // Write the file
    file.writeAsString(kode);
  }

  Future<String> readLocationStorage() async {
    try {
      final file = await _localLocationFile;

      // Read the file
      String kode = await file.readAsString();

      return kode;
    } catch (e) {
      // If encountering an error, return 0
      return '';
    }
  }

  Future<void> writeLocationStorage(String latitude, String longitude) async {
    final file = await _localLocationFile;
    // Write the file
    file.writeAsString(latitude+'/'+longitude);
  }
}