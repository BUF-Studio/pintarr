import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pintarr/model/agent.dart';
import 'package:pintarr/model/checklist.dart';
import 'package:pintarr/model/client.dart';
import 'package:pintarr/model/report.dart';
import 'package:pintarr/model/unit.dart';
import 'package:pintarr/service/fire/api_path.dart';
import 'package:pintarr/service/fire/firestore_service.dart';
import 'package:pintarr/service/fire/realDatabase.dart';
import 'package:pintarr/service/realTime.dart';
import 'package:pintarr/service/stream/agentStream.dart';
import 'package:pintarr/service/stream/agentsStream.dart';
import 'package:pintarr/service/stream/clientStream.dart';
import 'package:pintarr/service/stream/clientsStream.dart';

enum Func {
  add,
  sett,
  update,
  delete,
}

class Database {
  // final bool win = Platform.isWindows;
  final bool win;
  // final RealDatabase? real;
  Database(this.win) {
    if (win) {
      _real = RealDatabase();
      _clientsStream = ClientsStream(_real);
      _clientStream = ClientStream(_real);
      _agentStream = AgentStream(_real);
      _agentsStream = AgentsStream(_real);
    }
  }

  late RealDatabase _real;
  // late UnitStream _unitStream;
  // late ReportStream _reportStream;
  late ClientsStream _clientsStream;
  late ClientStream _clientStream;
  late AgentStream _agentStream;
  late AgentsStream _agentsStream;

  final _service = FirestoreService.instance;
  // final real = RealDatabase();

  clientStreamUpdate(cid) => _clientStream.update(cid);
  clientsStreamUpdate() => _clientsStream.update();
  agentStreamUpdate(uid) => _agentStream.update(uid);
  agentsStreamUpdate(cid) => _agentsStream.update(cid);

  getClients() => _clientsStream.getClients();

  Future converter({
    required path,
    data,
    required Func func,
  }) async {
    if (win) {
      switch (func) {
        case Func.add:
          String sid = await _real.addData(
            path: path,
            data: data,
          );
          // await stream.update(path: path, builder: builder);
          return sid;
        // break;
        case Func.sett:
          await _real.setData(path: path, data: data);
          break;
        case Func.update:
          await _real.updateData(path: path, data: data);
          break;
        case Func.delete:
          await _real.deleteData(path: path);
          break;
      }
    } else {
      switch (func) {
        case Func.add:
          String sid = await _service.addData(
            path: path,
            data: data,
          );
          return sid;
        // break;
        case Func.sett:
          await _service.setData(path: path, data: data);
          break;
        case Func.update:
          await _service.updateData(path: path, data: data);
          break;
        case Func.delete:
          await _service.deleteData(path: path);
          break;
      }
    }
  }

  Future<String> addUnit(String cid, Unit unit) async {
    DateTime? time = win ? await RealTime.timestamp() : null;

    String id = await converter(
      path: APIPath.units(cid),
      data: unit.toMap(
        update: true,
        win: time,
      ),
      func: Func.add,
    );
    // if (win) _unitStream.update(cid);
    return id;
  }

  Future<void> setUnit(String cid, Unit unit, {bool delete = false}) async {
    DateTime? time = win ? await RealTime.timestamp() : null;
    await converter(
      path: APIPath.unit(cid, unit.id),
      data: unit.toMap(update: !delete, del: delete, win: time),
      func: Func.sett,
    );
    // if (win) _unitStream.update(cid);
  }

  // Future<void> deleteUnit(String cid, String uid) async {
  //   await converter(path: APIPath.unit(cid, uid), func: Func.delete);
  //   // if (win) _unitStream.update(uid);
  // }

  // Future<List<Unit>> unitsStream(String cid) {
  //   // if (win) {
  //   //   _unitStream.update(cid);
  //   //   return _unitStream.stream;
  //   // } else {
  //     return _service.getCollection(
  //       path: APIPath.units(cid),
  //       builder: (data, id) => Unit.fromMap(data, id),
  //     );
  //   // }
  // }

