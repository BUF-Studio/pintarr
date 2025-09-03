import 'package:flutter/material.dart';
import 'package:pintarr/content/report/main/selectUnCheckReport.dart';
import 'package:pintarr/model/agent.dart';
import 'package:pintarr/model/client.dart';
import 'package:pintarr/model/report.dart';
import 'package:pintarr/model/reportType.dart';
import 'package:pintarr/model/unit.dart';
import 'package:pintarr/service/controller/reportController.dart';
import 'package:pintarr/service/controller/unitController.dart';
import 'package:pintarr/service/fire/database.dart';
import 'package:pintarr/service/realTime.dart';
import 'package:pintarr/service/stream/reportStream.dart';
import 'package:pintarr/widget/title.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class UncheckReport extends StatelessWidget {
  const UncheckReport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Report> reports = Provider.of<List<Report>>(context);
    // final List<Unit> units = Provider.of<List<Unit>>(context);
    // final ReportNavi page = Provider.of<ReportNavi>(context);
    final Database database = Provider.of<Database>(context);
    final Client? client = Provider.of<Client?>(context);
    final Agent? agent = Provider.of<Agent?>(context);
    final bool win = Provider.of<bool>(context);
    final UnitsController unitsController =
        Provider.of<UnitsController>(context);
    final ReportsController reportsController =
        Provider.of<ReportsController>(context);

    List<Report> report = [];
    report.addAll(reports.where((e) => !e.checked && e.cid == client!.id));

    return PageTemp(
      refresh: win
          ? () {
              // reportStream!.update(client.id);
            }
          : null,
      title: 'Unchecked Reports',
      sub: !agent!.pintar || (agent.pintar && agent.admin)
          // ? null
          ? PageButt('Check All', onTap: () async {
              DateTime t;
              try {
                t = await RealTime.now();
              } catch (e) {
                t = DateTime.now();
              }
              for (var i in report) {
                if (i.current == 'Good') {
                  Report rpt = i.copy();
                  rpt.checked = true;
                  rpt.checkBy = agent.username;
                  rpt.checkdate = t.millisecondsSinceEpoch;

                  reportsController.updateReport(rpt);

                  Unit? ut = unitsController.units
                      .firstWhereOrNull((e) => e.id == i.uid);
                  if (ut != null) {
                    Unit u = ut.copy();
                    u.current = i.current;
                    if (i.reportType == ReportType.minor ||
                        i.reportType == ReportType.major ||
                        i.reportType == ReportType.month ||
                        i.reportType == ReportType.half ||
                        i.reportType == ReportType.year) {
                      u.lastMonthService = i.date;

                      if (i.reportType == ReportType.half ||
                          i.reportType == ReportType.year) {
                        u.lastHalfService = i.date;
                        if (i.reportType == ReportType.year)
                          u.lastYearService = i.date;
                      }
                    }

                    database.setUnit(i.cid, u);
                  }
                }
              }
            })
          : null,
      children: [
        Divider(),
        SelectUncheckReport(report),
      ],
    );
  }
}
