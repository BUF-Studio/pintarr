import 'package:flutter/material.dart';
import 'package:pintarr/after/afterBig.dart';
import 'package:pintarr/after/afterMobile.dart';
import 'package:pintarr/widget/responsive.dart';

class After extends StatelessWidget {
  const After({Key? key}) : super(key: key);

  // final Widget child;
  // final List<Widget> children;
  // After({this.child, this.children});
  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: AfterMobile(),
      // tablet: AfterMobile(),
      tablet: const AfterBig(true),
      desktop: const AfterBig(false),
    );
  }
}
