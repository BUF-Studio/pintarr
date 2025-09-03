import 'dart:io';

// import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pintarr/model/type.dart';
import 'package:pintarr/model/unit.dart';

class ImportFile {
  static Future<String?> choose() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt', 'pdf', 'jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        // You can get the file path from the result object
        String? path = result.files.single.path;

        if (path != null) {
          print(path);

          return path;
          // Now you can use the path variable for your logic,
          // like scanning the image for a QR code.
        }
      } else {
        // User canceled the picker
        print("File selection canceled.");
        return null;
      }
    } catch (e) {
      print('Error while picking the file: $e');
      return null;
    }
  }

  readUnit(loc) async {
    // var line = 1;
    // List<Unit> units = [];
    // List<String> locc = [];
    // locc.addAll(loc);
    // try {
    //   String? path = await choose();
    //   if (path != null) {
    //     // List<String> tty = AcType.acType(false);
    //     File file = File(path);
    //     var content = await file.readAsLines();
    //     for (var i in content) {
    //       i.trim();
    //       if (i != '') {
    //         var data = i.split('|');
    //         if (data.length != 5) {
    //           return line;
    //         }
    //         if (!tty.contains(data[4])) {
    //           return line;
    //         }

    //         // Unit unit = Unit(
    //         //   unitname: data[0],
    //         //   serialNo: data[1],
    //         //   model: data[2],
    //         //   location: data[3],
    //         //   type: data[4],

    //         // );
    //         if (!locc.contains(data[3])) {
    //           locc.add(data[3]);
    //         }
    //         // units.add(unit);
    //       }
    //       line += 1;
    //     }
    //     return units;
    //   }
    // } catch (e) {}
  }
}
