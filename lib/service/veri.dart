import 'package:flutter/material.dart';

class Veri extends ChangeNotifier {
  bool ver = false;

  void update(bool verr)async{
    
    ver = verr;
    notifyListeners();
  }
}