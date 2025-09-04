import 'package:flutter/material.dart';
import 'package:pintarr/content/report/list/monthReportMobile.dart';
import 'package:pintarr/content/report/reportPage.dart';
import 'package:pintarr/model/client.dart';
import 'package:pintarr/model/report.dart';
import 'package:pintarr/model/reportType.dart';
import 'package:pintarr/service/controller/reportController.dart';
import 'package:pintarr/service/format.dart';
import 'package:pintarr/widget/empty.dart';
import 'package:pintarr/widget/pageList.dart';
import 'package:pintarr/widget/responsive.dart';
import 'package:pintarr/widget/tile.dart';
import 'package:provider/provider.dart';

class MonthlyReport extends StatelessWidget {
  const MonthlyReport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ReportNavi page = Provider.of<ReportNavi>(context);
    final Client? client = Provider.of<Client?>(context);
    final List<Report> reports = Provider.of<List<Report>>(context);
    final ReportsController reportsController =
        Provider.of<ReportsController>(context);
    final bool win = Provider.of<bool>(context);

    // select = [];
    List<int> mon = client!.mon;

    // mon.sort((b, a) => a.compareTo(b));

    return PageList(
      refresh: () async {
        await reportsController.reloadReport();
      },
      title: 'Monthly Reports',
      listView: mon.isEmpty
          ? Empty('No Report Found')
          : ListView.builder(
              itemBuilder: (context, index) {
                var count = reports.where((e) => e.mon == mon[index]).length;

                // print('report count');
                // print(count);
                return Tile(
                  title: Text(Format.intToString(mon[index])),
                  subtitle: Text('Total reports : ${count.toString()}'),
                  trail: const Icon(Icons.arrow_forward_ios),
                  tap: () {
                    if (!Responsive.isMobile(context)) {
                      page.updateReport(ReportPages.mon,
                          rpt: Report(
                              uid: '',
                              cid: '',
                              current: '',
                              data: [],
                              unitname: '',
                              model: '',
                              location: '',
                              type: '',
                              serial: '',
                              checked: false,
                              date: 0,
                              mon: mon[index],
                              reportType: ReportType.minor,
                              by: '',
                              comment: '',
                              version: 0));
                    }
                    if (Responsive.isMobile(context)) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MonthReportMobile(mon[index]),
                          ));
                    }
                  },
                );
              },
              itemCount: mon.length,
              shrinkWrap: true,
              physics: const ScrollPhysics(),
            ),
    );
  }
}
