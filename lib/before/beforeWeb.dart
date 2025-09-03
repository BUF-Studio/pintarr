import 'package:flutter/material.dart';
import 'package:pintarr/before/beforeBox.dart';
import 'package:pintarr/widget/responsive.dart';


class BeforeWeb extends StatelessWidget {
  final Widget child;
  const BeforeWeb({Key? key, required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(),
        ),
        Expanded(
          flex: Responsive.isDesktop(context) ? 4 : 5,
          child: Container(
            child: BeforeBox(
              child: child,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(),
        ),
      ],
    );
  }
}
