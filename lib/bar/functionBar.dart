import 'package:flutter/material.dart';
import 'package:pintarr/after/afterNavi.dart';
import 'package:pintarr/model/client.dart';
import 'package:pintarr/widget/tile.dart';
import 'package:provider/provider.dart';

class FunctionBar extends StatelessWidget {
  const FunctionBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navi = Provider.of<AfterNavi>(context);
    final client = Provider.of<Client?>(context);

    return ListView(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      children: [
        Tile(
          lead: const Icon(Icons.home),
          title: const Text('Home'),
          tap: () {
            navi.updatePage(AfterPages.dashboard);
          },
          selected: navi.page == AfterPages.dashboard,
          selectedColor: Colors.grey[300],
          bar: true,
        ),
        if (!client!.pintar)
          Tile(
            lead: const Icon(Icons.ac_unit),
            title: const Text('Units'),
            tap: () {
              navi.updatePage(AfterPages.unit);
            },
            selected: navi.page == AfterPages.unit,
            selectedColor: Colors.grey[300],
            bar: true,
          ),
        if (!client.pintar)
          Tile(
            lead: const Icon(Icons.topic),
            title: const Text('Reports'),
            tap: () {
              navi.updatePage(AfterPages.report);
            },
            selected: navi.page == AfterPages.report,
            selectedColor: Colors.grey[300],
            bar: true,
          ),
        Tile(
          lead: const Icon(Icons.people),
          title: const Text('Users'),
          tap: () {
            navi.updatePage(AfterPages.user);
          },
          selected: navi.page == AfterPages.user,
          selectedColor: Colors.grey[300],
          bar: true,
        ),
      ],
    );
  }
}
