import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';

import 'package:path_provider/path_provider.dart';
import 'package:pintarr/model/agent.dart';
import 'package:pintarr/model/client.dart';
import 'package:pintarr/model/checklist.dart';
import 'package:pintarr/service/controller/filePath.dart';
import 'package:pintarr/service/fire/database.dart';
import 'package:pintarr/service/realTime.dart';
import 'package:rxdart/subjects.dart';

class ChecklistsController {
  final Database database;
  final bool win;
  ChecklistsController(this.database, this.win) {
    init();
  }
  // {
  //   print('init controller');
  //   // if (client != null && !client!.pintar) init();
  // }

  List<Checklist> checklists = [];
  int lastUpdate = 0;
  int lastDelete = 0;

  String path = '';

  final StreamController<List<Checklist>> _controller =
      BehaviorSubject<List<Checklist>>();
  Stream<List<Checklist>> get stream => _controller.stream;

  // void _setClient(bool delete) async {
  //   database.setClient(
  //     client!,
  //     checklistDel: delete,
  //     checklistUpdate: !delete,
  //   );
  // }

  Future<void> update() async => await _loadData();

  Future<String> addChecklist(Checklist checklist) async {
    String id = await database.addChecklist(checklist);
    checklist.id = id;
    checklists.add(checklist);
    _setData(checklists);
    _save();
    // _setClient(false);
    return id;
  }

  Future<void> updateChecklist(Checklist checklist) async {
    await database.setChecklist(checklist);
    Checklist ochecklist =
        checklists.firstWhere((element) => element.id == checklist.id);
    checklists.remove(ochecklist);
    checklists.add(checklist);
    _setData(checklists);
    _save();
    // _setClient(false);
  }

  Future<void> deleteChecklist(Checklist checklist) async {
    await database.setChecklist(checklist, delete: true);
    Checklist ochecklist =
        checklists.firstWhere((element) => element.id == checklist.id);
    checklists.remove(ochecklist);
    _setData(checklists);
    _save();
    // _setClient(true);
  }

  Checklist getChecklist(String acType, {int? version}) {
    List<Checklist> cl = getChecklists(acType);
    print(cl);
    if (version != null) return cl.firstWhere((e) => e.version == version);
    Checklist checklist = cl.last;
    for (Checklist c in cl) {
      if (c.version > checklist.version) checklist = c;
    }
    return checklist;
  }

  List<Checklist> getChecklists(String acType) {
    // print('cll');
    // print(checklists);
    return checklists.where((e) => e.type.contains(acType)).toList();
  }

  void dispose() {
    _controller.close();
  }

  void _setData(List<Checklist> data) {
    _controller.add(data);
    checklists = data;
    // print(data);
  }

  Future<void> _save() async {
    Map<String, dynamic> data = {};

    for (var e in checklists) {
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
    List<Checklist> newChecklists = await database
        .getUpdateChecklists(Timestamp.fromMillisecondsSinceEpoch(lastUpdate));

    // lastUpdate = client!.lastChecklistUpdate?.millisecondsSinceEpoch??0;
    // print('newChecklists');
    // print(newChecklists);

    // lastUpdate = time;

    for (Checklist checklist in newChecklists) {
      Checklist? u = checklists.firstWhereOrNull((e) => e.id == checklist.id);
      if (u == null) {
        checklists.add(checklist);
      } else {
        checklists.remove(u);
        checklists.add(checklist);
      }
      if (checklist.added != null &&
          checklist.added!.millisecondsSinceEpoch > lastUpdate) {
        lastUpdate = checklist.added!.millisecondsSinceEpoch;
      }
    }
    _setData(checklists);

    _save();
  }

  // Future<void> _delete() async {
  //   List<Checklist> delChecklists = await database
  //       .getDeleteChecklists(Timestamp.fromMillisecondsSinceEpoch(lastDelete));

  //   // lastDelete = client!.lastChecklistUpdate?.millisecondsSinceEpoch??0;

  //   for (Checklist checklist in delChecklists) {
  //     Checklist? u = checklists.firstWhereOrNull((e) => e.id == checklist.id);
  //     if (u != null) {
  //       checklists.remove(u);
  //     }
  //     if (checklist.delete != null &&
  //         checklist.delete!.millisecondsSinceEpoch > lastDelete) {
  //       lastUpdate = checklist.delete!.millisecondsSinceEpoch;
  //     }
  //   }
  //   _setData(checklists);
  //   _save();
  // }
  // Future<void> getData(uid) async => setData(await database.getChecklists(uid));

  Future<void> _loadData() async {
    File file = File(path);

    if (await file.exists()) {
      String info = await file.readAsString();
      if (info == '') {
        _update();
        return;
      }

      Map<String, dynamic> datas = jsonDecode(info) as Map<String, dynamic>;

      lastUpdate = datas['lastUpdate'];
      lastDelete = datas['lastDelete'];
      Map<String, dynamic> d = datas['data'];

      List<Checklist> data = [];

      d.forEach((id, d) => data.add(Checklist.fromMap(d, id, json: true)));
      print('checklist init read');
      _setData(data);
      _update();
      // _delete();
    } else {
      File(path).create(recursive: true);
      print('checklist init update');
      _update();
      // _delete();
    }
  }

  Future<void> init() async {
    String filePath = await FilePath.getPath();
    path = win ? '$filePath\\checklists.json' : '$filePath/checklists.json';

    print(path);
    _loadData();
  }
}
