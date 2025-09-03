import 'package:flutter/material.dart';
import 'package:pintarr/content/unit/list/unitListMobile.dart';
import 'package:pintarr/content/unit/unitPage.dart';
import 'package:pintarr/model/client.dart';
import 'package:pintarr/model/type.dart';
import 'package:pintarr/model/unit.dart';
import 'package:pintarr/widget/empty.dart';
import 'package:pintarr/widget/pageList.dart';
import 'package:pintarr/widget/responsive.dart';
import 'package:pintarr/widget/tile.dart';
import 'package:provider/provider.dart';

class TypeUnit extends StatelessWidget {
  const TypeUnit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final type = AcType.acType(false);
    final page = Provider.of<UnitNavi>(context);
    final client = Provider.of<Client?>(context);
    final unit = Provider.of<List<Unit>>(context);
// final UnitsController unitsController = Provider.of<UnitsController>(context);
    final win = Provider.of<bool>(context);

    return PageList(
      refresh: win ? () {} : null,
      title: 'Unit Types',
      subtitle: 'Total Units : ${unit.length}',
      listView: unit.isEmpty
          ? const Empty('No Units')
          : ListView.builder(
              itemBuilder: (context, index) {
                var count = unit.where((e) => e.type == type[index]).length;
                if (count == 0) return Container();
                return Tile(
                  title: Text(type[index]),
                  subtitle: Text('Units count : $count'),
                  trail: const Icon(Icons.arrow_forward_ios),
                  tap: () {
                    if (!Responsive.isMobile(context)) {
                      page.updateUnit(UnitPages.list,
                          ut: Unit(
                              unitname: '',
                              type: type[index],
                              location: '',
                              serialNo: '',
                              brand: '',
                              model: '')

                          // ntype: type[index],
                          );
                    }
                    if (Responsive.isMobile(context)) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              UnitListMobile(type: type[index]),
                        ),
                      );
                    }
                  },
                );
              },
              itemCount: type.length,
              shrinkWrap: true,
              physics: const ScrollPhysics(),
            ),
    );
  }
}
