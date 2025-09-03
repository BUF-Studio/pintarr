import 'package:flutter/material.dart';
import 'package:pintarr/model/unit.dart';
import 'package:pintarr/service/controller/unitController.dart';
import 'package:pintarr/widget/chart.dart';
import 'package:provider/provider.dart';

class UnitCondition extends StatelessWidget {
  const UnitCondition({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Unit> units = Provider.of<List<Unit>>(context);
    // final UnitsController unitsController = Provider.of<UnitsController>(context);

    var good = units.where((e) => e.current == 'Good').length;
    var problem = units.where((e) => e.current == 'Problem').length;
    var down = units.where((e) => e.current == 'Down').length;

    return Container(
        child: Row(
      children: [
        Expanded(
          child: Chart(
            center: good.toString(),
            color: Colors.green,
            percent: units.isEmpty ? 0 : good / units.length,
            title: 'Good',
          ),
        ),
        Expanded(
          child: Chart(
            center: problem.toString(),
            color: Colors.orange,
            percent: units.isEmpty ? 0 : problem / units.length,
            title: 'Problem',
          ),
        ),
        Expanded(
          child: Chart(
            center: down.toString(),
            color: Colors.red,
            percent: units.isEmpty ? 0 : down / units.length,
            title: 'Down',
          ),
        ),
      ],
    ));
  }
}
