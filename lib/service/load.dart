import 'package:flutter/material.dart';

class Load extends ChangeNotifier {
  bool load = false;

  void updateLoad(bool l)async{
    load = l;
    notifyListeners();
  }
}