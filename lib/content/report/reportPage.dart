import 'package:flutter/material.dart';
import 'package:pintarr/content/report/list/monthReportPage.dart';
import 'package:pintarr/content/report/main/mainReport.dart';
import 'package:pintarr/content/report/reportDetailPage.dart';
import 'package:pintarr/model/report.dart';
import 'package:provider/provider.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final page = Provider.of<ReportNavi>(context);
    switch (page.page) {
      case ReportPages.main:
        return MainReport();
      case ReportPages.detail:
        return ReportDetailPage();
      case ReportPages.mon:
        return MonthReportPage();
      // case ReportPages.edit:
      //   return EditReport();
      //   break;
      // case ReportPages.list:
      //   return ReportListPage();
      //   break;
      // case ReportPages.qr:
      //   return ViewReportQr();
      //   break;
      // default:
    }
  }
}

class ReportNavi extends ChangeNotifier {
  ReportPages page = ReportPages.main;
  Report? report;
  Report? bck;
  String search = '';
  String? type;
  String? location;
  String? current;
  bool comment =false;
  bool filter =false;
  // int? mon;
  // Unit unit;
  // Report report;

  void updateReport(
    ReportPages newPage, {
    Report? rpt,
    Report? back,
    String? src,
    String? typ,
    String? loc,
    String? cur,
    bool? com,
    bool? fil,
    // int? nmon,
  }

      // Unit ut,
      ) {
    page = newPage;
    report = rpt;
    bck = back;
    if (src != null) search = src;
    if (src != null) current = cur;
    if (com != null) comment = com;
    if (fil != null) filter = fil;
   if(typ!=null) type = typ;
   if(loc!=null) location = loc;

    notifyListeners();
  }
}

enum ReportPages { main, detail, mon }
