// enum ReportType
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pintarr/model/reportType.dart';

class Report {
  Report({
    required this.uid,
    required this.cid,
    required this.current,
    required this.data,
    required this.unitname,
    required this.model,
    required this.location,
    required this.type,
    required this.serial,
    // this.attachUrl,
    // this.attachName,
    required this.checked,
    this.checkdate,
    required this.date,
    this.id,
    required this.mon,
    required this.reportType,
    required this.by,
    this.checkBy,
    required this.comment,
    required this.version,
    this.belt,
    this.beltSize,
    this.lastUpdate,
    this.delete,
  });
  String uid;
  String cid;
  String model;
  String location;
  String serial;
  String type;
  String current;
  String unitname;
  // String attachUrl;
  // String attachName;
  List<String?> data;
  int mon;
  bool checked;
  int date;
  int? checkdate;
  String? id;
  ReportType reportType;
  String by;
  String? checkBy;
  String comment;
  bool? belt;
  String? beltSize;
  int version;
  Timestamp? lastUpdate;
  Timestamp? delete;

  static List<String?> _rd(list) {
    List<String?> data = [];
    for (String? t in list) {
      data.add(t);
    }
    return data;
  }

  static Report fromMap(Map<String, dynamic> data, String id,
      {bool json = false, win = false}) {
    final String uid = data['uid'];
    final String cid = data['cid'];
    final String current = data['current'];
    final String unitname = data['unitname'];
    final String model = data['model'];
    final String type = data['type'];
    final String location = data['location'];
    final String serial = data['serial'];
    final List<String?> rdata = _rd(data['data'] ?? []);
    // final List<String> ques = _toString(data['ques'] ?? []);
    // final List<dynamic> ans = _toDynamic(data['ans'] ?? []);
    // final String type = data['type'];
    final bool checked = data['checked'];
    final int date = data['date'];
    final int? checkdate = data['checkdate'];
    final int mon = data['mon'];
    final int version = data['version'];
    final String by = data['by'];
    final String? checkBy = data['checkBy'];
    final String comment = data['comment'];
    final String? beltSize = data['beltSize'];
    final bool? belt = data['belt'];
    final ReportType reportType = reportTypeFromString(data['reportType']);

    final Timestamp? lastUpdate = json
        ? (data['lastUpdate'] == null
            ? null
            : Timestamp.fromMillisecondsSinceEpoch(data['lastUpdate']))
        : (win
            ? (data['lastUpdate'] == null
                ? null
                : Timestamp.fromDate(data['lastUpdate']))
            : data['lastUpdate']);
    final Timestamp? delete = json
        ? (data['delete'] == null
            ? null
            : Timestamp.fromMillisecondsSinceEpoch(data['delete']))
        : (win
            ? (data['delete'] == null
                ? null
                : Timestamp.fromDate(data['delete']))
            : data['delete']);
    // final String attachUrl = data['attachUrl'];
    // final String attachName = data['attachName'];

    return Report(
      id: id,
      cid: cid,
      current: current,
      uid: uid,
      unitname: unitname,
      data: rdata,
      mon: mon,
      model: model,
      location: location,
      serial: serial,
      type: type,
      checked: checked,
      checkdate: checkdate,
      date: date,
      reportType: reportType,
      by: by,
      version: version,
      checkBy: checkBy,
      comment: comment,
      belt: belt,
      beltSize: beltSize,
      lastUpdate: lastUpdate,
      delete: delete,
      // attachUrl: attachUrl,
      // attachName: attachName,
    );
  }

  Report copy() => Report(
        id: id,
        cid: cid,
        current: current,
        uid: uid,
        unitname: unitname,
        data: data,
        version: version,
        mon: mon,
        checked: checked,
        checkdate: checkdate,
        date: date,
        reportType: reportType,
        by: by,
        checkBy: checkBy,
        comment: comment,
        type: type,
        belt: belt,
        beltSize: beltSize,
        // attachUrl: attachUrl,
        // attachName: attachName,
        model: model,
        location: location,
        serial: serial,
        lastUpdate: lastUpdate,
        delete: delete,
      );

  Map<String, dynamic> toMap(
      {bool json = false,
      bool update = false,
      bool del = false,
      DateTime? win}) {
    return {
      'cid': cid,
      'uid': uid,
      'mon': mon,
      'unitname': unitname,
      'data': data,
      'checked': checked,
      'current': current,
      'date': date,
      'reportType': reportTypeToString(reportType),
      'by': by,
      'checkBy': checkBy,
      'comment': comment,
      'type': type,
      'version': version,
      // 'attachUrl': attachUrl,
      'checkdate': checkdate,
      // 'attachName': attachName,
      'model': model,
      'location': location,
      'serial': serial,
      'belt': belt,
      'beltSize': beltSize,
      'lastUpdate': update
          ? (win ?? FieldValue.serverTimestamp())
          : (json ? (lastUpdate?.millisecondsSinceEpoch) : (win == null ? lastUpdate : lastUpdate?.toDate())),
      'delete': del
          ? (win ?? FieldValue.serverTimestamp())
          : (json ? (delete?.millisecondsSinceEpoch): (win == null ? delete : delete?.toDate())),
    };
  }
}
