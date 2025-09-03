import 'package:flutter/material.dart';
import 'package:pintarr/content/mobile.dart';
import 'package:pintarr/content/unit/report/reportForm.dart';
import 'package:pintarr/model/unit.dart';

class AddReportMobile extends StatelessWidget {
  final Unit unit;
  const AddReportMobile(this.unit, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Mobile(
      title: 'Add Report',
      body: ReportForm(unit),
    );
  }
}
