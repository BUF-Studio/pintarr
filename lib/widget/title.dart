import 'package:flutter/material.dart';
import 'package:pintarr/widget/button.dart';
import 'package:pintarr/widget/responsive.dart';

class PageTemp extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final bool card;
  final void Function()? onBack;
  final Widget? sub;
  final void Function()? refresh;
  final List<Widget>? children;
  const PageTemp({
    Key? key,
    this.title,
    this.children,
    this.sub,
    this.subtitle,
    this.card = true,
    this.onBack,
    this.refresh,
  }) : super(key: key);

  _page() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (onBack != null) Back(onBack),
          if (title != null)
            Title(
              title: title,
              sub: sub,
              refresh: refresh,
              subtitle: subtitle,
            ),
          // Divider(),
          if (children != null) ...children!,
        ],
      );
  @override
  Widget build(BuildContext context) {
    if (card) {
      return Card(
        margin: const EdgeInsets.all(15),
        child: _page(),
      );
    }
    return _page();
  }
}

class Title extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final void Function()? refresh;
  final Widget? sub;
  const Title({super.key, this.title, this.sub, this.refresh, this.subtitle});
  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //   border: Border(bottom: BorderSide())
      // ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title!,
                  style: TextStyle(
                      fontSize: Responsive.isMobile(context) ? 18 : 25),
                ),
                if (subtitle != null)
                  const SizedBox(
                    height: 5,
                  ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: const TextStyle(fontSize: 14),
                  ),
              ],
            ),
          ),
          if (sub != null) Container(child: sub),
          if (refresh != null) Refresh(refresh),
        ],
      ),
    );
  }
}

class Refresh extends StatelessWidget {
  final void Function()? func;
  const Refresh(this.func, {super.key});
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.refresh),
      onPressed: func,
    );
  }
}

class Back extends StatelessWidget {
  final void Function()? onTap;
  const Back(this.onTap, {super.key});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        // width: 100,
        // decoration: BoxDecoration(
        //   border: Border(bottom: BorderSide())
        // ),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.arrow_back_ios),
            Text(
              'Back',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}

class PageButt extends StatelessWidget {
  final String title;
  final void Function()? onTap;
  // final color;
  const PageButt(this.title, {Key? key, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SmallButt(
      // color: color,
      func: onTap,
      child: Text(title),
    );
  }
}
