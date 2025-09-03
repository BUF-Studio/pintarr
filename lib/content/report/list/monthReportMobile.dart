import 'package:flutter/material.dart';
import 'package:pintarr/content/dashboard/reportSum.dart';
import 'package:pintarr/content/mobile.dart';
import 'package:pintarr/content/report/list/monthReportList.dart';
import 'package:pintarr/model/client.dart';
import 'package:pintarr/model/report.dart';
import 'package:pintarr/model/unit.dart';
import 'package:pintarr/service/controller/checklistController.dart';
import 'package:pintarr/service/controller/unitController.dart';
import 'package:pintarr/service/format.dart';
import 'package:pintarr/service/pdf.dart';
import 'package:pintarr/widget/alert.dart';
import 'package:pintarr/widget/tile.dart';
import 'package:provider/provider.dart';

class MonthReportMobile extends StatelessWidget {
  final int mon;
  const MonthReportMobile(this.mon, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    dld() {
      return Alert.box(
          context,
          'Downloaded',
          Text(
              'Reports successfully downloaded. Please check your download folder.'),
          <Widget>[
            Alert.ok(context, () {
              Navigator.pop(context);
            }, 'Ok')
          ]);
    }

    fail() {
      return Alert.box(context, 'Failed',
          Text('Cant find download directory. Failed to download.'), <Widget>[
        Alert.ok(context, () {
          Navigator.pop(context);
        }, 'Ok')
      ]);
    }

    final List<Report> reports = Provider.of<List<Report>>(context);
    final List<Unit> units = Provider.of<List<Unit>>(context);
    // final UnitsController unitsController = Provider.of<UnitsController>(context);

    final Client? client = Provider.of<Client?>(context);
    // final ReportNavi page = Provider.of<ReportNavi>(context);
    final Pdf pdf = Provider.of<Pdf>(context);

    List<Report> report = [];
    report.addAll(reports.where((e) => e.mon == mon));

    // print(report.length);
    return Mobile(
      title: Format.intToString(mon),
      action: [
        IconButton(
          icon: const Icon(Icons.file_download),
          onPressed: () {
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
                    //           '${client.name}_${mon}_CompactReport');
                    //       Navigator.pop(context);
                    //       dld();
                    //     } catch (e) {
                    //       fail();
                    //     }
                    //   },
                    // ),
                    Tile(
                      title: Text('Normal Report'),
                      tap: () async {
                        try {
                          await pdf.serviceReports(
                              reports.where((e) => e.mon == mon).toList(),
                              '${client!.name}_${mon}_NormalReport');
                          Navigator.pop(context);
                          dld();
                        } catch (e) {
                          fail();
                        }
                      },
                    ),
                  ],
                ),
                <Widget>[
                  Alert.cancel(context),
                ]);
          },
        ),
      ],
      body: Column(
        children: [
          // Padding(
          //   padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          //   child: ReportSum(report),
          // ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Card(
              // padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ReportSum(report),
              ),
            ),
          ),
          MonthReportList(report),
        ],
      ),
    );
  }
}
