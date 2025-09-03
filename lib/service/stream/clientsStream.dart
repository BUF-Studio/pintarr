import 'dart:async';

import 'package:pintarr/model/client.dart';
import 'package:pintarr/service/fire/api_path.dart';
import 'package:pintarr/service/fire/realDatabase.dart';
import 'package:rxdart/subjects.dart';

class ClientsStream {
  final RealDatabase database;
  ClientsStream(this.database);

  StreamController<List<Client?>?> _controller = BehaviorSubject<List<Client?>?>();
  Stream<List<Client?>?> get stream => _controller.stream;

  void dispose() {
    _controller.close();
  }

  void setData(List<Client?>? data) => _controller.add(data);

  getClients() async {
    List<Client?>? acc = await database.collectionStream(
      path: APIPath.clients(),
      builder: (data, id) => Client.fromMap(data, id,win: true),
    );
    return acc;
  }

  update() async {
    List<Client?>? acc = await getClients();
    setData(acc);
  }
}
