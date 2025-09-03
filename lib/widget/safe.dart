import 'package:flutter/material.dart';
import 'package:pintarr/service/load.dart';
import 'package:pintarr/widget/loading.dart';
import 'package:provider/provider.dart';

class Safe extends StatelessWidget {
  final Widget child;
  const Safe({Key? key, required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final load = Provider.of<Load>(context);
    return SafeArea(
      child: Stack(
        children: [
          child,
          if (load.load) const Loading(),
        ],
      ),
    );
  }
}
