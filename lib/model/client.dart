import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pintarr/service/realTime.dart';

class Client {
  Client({
    this.id,
    required this.name,
    required this.password,
    required this.pintar,
    required this.location,
    required this.mon,
    this.lastUnitUpdate,
    this.lastUnitDelete,
    this.lastReportUpdate,
    this.lastReportDelete,
  });

  String? id;
  String name;
  bool pintar;
  String password;
  List<String> location;
  List<int> mon;
  Timestamp? lastUnitUpdate;
  Timestamp? lastUnitDelete;
  Timestamp? lastReportUpdate;
  Timestamp? lastReportDelete;

  static List<String> _toString(list) {
    List<String> group = [];
    for (String? t in list) {
      group.add(t!);
    }
    return group;
  }

  static List<int> _toInt(list) {
    List<int> group = [];
    for (int? t in list) {
      group.add(t!);
    }
    return group;
  }

  static Client? fromMap(Map<String, dynamic>? data, id, {win = false}) {
    if (data == null) {
      return null;
    }
    // final String id = data['id'];
    // final String address = data['address'];
    final String name = data['name'];
    final bool pintar = data['pintar'];
    final String password = data['password'];
    final List<String> location = _toString(data['location'] ?? []);
    final List<int> mon = _toInt(data['mon'] ?? []);

    final Timestamp? lastUnitUpdate = win
        ? data['lastUnitUpdate'] == null
            ? null
            : Timestamp.fromDate(data['lastUnitUpdate'])
        : data['lastUnitUpdate'];
    final Timestamp? lastUnitDelete = win
        ? data['lastUnitDelete'] == null
            ? null
            : Timestamp.fromDate(data['lastUnitDelete'])
        : data['lastUnitDelete'];
    final Timestamp? lastReportUpdate = win
        ? data['lastReportUpdate'] == null
            ? null
            : Timestamp.fromDate(data['lastReportUpdate'])
        : data['lastReportUpdate'];
    final Timestamp? lastReportDelete = win
        ? data['lastReportDelete'] == null
            ? null
            : Timestamp.fromDate(data['lastReportDelete'])
        : data['lastReportDelete'];

    return Client(
      id: id,
      name: name,
      pintar: pintar,
      password: password,
      location: location,
      mon: mon,
      lastUnitUpdate: lastUnitUpdate,
      lastUnitDelete: lastUnitDelete,
      lastReportUpdate: lastReportUpdate,
      lastReportDelete: lastReportDelete,
    );
  }

  copy() => Client(
        id: id,
        name: name,
        pintar: pintar,
        password: password,
        location: location,
        mon: mon,
        lastUnitUpdate: lastUnitUpdate,
        lastUnitDelete: lastUnitDelete,
        lastReportUpdate: lastReportUpdate,
        lastReportDelete: lastReportDelete,
      );

  Map<String, dynamic> toMap(
      {bool unitUpdate = false,
      bool unitDel = false,
      bool reportUpdate = false,
      bool reportDel = false,
      DateTime? win}) {
    return {
      'name': name,
      'pintar': pintar,
      'password': password,
      'location': location,
      'mon': mon,
      'lastUnitUpdate': unitUpdate
          ? (win ?? FieldValue.serverTimestamp())
          : (win == null ? lastUnitUpdate : lastUnitUpdate?.toDate()),
      'lastUnitDelete': unitDel
          ? (win ?? FieldValue.serverTimestamp())
          : (win == null ? lastUnitDelete : lastUnitDelete?.toDate()),
      'lastReportUpdate': reportUpdate
          ? (win ?? FieldValue.serverTimestamp())
          : (win == null ? lastReportUpdate : lastReportUpdate?.toDate()),
      'lastReportDelete': reportDel
          ? (win ?? FieldValue.serverTimestamp())
          : (win == null ? lastReportDelete : lastReportDelete?.toDate()),
    };
  }
}
