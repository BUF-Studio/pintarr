import 'package:flutter/material.dart';
import 'package:pintarr/content/unit/detail/unitDetailMobile.dart';
import 'package:pintarr/content/unit/unitBar.dart';
import 'package:pintarr/content/unit/unitPage.dart';
import 'package:pintarr/model/unit.dart';
import 'package:pintarr/service/controller/unitController.dart';
import 'package:pintarr/widget/empty.dart';
import 'package:pintarr/widget/responsive.dart';
import 'package:pintarr/widget/searchBar.dart';
import 'package:provider/provider.dart';

class UnitList extends StatelessWidget {
  const UnitList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final page = Provider.of<UnitNavi>(context);
    // final UnitsController unitsController = Provider.of<UnitsController>(context);
    List<Unit> units = Provider.of<List<Unit>>(context);
    List<Unit> unit = [];
    if ((page.unit?.type ?? '') != '') {
      // print(page.unit?.type);
      unit.addAll(units.where((e) => e.type == page.unit?.type));
    }
    if ((page.unit?.location ?? '') != '') {
      // print(page.unit?.location);
      unit.addAll(units.where((e) => e.location == page.unit?.location));
    }

    return UnitResult(unit);
  }
}

class UnitResult extends StatefulWidget {
  final List<Unit> units;
  const UnitResult(this.units, {Key? key}) : super(key: key);
  @override
  _UnitResultState createState() => _UnitResultState();
}

class _UnitResultState extends State<UnitResult> {
  String _search = '';
  @override
  Widget build(BuildContext context) {
    final page = Provider.of<UnitNavi>(context);

    List<Unit> unit = [];
    unit.addAll(widget.units);
    if (_search != '')
      unit.removeWhere(
          (e) => !e.unitname.toLowerCase().contains(_search.toLowerCase()));
    // if (unit.length == 0) return Empty('No units found');
    return Column(
      children: [
        SearchBarr(
          chg: (v) {
            setState(() {
              _search = v;
            });
          },
        ),
        if (unit.isEmpty) Empty('No units found'),
        if (unit.isNotEmpty)
          ListView.builder(
            itemBuilder: (context, index) {
              return UnitBar(
                unit[index],
                () {
                  if (!Responsive.isMobile(context)) {
                    page.updateUnit(UnitPages.detail,
                        ut: unit[index], backk: page.unit);
                  }
                  if (Responsive.isMobile(context)) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UnitDetailMobile(unit[index]),
                        ));
                  }
                },
              );
            },
            itemCount: unit.length,
            shrinkWrap: true,
            physics: const ScrollPhysics(),
          ),
      ],
    );
  }
}
