import 'dart:async';

import 'package:pintarr/model/client.dart';
import 'package:pintarr/service/fire/api_path.dart';
import 'package:pintarr/service/fire/realDatabase.dart';
import 'package:rxdart/subjects.dart';

class ClientStream {
  final RealDatabase database;
  ClientStream(this.database);

  StreamController<Client?> _controller = BehaviorSubject<Client?>();
  Stream<Client?> get stream => _controller.stream;

  void dispose() {
    _controller.close();
  }

  void setData(Client? data) => _controller.add(data);

  update(cid) async {
    Client? acc = await database.documentStream(
      path: APIPath.client(cid),
      builder: (data, id) => Client.fromMap(data, id,win: true),
    );
    setData(acc);
  }
}
