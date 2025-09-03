import 'package:flutter/material.dart';
import 'package:pintarr/content/unit/main/locationUnit.dart';
import 'package:pintarr/content/unit/main/qrDownload.dart';
import 'package:pintarr/content/unit/main/searchUnit.dart';
import 'package:pintarr/content/unit/main/typeUnit.dart';
import 'package:pintarr/widget/responsive.dart';

class MainUnit extends StatelessWidget {
  const MainUnit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchUnit(
          add: true,
        ),
        QrsDownload(),
        if (!Responsive.isMobile(context))
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TypeUnit(),
              ),
              Expanded(
                child: LocationUnit(),
              ),
            ],
          ),
        if (Responsive.isMobile(context)) TypeUnit(),
        if (Responsive.isMobile(context)) LocationUnit(),
      ],
    );
  }
}
