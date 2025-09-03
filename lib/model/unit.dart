import 'package:cloud_firestore/cloud_firestore.dart';

class Unit {
  Unit({
    // this.lastMajorService,
    // this.lastService,
    this.lastMonthService,
    this.lastHalfService,
    this.lastYearService,
    this.id,
    required this.unitname,
    required this.type,
    required this.location,
    required this.serialNo,
    this.current,
    required this.brand,
    required this.model,
    this.belt,
    this.beltSize,
    this.nextService,
    this.lastUpdate,
    this.delete,
  });
  int? lastMonthService;
  int? lastHalfService;
  int? lastYearService;
  // int lastService;
  String model;
  String unitname;
  String type;
  String brand;
  String location;
  String serialNo;
  String? id;
  String? current;
  bool? belt;
  String? beltSize;
  int? nextService;
  Timestamp? lastUpdate;
  Timestamp? delete;

  // static List<String> _toString(list) {
  //   List<String> group = [];
  //   for (String t in list) {
  //     group.add(t);
  //   }
  //   return group;
  // }

  static Unit fromMap(Map<String, dynamic> data, String id,
      {bool json = false, win = false}) {
    // if (data == null) {
    //   return null;
    // }
    final int? lastMonthService = data['lastMonthService'];
    final int? lastHalfService = data['lastHalfService'];
    final int? lastYearService = data['lastYearService'];
    final String unitname = data['unitname'];
    final String type = data['type'];
    final String brand = data['brand']??'';
    final String model = data['model'];
    final String serialNo = data['serialNo'];
    final String location = data['location'];
    final String? current = data['current'];
    final bool? belt = data['belt'];
    final String? beltSize = data['beltSize'];

    final int? nextService = data['nextService'];
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
    // final int minor = data['minor'];

    return Unit(
      lastMonthService: lastMonthService,
      lastHalfService: lastHalfService,
      lastYearService: lastYearService,
      id: id,
      unitname: unitname,
      type: type,
      model: model,
      brand: brand,
      location: location,
      serialNo: serialNo,
      current: current,
      belt: belt,
      beltSize: beltSize,
      nextService: nextService,
      lastUpdate: lastUpdate,
      delete: delete,
    );
  }

  Unit copy() => Unit(
        lastMonthService: lastMonthService,
        lastHalfService: lastHalfService,
        lastYearService: lastYearService,
        id: id,
        unitname: unitname,
        type: type,
        model: model,
        location: location,
        serialNo: serialNo,
        current: current,
        brand: brand,
        belt: belt,
        beltSize: beltSize,
        nextService: nextService,
        lastUpdate: lastUpdate,
        delete: delete,
      );

  Map<String, dynamic> toMap(
      {bool json = false,
      bool update = false,
      bool del = false,
      DateTime? win}) {
    return {
      'lastMonthService': lastMonthService,
      'lastHalfService': lastHalfService,
      'lastYearService': lastYearService,
      'unitname': unitname,
      'type': type,
      'location': location,
      'serialNo': serialNo,
      'model': model,
      'current': current,
      'brand': brand,
      'belt': belt,
      'beltSize': beltSize,
      'nextService': nextService,
      'lastUpdate': update
          ? (win ?? FieldValue.serverTimestamp())
          : (json ? (lastUpdate?.millisecondsSinceEpoch) : (win == null ? lastUpdate : lastUpdate?.toDate())),
      'delete': del
          ? (win ?? FieldValue.serverTimestamp())
          : (json ? (delete?.millisecondsSinceEpoch): (win == null ? delete : delete?.toDate())),
    };
  }
}
