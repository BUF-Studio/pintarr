import 'package:flutter/material.dart';
import 'package:pintarr/before/beforeWeb.dart';
import 'package:pintarr/widget/pintarTitle.dart';
import 'package:pintarr/widget/responsive.dart';

class Before extends StatelessWidget {
  final Widget child;
  // final List<Widget?>? children;
  const Before({Key? key, required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    before(bool small, Widget child) => BeforeWeb(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: small ? 1 : 2,
                child: PintarTitle(small),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: VerticalDivider(),
              ),
              Expanded(
                flex: 3,
                child: Center(
                  child: child,
                ),
              ),
            ],
          ),
        );
    return Responsive(
      mobile: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              PintarMobileTitle(),
              Container(
                child: child,
              )
            ],
          ),
        ),
      ),
      tablet: before(true, child),
      desktop: before(false, child),
    );
  }
}
