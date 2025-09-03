import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';

import 'package:pintarr/model/agent.dart';
import 'package:pintarr/model/client.dart';
import 'package:pintarr/model/unit.dart';
import 'package:pintarr/service/controller/filePath.dart';
import 'package:pintarr/service/fire/database.dart';
import 'package:rxdart/subjects.dart';

class UnitsController {
  final Database database;
  final bool win;
  UnitsController(this.database, this.win);
  // {
  //   print('init controller');
  //   // if (client != null && !client!.pintar) init();
  // }

  Client? client;
  Agent? agent;

  List<Unit> units = [];
  int lastUpdate = 0;
  int lastDelete = 0;

  String path = '';

  final StreamController<List<Unit>> _controller =
      BehaviorSubject<List<Unit>>();
  Stream<List<Unit>> get stream => _controller.stream;

  void _setClient(bool delete) async {
    database.setClient(
      client!,
      unitDel: delete,
      unitUpdate: !delete,
    );
  }

  Future<String> addUnit(Unit unit) async {
    String id = await database.addUnit(client!.id!, unit);
    unit.id = id;
    units.add(unit);
    _setData(units);
    _save();
    _setClient(false);
    return id;
  }

  Future<void> updateUnit(Unit unit) async {
    await database.setUnit(client!.id!, unit);
    Unit ounit = units.firstWhere((element) => element.id == unit.id);
    units.remove(ounit);
    units.add(unit);
    _setData(units);
    _save();
    _setClient(false);
  }

  Future<void> deleteUnit(Unit unit) async {
    await database.setUnit(client!.id!, unit, delete: true);
    Unit ounit = units.firstWhere((element) => element.id == unit.id);
    units.remove(ounit);
    _setData(units);
    _save();
    _setClient(true);
  }

  void dispose() {
    _controller.close();
  }

  void updateClient(Client? nclient) async {
    bool chg = client?.id != nclient?.id;

    print('chg');
    print(chg);

    client = nclient;
    // await _init();
    if (agent != null && client != null) {
      if (client!.pintar) return;
      if (!client!.pintar && chg) await _init();

      print(client?.lastUnitUpdate?.millisecondsSinceEpoch);
      print(lastUpdate);

      if (client!.lastUnitUpdate != null &&
          client!.lastUnitUpdate!.millisecondsSinceEpoch > lastUpdate) {
        print('update unit');
        _update();
      }
      if (client!.lastUnitDelete != null &&
          client!.lastUnitDelete!.millisecondsSinceEpoch > lastDelete) {
        _delete();
        print('delete');
      }
    }
  }

  void updateAgent(Agent? nagent) {
    agent = nagent;
    client = null;
    path = '';
    units = [];
    lastUpdate = 0;
    lastDelete = 0;
  }

  void _setData(List<Unit> data) {
    _controller.add(data);
    units = data;
  }

  Future<void> _save() async {
    Map<String, dynamic> data = {};

    for (var e in units) {
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

    print('get unit');
    List<Unit> newUnits = await database.getUpdateUnits(
        client!.id!, Timestamp.fromMillisecondsSinceEpoch(lastUpdate));

    lastUpdate = client!.lastUnitUpdate?.millisecondsSinceEpoch ?? 0;
    print(newUnits);

    // lastUpdate = time;

    for (Unit unit in newUnits) {
      Unit? u = units.firstWhereOrNull((e) => e.id == unit.id);
      if (u == null) {
        units.add(unit);
      } else {
        units.remove(u);
        units.add(unit);
      }
    }
    _setData(units);
    _save();
  }

  Future<void> _delete() async {
    List<Unit> delUnits = await database.getDeleteUnits(
        client!.id!, Timestamp.fromMillisecondsSinceEpoch(lastDelete));
    print(delUnits);
    lastDelete = client!.lastUnitDelete?.millisecondsSinceEpoch ?? 0;

    for (Unit unit in delUnits) {
      Unit? u = units.firstWhereOrNull((e) => e.id == unit.id);
      if (u != null) {
        units.remove(u);
      }
    }
    _setData(units);
    _save();
  }
  // Future<void> getData(uid) async => setData(await database.getUnits(uid));

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

      List<Unit> data = [];

      d.forEach((id, d) => data.add(Unit.fromMap(d, id, json: true)));
      _setData(data);
      print('init read');
    } else {
      File(path).create(recursive: true);
      print('init update');
      _update();
      // _delete();
    }
  }

  Future<void> _init() async {
    String filePath = await FilePath.getPath();
    path = win
        ? '$filePath\\${agent!.id}\\${client!.id}\\units.json'
        : '$filePath/${agent!.id}/${client!.id}/units.json';

    print(path);
    _setData([]);
    lastUpdate = 0;
    lastDelete = 0;

    await _loadData();
  }
}
