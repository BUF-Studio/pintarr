import 'package:flutter/material.dart';
import 'package:pintarr/content/unit/report/unitReportDetailMobile.dart';
import 'package:pintarr/content/unit/unitPage.dart';
import 'package:pintarr/model/report.dart';
import 'package:pintarr/model/reportType.dart';
import 'package:pintarr/model/unit.dart';
import 'package:pintarr/service/format.dart';
import 'package:pintarr/widget/empty.dart';
import 'package:pintarr/widget/responsive.dart';
import 'package:pintarr/widget/tile.dart';
import 'package:provider/provider.dart';

class ReportList extends StatelessWidget {
  final Unit unit;
  const ReportList(this.unit, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final reports = Provider.of<List<Report>>(context);
    final page = Provider.of<UnitNavi>(context);
    List<Report> report = [];

    report.addAll(reports.where((e) => e.uid == unit.id));

    return report.isEmpty
        ? Empty('No Report Found')
        : ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: report.length,
            itemBuilder: (context, index) {
              color() {
                if (!report[index].checked) return Colors.grey;
                if (report[index].current == 'Good') return Colors.green;
                if (report[index].current == 'Problem') return Colors.orange;
                if (report[index].current == 'Down') return Colors.red;
                return Colors.grey;
              }

              return Tile(
                title: Text(reportTypeToString(report[index].reportType)!),
                subtitle: Text(Format.epochToString(report[index].date)),
                tap: () {
                  if (!Responsive.isMobile(context)) {
                    page.updateUnit(UnitPages.view,
                        ut: page.unit, rpt: report[index]);
                  }
                  if (Responsive.isMobile(context)) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              UnitReportDetailMobile(report[index], unit),
                        ));
                  }
                },
                trail: const Icon(Icons.arrow_forward_ios),
                lead: Icon(
                  Icons.verified,
                  color: color(),
                ),
              );
            });
  }
}
