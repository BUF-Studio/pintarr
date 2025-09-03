import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FilePath {

  static Future<String> getPath() async {
    Directory directory = await getApplicationSupportDirectory();
    return directory.path;
  }
  
}