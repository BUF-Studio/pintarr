// import 'dart:async';

// import 'package:pintarr/model/report.dart';
// import 'package:pintarr/service/fire/api_path.dart';
// import 'package:pintarr/service/fire/realDatabase.dart';
// import 'package:rxdart/subjects.dart';

// class ReportStream {
//   final RealDatabase database;
//   ReportStream(this.database);

//   StreamController<List<Report>> _controller = BehaviorSubject<List<Report>>();
//   Stream<List<Report>> get stream => _controller.stream;

//   void dispose() {
//     _controller.close();
//   }

//   void setData(List<Report> data) => _controller.add(data);

//   update(uid) async {
//     List<Report> acc = await database.collectionStream(
//       path: APIPath.reports(uid),
//       builder: (data, id) => Report.fromMap(data, id),
//     );
//     setData(acc);
//   }
// }
