// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:collection/collection.dart';

// import 'package:path_provider/path_provider.dart';
// import 'package:pintarr/model/agent.dart';
// import 'package:pintarr/model/client.dart';
// import 'package:pintarr/model/type.dart';
// import 'package:pintarr/service/controller/filePath.dart';
// import 'package:pintarr/service/fire/database.dart';
// import 'package:pintarr/service/realTime.dart';
// import 'package:rxdart/subjects.dart';

// class AcTypesController {
//   final Database database;
//   AcTypesController(this.database);
//   // {
//   //   print('init controller');
//   //   // if (client != null && !client!.pintar) init();
//   // }

//   // Client? client;
//   // Agent? agent;

//   List<AcType> types = [];
//   int lastUpdate = 0;
//   int lastDelete = 0;

//   String path = '';

//   final StreamController<List<AcType>> _controller =
//       BehaviorSubject<List<AcType>>();
//   Stream<List<AcType>> get stream => _controller.stream;

//   Future<String> addAcType(AcType type) async {
//     String id = await database.addAcType(type);
//     types.add(type);
//     _setData(types);
//     _save();
//     return id;
//   }

//   Future<void> updateAcType(AcType type) async {
//     await database.setAcType(type);
//     AcType otype = types.firstWhere((element) => element.id == type.id);
//     types.remove(otype);
//     types.add(type);
//     _setData(types);
//     _save();
//     // _setClient(false);
//   }

//   Future<void> deleteAcType(AcType type) async {
//     await database.setAcType(type, delete: true);
//     AcType otype = types.firstWhere((element) => element.id == type.id);
//     types.remove(otype);
//     _setData(types);
//     _save();
//     // _setClient(true);
//   }

//   void dispose() {
//     _controller.close();
//   }

//   // void updateClient(Client? nclient) async {
//   //   client = nclient;
//   //   if (agent != null && client != null) {
//   //     if (!client!.pintar) await init();

//   //     if (client!.lastAcTypeUpdate != null &&
//   //         client!.lastAcTypeUpdate!.millisecondsSinceEpoch > lastUpdate) {
//   //       print('update');
//   //       _update();
//   //     }
//   //     if (client!.lastAcTypeDelete != null &&
//   //         client!.lastAcTypeDelete!.millisecondsSinceEpoch > lastDelete) {
//   //       _delete();
//   //       print('delete');
//   //     }
//   //   }
//   // }

//   // void updateAgent(Agent? nagent) {
//   //   agent = nagent;
//   //   client = null;
//   //   path = '';
//   //   types = [];
//   //   lastUpdate = 0;
//   //   lastDelete = 0;
//   // }

//   void _setData(List<AcType> data) {
//     _controller.add(data);
//     types = data;
//   }

//   Future<void> _save() async {
//     Map<String, dynamic> data = {};

//     for (var e in types) {
//       data[e.id!] = e.toMap(json: true);
//     }

//     Map<String, dynamic> info = {
//       'lastUpdate': lastUpdate,
//       'lastDelete': lastDelete,
//       'data': data,
//     };

//     File file = File(path);

//     file.writeAsStringSync(jsonEncode(info));
//   }

//   Future<void> _update() async {
//     // int time = await RealTime.intNow();
//     List<AcType> newAcTypes = await database
//         .getUpdateAcTypes(Timestamp.fromMillisecondsSinceEpoch(lastUpdate));

//     // lastUpdate = client!.lastAcTypeUpdate?.millisecondsSinceEpoch ?? 0;
//     print(newAcTypes);

//     // lastUpdate = time;

//     for (AcType type in newAcTypes) {
//       AcType? u = types.firstWhereOrNull((e) => e.id == type.id);
//       if (u == null) {
//         types.add(type);
//       } else {
//         types.remove(u);
//         types.add(type);
//       }
//       if (type.added != null &&
//           type.added!.millisecondsSinceEpoch > lastUpdate) {
//         lastUpdate = type.added!.millisecondsSinceEpoch;
//       }
//     }
//     _setData(types);
//     _save();
//   }

//   Future<void> _delete() async {
//     List<AcType> delAcTypes = await database.getDeleteAcTypes(
//         Timestamp.fromMillisecondsSinceEpoch(lastDelete));

//     // lastDelete = client!.lastAcTypeUpdate?.millisecondsSinceEpoch ?? 0;

//     for (AcType type in delAcTypes) {
//       AcType? u = types.firstWhereOrNull((e) => e.id == type.id);
//       if (u != null) {
//         types.remove(u);
//       }
//       if (type.delete != null &&
//           type.delete!.millisecondsSinceEpoch > lastDelete) {
//         lastUpdate = type.delete!.millisecondsSinceEpoch;
//       }
//     }
//     _setData(types);
//     _save();
//   }
//   // Future<void> getData(uid) async => setData(await database.getAcTypes(uid));

//   Future<void> _loadData() async {
//     File file = File(path);

//     if (await file.exists()) {
//       String info = await file.readAsString();

//       Map<String, dynamic> datas = jsonDecode(info) as Map<String, dynamic>;

//       lastUpdate = datas['lastUpdate'];
//       lastDelete = datas['lastDelete'];
//       Map<String, dynamic> d = datas['data'];

//       List<AcType> data = [];

//       d.forEach((id, d) => data.add(AcType.fromMap(d, id, json: true)));
//       print('init read');
//     } else {
//       File(path).create(recursive: true);
//       print('init update');
//       _update();
//     }
//   }

//   Future<void> init() async {
//     String filePath = await FilePath.getPath();
//     path = '$filePath/types.json';

//     print(path);
//     _loadData();
//   }
// }
