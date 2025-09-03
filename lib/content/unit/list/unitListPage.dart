import 'package:flutter/material.dart';
import 'package:pintarr/content/unit/list/unitList.dart';
import 'package:pintarr/content/unit/unitPage.dart';
import 'package:pintarr/widget/pageList.dart';
import 'package:provider/provider.dart';

class UnitListPage extends StatelessWidget {
  const UnitListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navi = Provider.of<UnitNavi>(context);
    return PageList(
      back: () {
        navi.updateUnit(UnitPages.main);
      },
      title: 'Units',
      listView: UnitList(),
    );
  }
}
