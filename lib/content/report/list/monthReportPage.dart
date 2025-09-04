import 'package:flutter/material.dart';
import 'package:pintarr/content/dashboard/reportSum.dart';
import 'package:pintarr/content/report/list/monthReportList.dart';
import 'package:pintarr/content/report/reportPage.dart';
import 'package:pintarr/model/client.dart';
import 'package:pintarr/model/report.dart';
import 'package:pintarr/model/unit.dart';
import 'package:pintarr/service/format.dart';
import 'package:pintarr/service/pdf.dart';
import 'package:pintarr/widget/alert.dart';
import 'package:pintarr/widget/tile.dart';
import 'package:pintarr/widget/title.dart';
import 'package:provider/provider.dart';

class MonthReportPage extends StatelessWidget {
  const MonthReportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final page = Provider.of<ReportNavi>(context);
    // final UnitsController unitsController = Provider.of<UnitsController>(context);
    final List<Unit> units = Provider.of<List<Unit>>(context);
    final List<Report> reports = Provider.of<List<Report>>(context);
    // final ReportNavi page = Provider.of<ReportNavi>(context);
    final Client? client = Provider.of<Client?>(context);
    final Pdf pdf = Provider.of<Pdf>(context);

    dld() {
      return Alert.box(
          context,
          'Downloaded',
          const Text(
              'Reports successfully downloaded. Please check your download folder.'),
          <Widget>[
            Alert.ok(context, () {
              Navigator.pop(context);
            }, 'Ok')
          ]);
    }

    fail() {
      return Alert.box(
          context,
          'Failed',
          const Text('Cant find download directory. Failed to download.'),
          <Widget>[
            Alert.ok(context, () {
              Navigator.pop(context);
            }, 'Ok')
          ]);
    }

    List<Report> report = [];
    report.addAll(reports.where((e) => e.mon == page.report!.mon));
    // print('report');
    // print(report.length);
    return PageTemp(
      onBack: () {
        page.updateReport(ReportPages.main);
      },
      sub: PageButt(
        'Download Monthly Report',
        onTap: () {
          Alert.box(
              context,
              'Download',
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Tile(
                  //   title: Text('Compact Report'),
                  //   tap: () async {
                  //     try {
                  //       await Pdf().serviceReports(reports, false,
                  //           '${client.name}_${page.report.mon}_CompactReport');
                  //       Navigator.pop(context);
                  //       dld();
                  //     } catch (e) {
                  //       fail();
                  //     }
                  //   },
                  // ),
                  Tile(
                    title: const Text('Normal Report'),
                    tap: () async {
                      try {
                        await pdf.serviceReports(
                            reports
                                .where((e) => e.mon == page.report!.mon)
                                .toList(),
                            '${client!.name}_${page.report!.mon}_NormalReport');
                        // print('hhe');
                        // await Pdf().serviceReports(reports, true,'');
                        Navigator.pop(context);

                        dld();
                      } catch (e) {
                        fail();
                      }
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              <Widget>[
                Alert.cancel(context),
              ]);
        },
      ),
      title: Format.intToString(page.report!.mon),
      children: [
        ListView(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          children: [
            ReportSum(report),
            MonthReportList(report),
          ],
        ),
        // four chart
      ],
    );
  }
}
