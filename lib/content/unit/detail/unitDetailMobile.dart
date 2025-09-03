import 'package:flutter/material.dart';
import 'package:pintarr/content/mobile.dart';
import 'package:pintarr/content/unit/detail/reportList.dart';
import 'package:pintarr/content/unit/detail/unitDetial.dart';
import 'package:pintarr/content/unit/edit/editUnitMobile.dart';
import 'package:pintarr/content/unit/report/addReportMobile.dart';
import 'package:pintarr/model/agent.dart';
import 'package:pintarr/model/unit.dart';
import 'package:pintarr/widget/empty.dart';
import 'package:pintarr/widget/title.dart';
import 'package:provider/provider.dart';

class UnitDetailMobile extends StatelessWidget {
  final Unit? unit;
  const UnitDetailMobile(this.unit, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Agent? agent = Provider.of<Agent?>(context);
    return Mobile(
      // func: () {
      //   page.updateUnit(UnitPages.main, null);
      // },
      body: Column(
        children: [
          if (unit == null) Empty('Unit Not Found.'),
          if (unit != null) UnitDetail(unit!),
          if (unit != null)
            PageTemp(
              card: false,
              title: 'Report',
              sub: agent!.pintar
                  ? PageButt('Add Report', onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddReportMobile(unit!),
                          ));
                    })
                  : null,
              children: [
                ReportList(unit!),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
        ],
      ),
      title: 'Units',
      action: [
        if (agent!.pintar)
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditUnitMobile(unit),
                  ));
            },
            icon: const Icon(Icons.edit),
          ),
      ],
    );
  }
}
