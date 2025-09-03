import 'package:flutter/material.dart';
import 'package:pintarr/content/unit/list/unitListMobile.dart';
import 'package:pintarr/content/unit/unitPage.dart';
import 'package:pintarr/model/client.dart';
import 'package:pintarr/model/unit.dart';
import 'package:pintarr/service/controller/unitController.dart';
import 'package:pintarr/service/fire/database.dart';
import 'package:pintarr/widget/empty.dart';
import 'package:pintarr/widget/pageList.dart';
import 'package:pintarr/widget/responsive.dart';
import 'package:pintarr/widget/tile.dart';
import 'package:provider/provider.dart';

class LocationUnit extends StatelessWidget {
  const LocationUnit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final page = Provider.of<UnitNavi>(context);
    final client = Provider.of<Client?>(context);
    final database = Provider.of<Database>(context);
    // final UnitsController unitsController = Provider.of<UnitsController>(context);

    final unit = Provider.of<List<Unit>>(context);

    final win = Provider.of<bool>(context);

    List<String> loc = [];
    loc.addAll(client!.location);

    return PageList(
      refresh: win
          ? () {
              // ustream!.update(client.id);
              // rstream!.update(client.id);
            }
          : null,
      title: 'Unit Location',
      subtitle: 'Total Units : ${unit.length}',
      listView: client.location.isEmpty
          ? Empty('No Units')
          : ListView.builder(
              itemBuilder: (context, index) {
                var count = unit.where((e) => e.location == loc[index]).length;
                if (count == 0 && loc.isNotEmpty && unit.isNotEmpty && !win) {
                  Client newclient = client.copy();
                  List<String> newloc = [];
                  newloc.addAll(client.location);
                  newloc.remove(loc[index]);
                  newclient.location = newloc;
                  // print('setClinet');
                  database.setClient(newclient);
                }
                return Tile(
                  title: Text(loc[index]),
                  subtitle: Text('Units count : $count'),
                  trail: const Icon(Icons.arrow_forward_ios),
                  tap: () {
                    if (!Responsive.isMobile(context)) {
                      page.updateUnit(
                        UnitPages.list,
                        ut: Unit(
                            unitname: '',
                            type: '',
                            location: loc[index],
                            serialNo: '',
                            brand: '',
                            model: ''),
                      );
                    }
                    if (Responsive.isMobile(context)) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                UnitListMobile(location: loc[index]),
                          ));
                    }
                  },
                );
              },
              itemCount: loc.length,
              shrinkWrap: true,
              physics: const ScrollPhysics(),
            ),
    );
  }
}
