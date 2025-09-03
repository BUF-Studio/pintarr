import 'package:flutter/material.dart';
import 'package:pintarr/color.dart';
import 'package:pintarr/model/report.dart';
import 'package:pintarr/model/reportType.dart';
import 'package:pintarr/widget/chart.dart';

class ReportSum extends StatelessWidget {
  final List<Report> report;
  const ReportSum(this.report, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // final Client client = Provider.of<Client?>(context);
    // print('sum');
    // print(report.length);
    var service = report
        .where((e) =>
            e.reportType == ReportType.minor ||
            e.reportType == ReportType.major ||
            e.reportType == ReportType.month ||
            e.reportType == ReportType.half ||
            e.reportType == ReportType.year)
        .length;
    // var major = report.where((e) => e.reportType == 'Major Service').length;
    var repair = report.where((e) => e.reportType == ReportType.repair).length;
    var down = report.where((e) => e.reportType == ReportType.breakdown).length;

    return Container(
        child: Column(
      children: [
        // PageButt('Download Full Reports', () {}),
        Row(
          children: [
            Expanded(
              child: Chart(
                center: service.toString(),
                color: lightBlue,
                percent: report.isEmpty ? 0 : service / report.length,
                title: 'Service',
              ),
            ),
            Expanded(
              child: Chart(
                center: repair.toString(),
                color: Colors.orange,
                percent: report.isEmpty ? 0 : repair / report.length,
                title: 'Repair',
              ),
            ),
            Expanded(
              child: Chart(
                center: down.toString(),
                color: Colors.red,
                percent: report.isEmpty ? 0 : down / report.length,
                title: 'Breakdown',
              ),
            ),
          ],
        ),
      ],
    ));
  }
}
