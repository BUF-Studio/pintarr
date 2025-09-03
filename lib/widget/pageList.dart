import 'package:flutter/material.dart';
import 'package:pintarr/widget/title.dart';

class PageList extends StatelessWidget {
  final String? title, subtitle;
  // final Function tap;
  // final Widget child;
  final void Function()? back, refresh;
  final Widget listView;
  const PageList({Key? key, 
    this.title,
    this.subtitle,
    this.refresh,
    // this.child,
    this.back,
    required this.listView,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return PageTemp(
      refresh: refresh,
      title: title,
      subtitle: subtitle,
      onBack: back,
      children: [
        // if (child != null) child,
        const Divider(),
        listView,
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
