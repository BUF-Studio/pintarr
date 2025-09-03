import 'package:flutter/material.dart';
import 'package:pintarr/content/report/reportDetailMobile.dart';
import 'package:pintarr/content/report/reportPage.dart';
import 'package:pintarr/model/agent.dart';
import 'package:pintarr/model/report.dart';
import 'package:pintarr/model/reportType.dart';
import 'package:pintarr/model/unit.dart';
import 'package:pintarr/service/controller/reportController.dart';
import 'package:pintarr/service/controller/unitController.dart';
import 'package:pintarr/service/fire/database.dart';
import 'package:pintarr/service/realTime.dart';
import 'package:pintarr/service/stream/reportStream.dart';
import 'package:pintarr/service/stream/unitStream.dart';
import 'package:pintarr/widget/empty.dart';
import 'package:pintarr/widget/responsive.dart';
import 'package:pintarr/widget/tile.dart';
import 'package:pintarr/widget/title.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class SelectUncheckReport extends StatefulWidget {
  final List<Report> report;
  const SelectUncheckReport(this.report, {Key? key}) : super(key: key);
  @override
  _SelectUncheckReportState createState() => _SelectUncheckReportState();
}

class _SelectUncheckReportState extends State<SelectUncheckReport> {
  final List<Icon> icons = const [
    Icon(
      Icons.check_circle_outline,
      color: Colors.green,
    ),
    Icon(
      Icons.report_problem_outlined,
      color: Colors.orange,
    ),
    Icon(
      Icons.highlight_off,
      color: Colors.red,
    ),
    Icon(
      Icons.help_outline,
      color: Colors.grey,
    ),
  ];

  List<bool> select = [];
  bool all = false;

  @override
  Widget build(BuildContext context) {
    List<Report> report = widget.report;
    // final List<Unit> units = Provider.of<List<Unit>>(context);
    final ReportNavi page = Provider.of<ReportNavi>(context);
    final Database database = Provider.of<Database>(context);
    final Agent? agent = Provider.of<Agent?>(context);
    final bool win = Provider.of<bool>(context);
    final UnitsController unitsController =
        Provider.of<UnitsController>(context);
    final ReportsController reportsController =
        Provider.of<ReportsController>(context);

    if (select.isEmpty) {
      for (var i = 0; i < report.length; i++) {
        select.add(false);
      }
    }

    return report.isEmpty
        ? Empty('No Unchecked Report')
        : Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemBuilder: (context, index) {
                  icon() {
                    if (report[index].current == null) return icons[3];
                    if (report[index].current == 'Good') return icons[0];
                    if (report[index].current == 'Problem') return icons[1];
                    if (report[index].current == 'Down') return icons[2];
                    // return
                    return icons[3];
                  }

                  Unit? unit = unitsController.units
                      .firstWhereOrNull((e) => e.id == report[index].uid);
                  // select.add(false);

                  if (unit == null) {
                    print('fault');
                    print(report[index].id);
                    print(report[index].cid);
                    print(report[index].uid);
                  }

                  return Tile(
                    lead: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!agent!.pintar || (agent.pintar && agent.admin))
                          Checkbox(
                            value: all ? all : select[index],
                            onChanged: (v) {
                              setState(() {
                                if (!v!) {
                                  all = v;
                                }
                                select[index] = v;
                              });
                            },
                          ),
                        if (!agent.pintar || (agent.pintar && agent.admin))
                          const SizedBox(
                            width: 5,
                          ),
                        icon(),
                      ],
                    ),
                    title: Text(unit?.unitname ?? report[index].unitname),
                    subtitle:
                        Text('${unit?.type ?? ''} / ${unit?.location ?? ''}'),
                    tap: () {
                      if (!Responsive.isMobile(context)) {
                        page.updateReport(ReportPages.detail,
                            rpt: report[index]);
                      }
                      if (Responsive.isMobile(context)) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ReportDetailMobile(report[index]),
                            ));
                      }
                    },
                    trail: const Icon(Icons.arrow_forward_ios),
                  );
                },
                itemCount: report.length,
              ),
              if (!agent!.pintar || (agent.pintar && agent.admin))
                const Divider(),
              if (!agent.pintar || (agent.pintar && agent.admin))
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                                value: all,
                                onChanged: (v) {
                                  setState(() {
                                    all = v!;
                                  });
                                }),
                            const Text('Select All'),
                          ],
                        ),
                      ),
                      PageButt('Checked', onTap: () async {
                        DateTime t;
                        try {
                          t = await RealTime.now();
                        } catch (e) {
                          t = DateTime.now();
                        }
                        for (var i = 0; i < report.length; i++) {
                          if (select[i] || all) {
                            Report rpt = report[i].copy();
                            rpt.checked = true;
                            rpt.checkBy = agent.username;
                            rpt.checkdate = t.millisecondsSinceEpoch;

                            reportsController.updateReport(rpt);

                            Unit? ut = unitsController.units
                                .firstWhereOrNull((e) => e.id == report[i].uid);
                            if (ut != null) {
                              Unit u = ut.copy();
                              u.current = report[i].current;
                              u.lastMonthService = report[i].date;

                              if (report[i].reportType == ReportType.minor ||
                                  report[i].reportType == ReportType.major ||
                                  report[i].reportType == ReportType.month ||
                                  report[i].reportType == ReportType.half ||
                                  report[i].reportType == ReportType.year) {
                                u.lastMonthService = report[i].date;

                                if (report[i].reportType == ReportType.half ||
                                    report[i].reportType == ReportType.year) {
                                  u.lastHalfService = report[i].date;
                                  if (report[i].reportType == ReportType.year) {
                                    u.lastYearService = report[i].date;
                                  }
                                }
                              }
                              unitsController.updateUnit(u);
                            }
                          }
                        }
                        setState(() {
                          select = [];

                          all = false;
                        });
                      }),
                    ],
                  ),
                ),
              const SizedBox(
                height: 5,
              ),
            ],
          );
  }
}
