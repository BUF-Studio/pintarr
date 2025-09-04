import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';

import 'package:pintarr/model/agent.dart';
import 'package:pintarr/model/client.dart';
import 'package:pintarr/model/report.dart';
import 'package:pintarr/service/controller/filePath.dart';
import 'package:pintarr/service/fire/database.dart';
import 'package:rxdart/subjects.dart';

class ReportsController {
  final Database database;
  final bool win;
  ReportsController(this.database, this.win);
  // {
  //   print('init controller');
  //   // if (client != null && !client!.pintar) init();
  // }

  Client? client;
  Agent? agent;

  List<Report> reports = [];
  int lastUpdate = 0;
  int lastDelete = 0;

  String path = '';

  final StreamController<List<Report>> _controller =
      BehaviorSubject<List<Report>>();
  Stream<List<Report>> get stream => _controller.stream;

  void _setClient(bool delete) async {
    database.setClient(
      client!,
      reportDel: delete,
      reportUpdate: !delete,
    );
  }

  Future<String> addReport(Report report) async {
    String id = await database.addReport(client!.id!, report);
    report.id = id;
    reports.add(report);
    _setData(reports);
    _save();
    _setClient(false);
    return id;
  }

  Future<void> updateReport(Report report) async {
    await database.setReport(client!.id!, report);
    Report oreport = reports.firstWhere((element) => element.id == report.id);
    reports.remove(oreport);
    reports.add(report);
    _setData(reports);
    _save();
    _setClient(false);
  }

  Future<void> deleteReport(Report report) async {
    await database.setReport(client!.id!, report, delete: true);
    Report oreport = reports.firstWhere((element) => element.id == report.id);
    reports.remove(oreport);
    _setData(reports);
    _save();
    _setClient(true);
  }

  void dispose() {
    _controller.close();
  }

  void updateClient(Client? nclient) async {
    bool chg = client?.id != nclient?.id;
    client = nclient;

    if (agent != null && client != null) {
      if (client!.pintar) return;
      if (!client!.pintar && chg) await init();

      if (client!.lastReportUpdate != null &&
          client!.lastReportUpdate!.millisecondsSinceEpoch > lastUpdate) {
        print('update');
        _update();
      }
      if (client!.lastReportDelete != null &&
          client!.lastReportDelete!.millisecondsSinceEpoch > lastDelete) {
        _delete();
        print('delete');
      }
    }
  }

  void updateAgent(Agent? nagent) {
    agent = nagent;
    client = null;
    path = '';
    reports = [];
    lastUpdate = 0;
    lastDelete = 0;
    // _setData([]);
  }

  void _setData(List<Report> data) {
    _controller.add(data);
    reports = data;
  }

  Future<void> _save() async {
    Map<String, dynamic> data = {};

    for (var e in reports) {
      data[e.id!] = e.toMap(json: true);
    }

    Map<String, dynamic> info = {
      'lastUpdate': lastUpdate,
      'lastDelete': lastDelete,
      'data': data,
    };

    File file = File(path);

    file.writeAsStringSync(jsonEncode(info));
  }

  Future<void> _update() async {
    // int time = await RealTime.intNow();
    List<Report> newReports = await database.getUpdateReports(
        client!.id!, Timestamp.fromMillisecondsSinceEpoch(lastUpdate));

    lastUpdate = client!.lastReportUpdate?.millisecondsSinceEpoch ?? 0;
    // print(newReports);

    // lastUpdate = time;

    for (Report report in newReports) {
      Report? u = reports.firstWhereOrNull((e) => e.id == report.id);
      if (u == null) {
        reports.add(report);
      } else {
        reports.remove(u);
        reports.add(report);
      }
    }
    _setData(reports);
    _save();
  }

  Future<void> _delete() async {
    List<Report> delReports = await database.getDeleteReports(
        client!.id!, Timestamp.fromMillisecondsSinceEpoch(lastDelete));

    lastDelete = client!.lastReportDelete?.millisecondsSinceEpoch ?? 0;

    for (Report report in delReports) {
      Report? u = reports.firstWhereOrNull((e) => e.id == report.id);
      if (u != null) {
        reports.remove(u);
      }
    }
    _setData(reports);
    _save();
  }
  // Future<void> getData(uid) async => setData(await database.getReports(uid));

  Future<void> _loadData() async {
    File file = File(path);

    if (await file.exists()) {
      String info = await file.readAsString();
      if (info == '') {
        _update();
        // _delete();
        return;
      }

      Map<String, dynamic> datas = jsonDecode(info) as Map<String, dynamic>;

      lastUpdate = datas['lastUpdate'];
      lastDelete = datas['lastDelete'];
      Map<String, dynamic> d = datas['data'];

      List<Report> data = [];

      d.forEach((id, d) => data.add(Report.fromMap(d, id, json: true)));
      print('init read');
      _setData(data);
    } else {
      File(path).create(recursive: true);
      print('init update');
      _update();
      // _delete();
    }
  }

  Future<void> init() async {
    String filePath = await FilePath.getPath();
    path = win
        ? '$filePath\\${agent!.id}\\${client!.id}\\reports.json'
        : '$filePath/${agent!.id}/${client!.id}/reports.json';
    // reports = [];
    _setData([]);
    lastUpdate = 0;
    lastDelete = 0;
    print(path);
    await _loadData();
  }

  Future<void> reloadReport()async{
   await File(path).delete();
   await init();
    
  }
}
