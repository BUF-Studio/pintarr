import 'package:flutter/material.dart';
import 'package:pintarr/content/report/viewReport.dart';
import 'package:pintarr/content/unit/unitPage.dart';
import 'package:pintarr/model/agent.dart';
import 'package:pintarr/service/clientBloc.dart';
import 'package:pintarr/service/controller/reportController.dart';
import 'package:pintarr/service/fire/database.dart';
import 'package:pintarr/service/stream/reportStream.dart';
import 'package:pintarr/widget/alert.dart';
import 'package:pintarr/widget/title.dart';
import 'package:provider/provider.dart';

class UnitReportDetailPage extends StatelessWidget {
  const UnitReportDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final page = Provider.of<UnitNavi>(context);
    final Database database = Provider.of<Database>(context);
    final win = Provider.of<bool>(context);
    final client = Provider.of<ClientBloc>(context);
    final agent = Provider.of<Agent?>(context);
    final ReportsController reportsController =
        Provider.of<ReportsController>(context);

    return PageTemp(
      onBack: () {
        page.updateUnit(UnitPages.detail, ut: page.unit);
      },
      title: 'Report Detail',
      sub: !page.report!.checked && agent!.pintar
          ? PageButt('Delete Report', onTap: () {
              Alert.box(
                  context,
                  'Delete Report',
                  const Text(
                      'Sure to delete report? This action cannot be undo.'),
                  <Widget>[
                    Alert.cancel(context),
                    Alert.ok(context, () {
                      reportsController.deleteReport(page.report!);
                      // database.deleteReport(page.report!.id!, client.cid!);
                      Navigator.of(context).pop();
                      page.updateUnit(UnitPages.detail, ut: page.unit);
                    }, 'Sure')
                  ]);
            })
          : null,
      children: [
        ViewReport(page.report!, page.unit!),
      ],
    );
  }
}
