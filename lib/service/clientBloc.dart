import 'package:flutter/material.dart';

class ClientBloc extends ChangeNotifier {
  String? cid;

  void updateCid(String ncid) async {
    cid = ncid;
    notifyListeners();
  }
}
