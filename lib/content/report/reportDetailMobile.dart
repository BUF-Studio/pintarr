import 'package:flutter/material.dart';
import 'package:pintarr/content/mobile.dart';
import 'package:pintarr/content/report/viewReport.dart';
import 'package:pintarr/content/unit/detail/unitDetailMobile.dart';
import 'package:pintarr/model/report.dart';
import 'package:pintarr/model/unit.dart';
import 'package:pintarr/service/controller/unitController.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class ReportDetailMobile extends StatelessWidget {
  final Report reportt;
  const ReportDetailMobile(this.reportt, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // final UnitsController unitsController = Provider.of<UnitsController>(context);
    final units = Provider.of<List<Unit>>(context);

    Unit? unit = units.firstWhereOrNull((e) => e.id == reportt.uid);
    return Mobile(
        title: 'Report Detail',
        action: [
          IconButton(
              icon: const Icon(Icons.source),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UnitDetailMobile(unit),
                    ));
              }),
        ],
        body: Column(
          children: [
            ViewReport(reportt, unit!),
          ],
        ));
  }
}