  Future<List<Unit>> getUpdateUnits(String cid, Timestamp lastUpdate) {
    if (win) {
      // _unitStream.update(uid);
      return _real.collectionStream(
          path: APIPath.units(cid),
          builder: (data, id) => Unit.fromMap(data, id, win: true),
          queryBuilder: (query) => query
              .where('lastUpdate', isGreaterThan: lastUpdate.toDate())
              .where('delete', isNull: true));
    } else {
      return _service.getCollection(
          path: APIPath.units(cid),
          builder: (data, id) => Unit.fromMap(data, id),
          queryBuilder: (query) => query
              .where('lastUpdate', isGreaterThan: lastUpdate)
              .where('delete', isNull: true));
    }
  }

  Future<List<Unit>> getDeleteUnits(String cid, Timestamp lastDelete) {
    if (win) {
      // _unitStream.update(uid);
      return _real.collectionStream(
        path: APIPath.units(cid),
        builder: (data, id) => Unit.fromMap(data, id, win: true),
        queryBuilder: (query) =>
            query.where('delete', isGreaterThan: lastDelete.toDate()),
      );
    } else {
      return _service.getCollection(
        path: APIPath.units(cid),
        builder: (data, id) => Unit.fromMap(data, id),
        queryBuilder: (query) =>
            query.where('delete', isGreaterThan: lastDelete),
      );
    }
  }

  // report
  Future<String> addReport(String cid, Report report) async {
    DateTime? time = win ? await RealTime.timestamp() : null;
    String id = await converter(
      path: APIPath.reports(cid),
      data: report.toMap(update: true, win: time),
      func: Func.add,
    );
    // if (win) _reportStream.update(cid);
    return id;
  }

  Future<void> setReport(String cid, Report report,
      {bool delete = false}) async {
    DateTime? time = win ? await RealTime.timestamp() : null;
    await converter(
      path: APIPath.report(cid, report.id),
      data: report.toMap(update: delete ? false : true, del: delete, win: time),
      func: Func.sett,
    );
    // if (win) _reportStream.update(cid);
  }

  Future<void> updateReport(
    String cid,
    String rid,
    Map<String, dynamic> data,
  ) async {
    await _service.updateData(path: APIPath.report(cid, rid), data: data);
    // if (win) _reportStream.update(cid);
  }

  // Future<void> deleteReport(String cid, String uid) async {
  //   await converter(path: APIPath.report(cid, uid), func: Func.delete);
  //   // if (win) _reportStream.update(uid);
  // }

  // Future<List<Report>> reportsStream(String cid) {
  //   // if (win) {
  //   //   // _reportStream.update(cid);
  //   //   // return _reportStream.stream;
  //   // } else {
  //     return _service.getCollection(
  //       path: APIPath.reports(cid),
  //       builder: (data, id) => Report.fromMap(data, id),
  //     );
  //   // }
  // }

  Future<List<Report>> getUpdateReports(String cid, Timestamp lastUpdate) {
    if (win) {
      // _reportStream.update(uid);
      return _real.collectionStream(
          path: APIPath.reports(cid),
          builder: (data, id) => Report.fromMap(data, id, win: true),
          queryBuilder: (query) => query
              .where('lastUpdate', isGreaterThan: lastUpdate.toDate())
              .where('delete', isNull: true));
    } else {
      return _service.getCollection(
          path: APIPath.reports(cid),
          builder: (data, id) => Report.fromMap(data, id),
          queryBuilder: (query) => query
              .where('lastUpdate', isGreaterThan: lastUpdate)
              .where('delete', isNull: true));
    }
  }

