import 'package:flutter/material.dart';
import 'package:pintarr/content/unit/detail/unitDetailPage.dart';
import 'package:pintarr/content/unit/detail/viewUnitQrPage.dart';
import 'package:pintarr/content/unit/edit/editUnitPage.dart';
import 'package:pintarr/content/unit/list/unitListPage.dart';
import 'package:pintarr/content/unit/main/mainUnit.dart';
import 'package:pintarr/content/unit/report/addReportPage.dart';
import 'package:pintarr/content/unit/report/unitReportDetailPage.dart';
import 'package:pintarr/model/report.dart';
import 'package:pintarr/model/unit.dart';
import 'package:provider/provider.dart';

class UnitPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final page = Provider.of<UnitNavi>(context);
    switch (page.page) {
      case UnitPages.detail:
        return UnitDetailPage();

      case UnitPages.main:
        return MainUnit();

      case UnitPages.edit:
        return EditUnitPage();

      case UnitPages.list:
        return UnitListPage();

      case UnitPages.qr:
        return ViewUnitQrPage();

      case UnitPages.report:
        return AddReportPage();

      case UnitPages.view:
        return UnitReportDetailPage();

      // default:
    }
  }
}

class UnitNavi extends ChangeNotifier {
  UnitPages page = UnitPages.main;
  Unit? unit;
  Unit? back;
  Report? report;
  // String? type;
  // String? location;

  void updateUnit(
    UnitPages newPage, {
    Unit? ut,
    Unit? backk,
    Report? rpt,
    // String? ntype,
    // String? nloc,
  }) {
    page = newPage;
    unit = ut;
    back = backk;
    report = rpt;
    // type = ntype;
    // location = nloc;
    // print('func');
    // print(page);
    // print(ut);
    // print(back);
    notifyListeners();
  }
}

enum UnitPages { main, list, edit, detail, qr, report, view }
