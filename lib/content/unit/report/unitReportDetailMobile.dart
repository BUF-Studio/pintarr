import 'package:flutter/material.dart';
import 'package:pintarr/content/mobile.dart';
import 'package:pintarr/content/report/viewReport.dart';
import 'package:pintarr/model/agent.dart';
import 'package:pintarr/model/report.dart';
import 'package:pintarr/model/unit.dart';
import 'package:pintarr/service/clientBloc.dart';
import 'package:pintarr/service/controller/reportController.dart';
import 'package:pintarr/service/fire/database.dart';
import 'package:pintarr/service/stream/reportStream.dart';
import 'package:pintarr/widget/alert.dart';
import 'package:provider/provider.dart';

class UnitReportDetailMobile extends StatelessWidget {
  final Report report;
  final Unit? unit;
  const UnitReportDetailMobile(this.report, this.unit, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Database database = Provider.of<Database>(context);
    final client = Provider.of<ClientBloc>(context);
    final agent = Provider.of<Agent?>(context);
    final ReportsController reportsController =
        Provider.of<ReportsController>(context);

    return Mobile(
      title: 'Report',
      action: [
        if (!report.checked && agent!.pintar)
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              Alert.box(
                  context,
                  'Delete Report',
                  const Text(
                      'Sure to delete report? This action cannot be undo.'),
                  <Widget>[
                    Alert.cancel(context),
                    Alert.ok(context, () {
                      reportsController.deleteReport(report);

                      // database.deleteReport(report.id!, client.cid!);
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    }, 'Sure')
                  ]);
            },
          ),
      ],
      body: ViewReport(report, unit!),
    );
  }
}
