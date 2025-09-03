import 'package:flutter/material.dart';
import 'package:pintarr/content/report/list/monthReportSearchList.dart';
import 'package:pintarr/model/report.dart';

class MonthReportList extends StatelessWidget {
  // final int mon;
  final List<Report> report;

  const MonthReportList(this.report, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SearchMonthReport(report);
  }
}
