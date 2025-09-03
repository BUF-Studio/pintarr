import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';

class RealDatabase {
  // final firebaseAuth = FirebaseAuth.initialize(apiKey, await HiveStore());
// final firestore = Firestore(projectId, auth: firebaseAuth);

  // Firestore.initialize(projectId);
  // final firestore =

  // Future init() async {
  //   await
  // }

  Future<T> documentStream<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String documentID) builder,
  }) async {
    var reference = await Firestore.instance.document(path).get();
    return builder(reference.map, reference.id);
  }

  Future<List<T>> collectionStream<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String documentID) builder,
    queryBuilder(query)?,
    // Query queryBuilder(Query query),
    // int sort(T lhs, T rhs),
  }) async {
    if (queryBuilder != null) {
      var que = Firestore.instance.collection(path);
      QueryReference query = queryBuilder(que);
      var reference = await query.get();
      return reference
          .map((e) => builder(e.map, e.id))
          .where((value) => value != null)
          .toList();
    } else {
      var reference = await Firestore.instance.collection(path).get();
      return reference
          .map((e) => builder(e.map, e.id))
          .where((value) => value != null)
          .toList();
    }
  }

  Future<void> deleteData({required String path}) async {
    await Firestore.instance.document(path).delete();
  }

  Future<void> setData({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    await Firestore.instance.document(path).set(data);
  }

  Future<void> updateData({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    await Firestore.instance.document(path).update(data);
  }

  Future<String> addData({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    var add = await Firestore.instance.collection(path).add(data);
    return add.id;
  }

  // final String url =
  //     'https://firestore.googleapis.com/v1/projects/copbot-f7fb5/databases/(default)/documents/';

  // Future document({
  //   required String path,
  //   required bool collection,
  //   // required T builder(Map<String, dynamic> data, String documentID),
  // }) async {
  //   final response = await http.get(Uri.parse(url + path));
  //   if (response.statusCode == 200) {
  //     // print(DocumentSnapshot.fromJson(jsonDecode(response.body)));
  //     if (!collection) return clean(jsonDecode(response.body));
  //     if (collection) {
  //       var data = [];
  //       var decode = jsonDecode(response.body);

  //       for (var da in decode['documents'] ?? []) {
  //         data.add(clean(da));
  //       }
  //       return data;
  //     }
  //   }
  // }

  // clean(Map<String, dynamic> data) {
  //   var documentId = data['name'].split('/').last;
  //   var field = data['fields'];
  //   return [documentId, field];
  // }
}
