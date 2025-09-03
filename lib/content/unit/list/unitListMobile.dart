import 'package:flutter/material.dart';
import 'package:pintarr/content/mobile.dart';
import 'package:pintarr/content/unit/list/unitList.dart';
import 'package:pintarr/model/unit.dart';
import 'package:pintarr/service/controller/unitController.dart';
import 'package:provider/provider.dart';

class UnitListMobile extends StatelessWidget {
  final String? type;
  final String? location;
  const UnitListMobile({Key? key, this.type, this.location}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // final page = Provider.of<UnitNavi>(context);
    // final UnitsController unitsController = Provider.of<UnitsController>(context);
    List<Unit> units = Provider.of<List<Unit>>(context);
    List<Unit> unit = [];
    if (type != null) unit.addAll(units.where((e) => e.type == type));
    if (location != null)
      unit.addAll(units.where((e) => e.location == location));
    return Mobile(
      body: UnitResult(unit),
      title: 'Units',
    );
  }
}
