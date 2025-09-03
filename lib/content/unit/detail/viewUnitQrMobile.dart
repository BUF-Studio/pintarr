import 'package:flutter/material.dart';
import 'package:pintarr/content/mobile.dart';
import 'package:pintarr/content/unit/detail/viewUnitQr.dart';
import 'package:pintarr/model/unit.dart';

class ViewUnitQrMobile extends StatelessWidget {
  final Unit unit;
  const ViewUnitQrMobile(this.unit, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Mobile(
      // func: () {
      //   page.updateUnit(UnitPages.main, null);
      // },
      body: Column(
        children: [
          ViewUnitQr(unit),
        ],
      ),
      title: 'Units',
    );
  }
}
