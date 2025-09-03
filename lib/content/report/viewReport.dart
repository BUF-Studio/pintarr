import 'package:flutter/material.dart';
import 'package:pintarr/content/report/reportData.dart';
import 'package:pintarr/model/agent.dart';
import 'package:pintarr/model/client.dart';
import 'package:pintarr/model/report.dart';
import 'package:pintarr/model/reportType.dart';
import 'package:pintarr/model/unit.dart';
import 'package:pintarr/service/controller/checklistController.dart';
import 'package:pintarr/service/controller/reportController.dart';
import 'package:pintarr/service/controller/unitController.dart';
import 'package:pintarr/service/fire/database.dart';
import 'package:pintarr/service/format.dart';
import 'package:pintarr/service/pdf.dart';
import 'package:pintarr/service/realTime.dart';
import 'package:pintarr/service/stream/reportStream.dart';
import 'package:pintarr/widget/alert.dart';
import 'package:pintarr/widget/button.dart';
import 'package:pintarr/widget/textDetail.dart';
import 'package:provider/provider.dart';

class ViewReport extends StatefulWidget {
  final Report report;
  final Unit unit;

  const ViewReport(this.report, this.unit, {Key? key}) : super(key: key);

  @override
  _ViewReportState createState() => _ViewReportState();
}

class _ViewReportState extends State<ViewReport> {
  Report? rep;

  @override
  Widget build(BuildContext context) {
    rep ??= widget.report;
    final client = Provider.of<Client?>(context);
    final agent = Provider.of<Agent?>(context);

    final Database database = Provider.of<Database>(context);

    final List<Unit> units = Provider.of<List<Unit>>(context);
    // final Agent agent = Provider.of<Agent?>(context);
    final bool win = Provider.of<bool>(context);

    final UnitsController unitsController =
        Provider.of<UnitsController>(context);

    final ReportsController reportsController =
        Provider.of<ReportsController>(context);

    final Pdf pdf = Provider.of<Pdf>(context);

    // print('Report data');
    // print(rep!.version);

    return Column(
      children: [
        // Container(
        //   margin: EdgeInsets.symmetric(vertical: 12),
        //   height: 135,
        //   child: Center(
        //     child: GestureDetector(
        //       onTap: () {
        //         page.updateReport(ReportPages.qr, report.uid);
        //         // Navigator.of(context).push(MaterialPageRoute(
        //         //     builder: (context) =>
        //         //         ViewQr(unit.unitname, cli.name, unit.id)));
        //         // _view = true;
        //       },
        //       child: QrManager.create(report.uid),
        //     ),
        //   ),
        // ),
        TextDetail('Unit Name', rep!.unitname),
        TextDetail('Report', reportTypeToString(rep!.reportType)!),
        TextDetail('Unit Condition', rep!.current),
        TextDetail('Submitted By', rep!.by),
        TextDetail('Date', Format.epochToString(rep!.date)),
        if (rep!.checked) TextDetail('Checked By', rep!.checkBy!),
        if (rep!.checked)
          TextDetail('Checked On', Format.epochToString(rep!.checkdate)),
        const SizedBox(
          height: 20,
        ),
        TextDetail('Report Detail', ''),

        ReportData(rep!.data, rep!.type, rep!.version),

        TextDetail('Comment', ''),
        // TextDetail(rep.comment, ''),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  rep!.comment,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.left,
                ),
              ),
              const Text(''),
            ],
          ),
        ),

        if ((!agent!.pintar || (agent.pintar && agent.admin)) && !rep!.checked)
          Button(
            text: 'Check Report',
            press: () async {
              DateTime t;
              try {
                t = await RealTime.now();
              } catch (e) {
                t = DateTime.now();
              }

              Report rpt = rep!.copy();
              rpt.checked = true;
              rpt.checkBy = agent.username;
              rpt.checkdate = t.millisecondsSinceEpoch;

              reportsController.updateReport(rpt);

              // print('unit');
              // print(widget.unit);

              // Unit ut =
              //     units.firstWhere((e) => e.id == report.uid, orElse: () => null);
              if (widget.unit != null) {
                Unit u = widget.unit.copy();
                u.current = rep!.current;
                if (rep!.reportType == ReportType.minor ||
                    rep!.reportType == ReportType.major ||
                    rep!.reportType == ReportType.month ||
                    rep!.reportType == ReportType.half ||
                    rep!.reportType == ReportType.year) {
                  u.lastMonthService = rep!.date;

                  if (rep!.reportType == ReportType.half ||
                      rep!.reportType == ReportType.year) {
                    u.lastHalfService = rep!.date;
                    if (rep!.reportType == ReportType.year) {
                      u.lastYearService = rep!.date;
                    }
                  }
                }

                unitsController.updateUnit(u);

                // database.setUnit(rep!.cid, u);
              }

              setState(() {
                rep = rpt;
              });

              // try {
              //   await Pdf(checklistsController).serviceReports([report],
              //       '${report.date}_${report.unitname}_${client!.name}');

              //   return Alert.box(
              //       context,
              //       'Downloaded',
              //       Text(
              //           'Report successfully downloaded. Please check your download folder.'),
              //       <Widget>[
              //         Alert.ok(context, () {
              //           Navigator.pop(context);
              //         }, 'Ok')
              //       ]);
              // } catch (e) {
              //   return Alert.box(
              //       context,
              //       'Failed',
              //       Text('Cant find download directory. Failed to download.'),
              //       <Widget>[
              //         Alert.ok(context, () {
              //           Navigator.pop(context);
              //         }, 'Ok')
              //       ]);
              // }
            },
          ),

        Button(
          text: 'Download Report',
          press: () async {
            // print(rep.checked);
            // print(rep.checkBy);
            try {
              await pdf.serviceReports(
                  [rep!], '${rep!.date}_${rep!.unitname}_${client!.name}');

              return Alert.box(
                  context,
                  'Downloaded',
                  const Text(
                      'Report successfully downloaded. Please check your download folder.'),
                  <Widget>[
                    Alert.ok(context, () {
                      Navigator.pop(context);
                    }, 'Ok')
                  ]);
            } catch (e) {
              return Alert.box(
                  context,
                  'Failed',
                  const Text(
                      'Cant find download directory. Failed to download.'),
                  <Widget>[
                    Alert.ok(context, () {
                      Navigator.pop(context);
                    }, 'Ok')
                  ]);
            }
          },
        ),

        // TextDetail('File', ''),
      ],
    );
  }
}
