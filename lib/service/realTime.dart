import 'package:ntp/ntp.dart';

class RealTime {
  static Future<DateTime> now() async {
    DateTime now = await NTP.now();
    var offset = now.timeZoneOffset;
    var offmin = offset.inMinutes;
    now = now.subtract(Duration(minutes: offmin));
    return now;
  }

  static Future<int> intNow() async {
    DateTime now = await NTP.now();
    // var offset = now.timeZoneOffset;
    // var offmin = offset.inMinutes;
    // now = now.subtract(Duration(minutes: offmin));
    // print(now.millisecondsSinceEpoch);

    return now.millisecondsSinceEpoch;
  }

  static Future<DateTime> timestamp()async{
    try {
      return await now();
    } catch (e) {
      return DateTime.now();
    }
  }
}
