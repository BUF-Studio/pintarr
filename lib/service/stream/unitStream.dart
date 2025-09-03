// import 'dart:async';

// import 'package:pintarr/model/unit.dart';
// import 'package:pintarr/service/fire/api_path.dart';
// import 'package:pintarr/service/fire/realDatabase.dart';
// import 'package:rxdart/subjects.dart';

// class UnitStream {
//   final RealDatabase database;
//   UnitStream(this.database);

//   StreamController<List<Unit>> _controller = BehaviorSubject<List<Unit>>();
//   Stream<List<Unit>> get stream => _controller.stream;

//   void dispose() {
//     _controller.close();
//   }

//   void setData(List<Unit> data) => _controller.add(data);

//   update(uid) async {
//     List<Unit> acc = await database.collectionStream(
//       path: APIPath.units(uid),
//       builder: (data, id) => Unit.fromMap(data, id),
//     );
//     setData(acc);
//   }
// }