  Future<List<Report>> getDeleteReports(String cid, Timestamp lastDelete) {
    if (win) {
      // _reportStream.update(uid);
      return _real.collectionStream(
        path: APIPath.reports(cid),
        builder: (data, id) => Report.fromMap(data, id, win: true),
        queryBuilder: (query) =>
            query.where('delete', isGreaterThan: lastDelete.toDate()),
      );
    } else {
      return _service.getCollection(
        path: APIPath.reports(cid),
        builder: (data, id) => Report.fromMap(data, id),
        queryBuilder: (query) => query
            .where('delete', isGreaterThan: lastDelete)
            .where('delete', isNull: true),
      );
    }
  }

// type
//  Future<String> addAcType(AcType acType) async {
//     String id = await converter(
//       path: APIPath.acTypes(),
//       data: acType.toMap(add: true),
//       func: Func.add,
//     );
//     // if (win) _acTypeStream.update(cid);
//     return id;
//   }

//   Future<void> setAcType(AcType acType, {bool delete = false}) async {
//     await converter(
//       path: APIPath.acType(acType.id),
//       data: acType.toMap(add: !delete , del: delete),
//       func: Func.sett,
//     );
//     // if (win) _acTypeStream.update(cid);
//   }

//   // Future<void> deleteAcType(String uid) async {
//   //   await converter(path: APIPath.acType(cid, uid), func: Func.delete);
//   //   // if (win) _acTypeStream.update(uid);
//   // }

//   // Stream<List<AcType?>?> acTypesStream(String cid) {
//   //   if (win) {
//   //     _acTypeStream.update(cid);
//   //     return _acTypeStream.stream;
//   //   } else {
//   //     return _service.collectionStream(
//   //       path: APIPath.acTypes(cid),
//   //       builder: (data, id) => AcType.fromMap(data, id),
//   //     );
//   //   }
//   // }

//   Future<List<AcType>> getUpdateAcTypes(Timestamp lastUpdate) {
//     if (win) {
//       // _acTypeStream.update(uid);
//       return _real.collectionStream(
//           path: APIPath.acTypes(),
//           builder: (data, id) => AcType.fromMap(data, id),
//           queryBuilder: (query) =>
//               query.where('lastUpdate', isGreaterThan: lastUpdate));
//     } else {
//       return _service.getCollection(
//           path: APIPath.acTypes(),
//           builder: (data, id) => AcType.fromMap(data, id),
//           queryBuilder: (query) =>
//               query.where('lastUpdate', isGreaterThan: lastUpdate));
//     }
//   }

//   Future<List<AcType>> getDeleteAcTypes(Timestamp lastDelete) {
//     if (win) {
//       // _acTypeStream.update(uid);
//       return _real.collectionStream(
//         path: APIPath.acTypes(),
//         builder: (data, id) => AcType.fromMap(data, id),
//         queryBuilder: (query) =>
//             query.where('delete', isGreaterThan: lastDelete),
//       );
//     } else {
//       return _service.getCollection(
//         path: APIPath.acTypes(),
//         builder: (data, id) => AcType.fromMap(data, id),
//         queryBuilder: (query) =>
//             query.where('delete', isGreaterThan: lastDelete),
//       );
//     }
//   }

// checklist

  Future<String> addChecklist(Checklist checklist) async {
    DateTime? time = win ? await RealTime.timestamp() : null;
    String id = await converter(
      path: APIPath.checklists(),
      data: checklist.toMap(add: true, win: time),
      func: Func.add,
    );
    // if (win) _checklistStream.update(cid);
    return id;
  }

  Future<void> setChecklist(Checklist checklist, {bool delete = false}) async {
    DateTime? time = win ? await RealTime.timestamp() : null;
    await converter(
      path: APIPath.checklist(checklist.id),
      data: checklist.toMap(add: delete ? false : true, del: delete, win: time),
      func: Func.sett,
    );
    // if (win) _checklistStream.update(cid);
  }

  // Future<void> deleteChecklist(String uid) async {
  //   await converter(path: APIPath.checklist(cid, uid), func: Func.delete);
  //   // if (win) _checklistStream.update(uid);
  // }

  // Stream<List<Checklist?>?> checklistsStream(String cid) {
  //   if (win) {
  //     _checklistStream.update(cid);
  //     return _checklistStream.stream;
  //   } else {
  //     return _service.collectionStream(
  //       path: APIPath.checklists(cid),
  //       builder: (data, id) => Checklist.fromMap(data, id),
  //     );
  //   }
  // }

