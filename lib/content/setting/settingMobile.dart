import 'package:flutter/material.dart';
import 'package:pintarr/content/mobile.dart';
import 'package:pintarr/content/setting/setting.dart';

class SettingMobile extends StatelessWidget {
  const SettingMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Mobile(
      // func: () {},
      title: 'Settings',
      body: Setting(),
    );
  }
}
