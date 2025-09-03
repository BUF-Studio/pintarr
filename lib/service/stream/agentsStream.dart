import 'dart:async';

import 'package:pintarr/model/agent.dart';
import 'package:pintarr/service/fire/api_path.dart';
import 'package:pintarr/service/fire/realDatabase.dart';
import 'package:rxdart/subjects.dart';

class AgentsStream {
  final RealDatabase database;
  AgentsStream(this.database);

  StreamController<List<Agent>?> _controller = BehaviorSubject<List<Agent>?>();
  Stream<List<Agent?>?> get stream => _controller.stream;

  void dispose() {
    _controller.close();
  }

  void setData(List<Agent> data) => _controller.add(data);

  getAgents(cid) async {
    List<Agent?> acc = await database.collectionStream(
      path: APIPath.agents(),
      builder: (data, id) => Agent.fromMap(data, id),
      queryBuilder: (query) => query.where('cid', isEqualTo: cid),
    );
    return acc;
  }

  update(cid) async {
    List<Agent> acc = await getAgents(cid);
    setData(acc);
  }
}
