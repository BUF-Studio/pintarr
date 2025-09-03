import 'package:flutter/material.dart';
import 'package:pintarr/widget/safe.dart';

class Mobile extends StatelessWidget {
  final String title;
  final List<Widget>? action;
  final Widget body;

  const Mobile({Key? key, 
    required this.title,
    this.action,
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: action,
      ),
      body: Safe(
        child: SingleChildScrollView(
          child: body,
        ),
      ),
    );
  }
}
