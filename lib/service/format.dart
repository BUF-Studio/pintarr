import 'package:intl/intl.dart';

class Format {
  static DateTime epochToDate(int stamp) {
    DateTime time = DateTime.fromMillisecondsSinceEpoch(stamp);
    time = time.subtract(Duration(minutes: time.timeZoneOffset.inMinutes));
    return time;
  }

  static epochToString(int? stamp) {
    if (stamp == null) {
      return '---';
    }
    return dateToString(epochToDate(stamp).add(const Duration(hours: 8)));
  }

  static dateToString(DateTime date) {
    return DateFormat('dd / MM / yyyy').format(date);
  }

  static int dateToMonth(DateTime date) {
    return int.parse(DateFormat('yyyyMM').format(date));
  }

  static String intToString(int mon) {
    var year = mon.toString().substring(0, 4);
    var month = mon.toString().substring(4, 6);
    DateTime date = DateTime(int.parse(year), int.parse(month));
    return DateFormat('MMM yyyy').format(date);
  }
}
