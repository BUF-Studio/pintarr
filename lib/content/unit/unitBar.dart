import 'package:flutter/material.dart';
import 'package:pintarr/model/unit.dart';
import 'package:pintarr/widget/tile.dart';

class UnitBar extends StatelessWidget {
  final Unit unit;
  final void Function()? tap;
  const UnitBar(this.unit, this.tap, {Key? key}) : super(key: key);

  final List<Icon> icons = const [
    Icon(
      Icons.check_circle_outline,
      color: Colors.green,
    ),
    Icon(
      Icons.report_problem_outlined,
      color: Colors.orange,
    ),
    Icon(
      Icons.highlight_off,
      color: Colors.red,
    ),
    Icon(
      Icons.help_outline,
      color: Colors.grey,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    icon() {
      if (unit.current == null) return icons[3];
      if (unit.current == 'Good') return icons[0];
      if (unit.current == 'Problem') return icons[1];
      if (unit.current == 'Down') return icons[2];
    }

    return Tile(
      color: Colors.white,
      title: Text(unit.unitname),
      subtitle: Text('${unit.type} / ${unit.location}'),
      lead: icon(),
      tap: tap,
    );
    // return Container(
    //   padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
    //   child: Row(
    //     children: [
    //       Expanded(
    //         child: Column(
    //           children: [
    //             Text(unit.unitname),
    //             Text('${unit.type} / ${unit.location}'),
    //           ],
    //         ),
    //       ),
    //       Text(unit?.lastService??''),
    //       Text(unit?.current??''),
    //     ],
    //   ),
    // );
  }
}
