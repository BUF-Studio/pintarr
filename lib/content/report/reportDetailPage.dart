import 'package:flutter/material.dart';
import 'package:pintarr/after/afterNavi.dart';
import 'package:pintarr/content/report/reportPage.dart';
import 'package:pintarr/content/report/viewReport.dart';
import 'package:pintarr/content/unit/unitPage.dart';
import 'package:pintarr/model/unit.dart';
import 'package:collection/collection.dart';
import 'package:pintarr/service/controller/unitController.dart';
// import 'package:pintarr/model/unit.dart';
import 'package:pintarr/widget/title.dart';
import 'package:provider/provider.dart';

class ReportDetailPage extends StatelessWidget {
  const ReportDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final UnitsController unitsController = Provider.of<UnitsController>(context);
    final units = Provider.of<List<Unit>>(context);
    final page = Provider.of<ReportNavi>(context);
    final navi = Provider.of<AfterNavi>(context);
    final unitPage = Provider.of<UnitNavi>(context);
    Unit? unit = units.firstWhereOrNull((e) => e.id == page.report!.uid);
    // print(page.report!.id);
    // print(page.report!.uid);
    // print(unit);
    // print('unit');
    return PageTemp(
      onBack: () {
        page.updateReport(
          page.bck == null ? ReportPages.main : ReportPages.mon,
          rpt: page.bck,
        );
      },
      sub: PageButt('View Unit', onTap: () {
        navi.updatePage(AfterPages.unit);
        unitPage.updateUnit(UnitPages.detail, ut: unit);
      }),
      title: 'Report Detail',
      children: [
        ViewReport(page.report!, unit!),
      ],
    );
  }
}
