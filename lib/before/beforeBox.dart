import 'package:flutter/material.dart';

class BeforeBox extends StatelessWidget {
  final Widget child;
  const BeforeBox({Key? key, required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 500,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          // border: BorderSide(),
          color: Colors.white,
        ),
        child: child,
      ),
    );
  }
}
