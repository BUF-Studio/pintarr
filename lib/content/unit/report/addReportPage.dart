import 'package:flutter/material.dart';
import 'package:pintarr/content/unit/report/reportForm.dart';
import 'package:pintarr/content/unit/unitPage.dart';
import 'package:pintarr/widget/title.dart';
import 'package:provider/provider.dart';

class AddReportPage extends StatelessWidget {
  const AddReportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final page = Provider.of<UnitNavi>(context);
    return PageTemp(
      onBack: () {
        page.updateUnit(UnitPages.detail,ut: page.unit);
      },
      title: 'Add Report',
      children: [
        ReportForm(page.unit!),
      ],
    );
  }
}
