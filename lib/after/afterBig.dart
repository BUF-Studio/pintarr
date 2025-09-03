import 'package:flutter/material.dart';
import 'package:pintarr/bar/bar.dart';
import 'package:pintarr/content/content.dart';
import 'package:pintarr/content/contentBig.dart';
import 'package:pintarr/widget/safe.dart';

class AfterBig extends StatelessWidget {
  final bool tab;
  const AfterBig(this.tab, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Safe(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Bar(),
            ),
            Expanded(
              flex: tab ? 5 : 8,
              child: SingleChildScrollView(
                controller: ScrollController(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (tab) Content(),
                    if (!tab)
                      ContentBig(
                        child: Content(),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