  Future<List<Checklist>> getUpdateChecklists(Timestamp lastUpdate) {
    if (win) {
      // _checklistStream.update(uid);
      // f.
      return _real.collectionStream(
          path: APIPath.checklists(),
          builder: (data, id) => Checklist.fromMap(data, id, win: true),
          queryBuilder: (query) =>
              query.where('added', isGreaterThan: lastUpdate.toDate()));
    } else {
      return _service.getCollection(
          path: APIPath.checklists(),
          builder: (data, id) => Checklist.fromMap(data, id),
          queryBuilder: (query) =>
              query.where('added', isGreaterThan: lastUpdate));
    }
  }

  Future<List<Checklist>> getDeleteChecklists(Timestamp lastDelete) {
    if (win) {
      // _checklistStream.update(uid);
      return _real.collectionStream(
        path: APIPath.checklists(),
        builder: (data, id) => Checklist.fromMap(data, id, win: true),
        queryBuilder: (query) =>
            query.where('delete', isGreaterThan: lastDelete.toDate()),
      );
    } else {
      return _service.getCollection(
        path: APIPath.checklists(),
        builder: (data, id) => Checklist.fromMap(data, id),
        queryBuilder: (query) =>
            query.where('delete', isGreaterThan: lastDelete),
      );
    }
  }

  // client

  Future<String> addClient(Client client) async {
    DateTime? time = win ? await RealTime.timestamp() : null;
    String cid = await converter(
      path: APIPath.clients(),
      data: client.toMap(win: time),
      func: Func.add,
    );

    if (win) _clientsStream.update();

    return cid;
  }

  Future<void> setClient(
    Client client, {
    bool unitUpdate = false,
    bool unitDel = false,
    bool reportUpdate = false,
    bool reportDel = false,
  }) async {
    DateTime? time = win ? await RealTime.timestamp() : null;
    await converter(
      path: APIPath.client(client.id),
      data: client.toMap(
        unitUpdate: unitUpdate,
        unitDel: unitDel,
        reportUpdate: reportUpdate,
        reportDel: reportDel,
        win: time,
      ),
      func: Func.sett,
    );
    if (win) _clientStream.update(client.id);
  }

  Future<void> deleteClient(String id) async {
    await converter(path: APIPath.client(id), func: Func.delete);
    if (win) _clientsStream.update();
  }

  Stream<Client?> clientStream(String cid) {
    if (win) {
      _clientStream.update(cid);
      return _clientStream.stream;
    } else {
      return _service.documentStream(
        path: APIPath.client(cid),
        builder: (data, id) => Client.fromMap(data, id),
      );
    }
  }

  Stream<List<Client?>?> clientsStream() {
    if (win) {
      _clientsStream.update();
      return _clientsStream.stream;
    } else {
      return _service.collectionStream(
        path: APIPath.clients(),
        builder: (data, id) => Client.fromMap(data, id),
      );
    }
  }

// agent
  Future<void> setAgent(Agent agent) async {
    await converter(
      path: APIPath.agent(agent.id),
      data: agent.toMap(),
      func: Func.sett,
    );
    if (win) _agentStream.update(agent.id);
  }

  Future<void> deleteAgent(String id) async {
    await converter(path: APIPath.agent(id), func: Func.delete);
    if (win) _agentStream.update(id);
  }

  Stream<Agent?> agentStream(String uid) {
    if (win) {
      _agentStream.update(uid);
      return _agentStream.stream;
    } else {
      return _service.documentStream(
        path: APIPath.agent(uid),
        builder: (data, id) => Agent.fromMap(data, id),
      );
    }
  }

  Stream<List<Agent?>?> agentsStream(String cid) {
    if (win) {
      _agentsStream.update(cid);
      return _agentsStream.stream;
    } else {
      return _service.collectionStream(
        path: APIPath.agents(),
        builder: (data, id) => Agent.fromMap(data, id),
        queryBuilder: (query) => query.where('cid', isEqualTo: cid),
      );
    }
  }
}
