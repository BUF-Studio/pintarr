import 'package:flutter/material.dart';
import 'package:pintarr/content/unit/detail/reportList.dart';
import 'package:pintarr/content/unit/detail/unitDetial.dart';
import 'package:pintarr/content/unit/unitPage.dart';
import 'package:pintarr/model/agent.dart';
import 'package:pintarr/widget/empty.dart';
import 'package:pintarr/widget/title.dart';
import 'package:provider/provider.dart';

class UnitDetailPage extends StatelessWidget {
  const UnitDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final page = Provider.of<UnitNavi>(context);
    // return Responsive(mobile: mobile, tablet: tablet, desktop: desktop)
    final Agent? agent = Provider.of<Agent?>(context);
    return Column(
      children: [
        PageTemp(
          onBack: () {
            // print('here');
            // print(page.back);
            page.updateUnit(
                (page.back == null ? UnitPages.main : UnitPages.list),
                ut: page.back);
          },
          title: 'Detail',
          sub: agent!.pintar
              ? PageButt('Edit', onTap: () {
                  page.updateUnit(UnitPages.edit, ut: page.unit);
                })
              : null,
          children: [
            if (page.unit == null) Empty('Unit Not Found.'),
            if (page.unit != null) UnitDetail(page.unit!),
            if (page.unit != null)
              PageTemp(
                card: false,
                title: 'Report',
                sub: agent.pintar
                    ? PageButt('Add Report', onTap: () {
                        page.updateUnit(UnitPages.report, ut: page.unit);
                      })
                    : null,
                children: [
                  ReportList(page.unit!),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
