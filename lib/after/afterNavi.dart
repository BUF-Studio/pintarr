import 'package:flutter/material.dart';
import 'package:pintarr/after/after.dart';

class AfterPage extends StatelessWidget {
  const AfterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const After();
  }
}

class AfterNavi extends ChangeNotifier {
  AfterPages page = AfterPages.dashboard;
  // String cid;
  // List<Client> client = [];

  void updatePage(AfterPages newPage) async {
    page = newPage;
    // cid = id;

    notifyListeners();
  }
}

enum AfterPages {
  dashboard,
  unit,
  report,
  user,
  setting,
}
