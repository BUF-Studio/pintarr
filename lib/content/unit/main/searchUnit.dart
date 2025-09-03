import 'package:flutter/material.dart';
import 'package:pintarr/content/unit/detail/unitDetailMobile.dart';
import 'package:pintarr/content/unit/edit/editUnitMobile.dart';
import 'package:pintarr/content/unit/unitBar.dart';
import 'package:pintarr/content/unit/unitPage.dart';
import 'package:pintarr/model/agent.dart';
import 'package:pintarr/model/unit.dart';
import 'package:pintarr/service/controller/unitController.dart';
import 'package:pintarr/widget/empty.dart';
import 'package:pintarr/widget/responsive.dart';
import 'package:pintarr/widget/searchBar.dart';
import 'package:pintarr/widget/title.dart';
import 'package:provider/provider.dart';

class SearchUnit extends StatefulWidget {
  final bool add;
  const SearchUnit({Key? key, this.add = false}) : super(key: key);
  @override
  _SearchUnitState createState() => _SearchUnitState();
}

class _SearchUnitState extends State<SearchUnit> {
  String _search = '';
  @override
  Widget build(BuildContext context) {
    final page = Provider.of<UnitNavi>(context);
    // final UnitsController unitsController = Provider.of<UnitsController>(context);
    final units = Provider.of<List<Unit>>(context);
    final Agent? agent = Provider.of<Agent?>(context);

    List<Unit?> unit = [];
    if (_search != '') {
      unit.addAll(units.where(
          (e) => e.unitname.toLowerCase().contains(_search.toLowerCase())));
    }
    print(unit.length);

    return PageTemp(
      title: 'Units',
      sub: widget.add && agent!.pintar
          ? PageButt(
              'Add Unit',
              onTap: () {
                if (Responsive.isMobile(context)) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditUnitMobile(null),
                      ));
                }
                if (!Responsive.isMobile(context)) {
                  page.updateUnit(UnitPages.edit);
                }
              },
            )
          : null,
      card: widget.add ? true : false,
      children: [
        SearchBarr(
          chg: (v) {
            setState(() {
              _search = v;
            });
          },
        ),

        // if (_search != '') Text(_search),
        if (_search != '' && unit.length != 0)
          ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: unit.length > 8 ? 8 : unit.length,
            itemBuilder: (context, index) {
              return UnitBar(unit[index]!, () {
                if (!Responsive.isMobile(context))
                  page.updateUnit(UnitPages.detail, ut: unit[index]);
                if (Responsive.isMobile(context))
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UnitDetailMobile(unit[index]),
                      ));
              });
            },
          ),
        if (_search != '' && unit.length == 0) Empty('No Unit Found.'),
      ],
    );
  }
}
