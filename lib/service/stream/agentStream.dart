import 'dart:async';

import 'package:pintarr/model/agent.dart';
import 'package:pintarr/service/fire/api_path.dart';
import 'package:pintarr/service/fire/realDatabase.dart';
import 'package:rxdart/subjects.dart';

class AgentStream {
  final RealDatabase database;
  AgentStream(this.database);

  final StreamController<Agent?> _controller = BehaviorSubject<Agent>();
  Stream<Agent?> get stream => _controller.stream;

  void dispose() {
    _controller.close();
  }

  void setData(Agent? data) => _controller.add(data);

  update(uid) async {
    Agent? agg = await database.documentStream(
      path: APIPath.agent(uid),
      builder: (data, id) => Agent.fromMap(data, id),
    );
    setData(agg);
  }
}
