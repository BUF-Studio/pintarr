import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pintarr/model/checklistItem.dart';
import 'package:pintarr/model/type.dart';

class Checklist {
  Checklist({
    this.id,
    required this.type,
    required this.item,
    required this.version,
    this.added,
    this.delete,
  });

  String? id;
  List<String> type;
  List<ChecklistItem> item;
  int version;
  Timestamp? added;
  Timestamp? delete;

  static List<String> _toString(list) {
    List<String> group = [];
    for (String? t in list) {
      group.add(t!);
    }
    return group;
  }

  static List<ChecklistItem> _toItem(list) {
    List<ChecklistItem> group = [];
    for (Map<String, dynamic> t in list) {
      group.add(ChecklistItem.fromMap(t));
    }
    return group;
  }

  static Checklist fromMap(Map<String, dynamic> data, id,
      {json = false, win = false}) {
    final List<String> type = _toString(data['type'] ?? []);
    final List<ChecklistItem> item = _toItem(data['item'] ?? []);
    final int version = data['version'];
    final Timestamp? added = json
        ? (data['added'] == null
            ? null
            : Timestamp.fromMillisecondsSinceEpoch(data['added']))
        : (win
            ? (data['added'] == null ? null : Timestamp.fromDate(data['added']))
            : data['added']);
    final Timestamp? delete = json
        ? (data['delete'] == null
            ? null
            : Timestamp.fromMillisecondsSinceEpoch(data['delete']))
        : (win
            ? (data['delete'] == null
                ? null
                : Timestamp.fromDate(data['delete']))
            : data['delete']);

    return Checklist(
      id: id,
      type: type,
      item: item,
      version: version,
      added: added,
      delete: delete,
    );
  }

  copy() => Checklist(
        id: id,
        type: type,
        item: item,
        version: version,
        added: added,
        delete: delete,
      );

  Map<String, dynamic> toMap({
    bool json = false,
    bool add = false,
    bool del = false,
    DateTime? win,
  }) {
    return {
      'type': type,
      'item': ChecklistItem.fromChecklistItem(item),
      'version': version,
      'added': add
          ? (win ?? FieldValue.serverTimestamp())
          : (json
              ? (added?.millisecondsSinceEpoch)
              : (win == null ? added : added?.toDate())),
      'delete': del
          ? (win ?? FieldValue.serverTimestamp())
          : (json
              ? (delete?.millisecondsSinceEpoch)
              : (win == null ? delete : delete?.toDate())),
    };
  }
}
