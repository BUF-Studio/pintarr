import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pintarr/content/report/main/monthlyReport.dart';
import 'package:pintarr/content/report/main/uncheckReport.dart';
import 'package:pintarr/model/checklist.dart';
import 'package:pintarr/model/client.dart';
import 'package:pintarr/model/report.dart';
import 'package:pintarr/model/type.dart';
import 'package:pintarr/service/controller/reportController.dart';
import 'package:pintarr/service/fire/database.dart';
import 'package:pintarr/widget/button.dart';
import 'package:provider/provider.dart';

class MainReport extends StatelessWidget {
  const MainReport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Database database = Provider.of<Database>(context);
    ReportsController reportsController =
        Provider.of<ReportsController>(context);
    Client client = Provider.of<Client>(context);
    List<Checklist> checklists = Provider.of<List<Checklist>>(context);
    List<Report> reports = Provider.of<List<Report>>(context);
    return Column(
      children: [
        // Button(
        //   press: () async {
        //     Directory? directory = await getDownloadsDirectory();

        //     File file = File('${directory!.path}/reports.json');
        //     print(file);
        //     String info = await file.readAsString();
        //     // if (info == '') {
        //     //   _update();
        //     //   // _delete();
        //     //   return;
        //     // }

        //     Map<String, dynamic> datas =
        //         jsonDecode(info) as Map<String, dynamic>;

        //     // lastUpdate = datas['lastUpdate'];
        //     // lastDelete = datas['lastDelete'];
        //     // Map<String, dynamic> d = datas['data'];

        //     List<Report> data = [];

        //     datas.forEach((id, d) {
        //       if (d['date'] > 1657789525000) {
        //         data.add(Report.fromMap(d, id, json: true));
        //       }
        //     });
        //     print(data.length);

        //     for (var d in data) {
        //       database.setReport(client.id!, d);
        //     }
        //   },
        //   text: 'import',
        // ),
        // Button(
        //   press: () {
        //     database.updateReport('1nftstpcauRtZeQYFzUV',
        //         '1nftstpcauRtZeQYFzUV', {'data': 'data'});
        //   },
        //   text: 'test',
        // ),
        // Button(
        //   press: () {
        //     print(reportsController.reports.length);
        //   },
        //   text: 'run',
        // ),
        // Button(
        //   press: () {
        //     // int count = 0;
        //     // for (Report report in reports) {
        //       // print(report.cid);
        //       // 7SnHi3bzMUN76WguVAvv
        //       // B9RhZRYcR65jWOgr7WcA
        //       // if (report.mon == 202212 && report.cid != '7SnHi3bzMUN76WguVAvv') {
        //       // print(report.id);
        //       // // count++;
        //       // reportsController.deleteReport(report);

        //       // database.updateReport(report.cid, report.id!, {
        //       //   'delete': null,
        //       // });
        //       // }
        //       // if ((report.type == AcType.ahu) && report.date >= 1669852835000 && report.version!=5) {
        //       //   print(report.unitname);
        //       //   database.updateReport(report.cid, report.id!, {
        //       //     'lastUpdate': Timestamp.now(),
        //       //     'version': 5,
        //       //   });
        //       // }
        //       // if(report.uid)
        //       // if ((report.type == AcType.fcu ||
        //       //         report.type == AcType.cas ||
        //       //         report.type == AcType.pre) &&
        //       //     report.date >= 1669853306000 && report.version != 4) {
        //       //   print(report.unitname);
        //       //   database.updateReport(report.cid, report.id!, {
        //       //     'lastUpdate': Timestamp.now(),
        //       //     'version': 4,
        //       //   });
        //     //   }
        //     // }
        //     // print('count');
        //     // print(count);
        //   },
        //   text: 'run',
        // ),
        UncheckReport(),
        MonthlyReport(),
      ],
    );
  }
}
