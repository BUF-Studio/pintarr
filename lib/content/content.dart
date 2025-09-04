import 'package:flutter/material.dart';
import 'package:pintarr/after/afterNavi.dart';
import 'package:pintarr/content/agent/agentPage.dart';
import 'package:pintarr/content/dashboard/livePage.dart';
import 'package:pintarr/content/report/reportPage.dart';
import 'package:pintarr/content/setting/setting.dart';
import 'package:pintarr/content/unit/unitPage.dart';
import 'package:provider/provider.dart';

class Content extends StatelessWidget {
  const Content({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navi = Provider.of<AfterNavi>(context);
    switch (navi.page) {
      case AfterPages.dashboard:
        return DashboardPage();
      case AfterPages.report:
        return ReportPage();
      case AfterPages.unit:
        // if (Responsive.isMobile(context)) return UnitMobile();
        return UnitPage();
      case AfterPages.user:
        return AgentPage();
      case AfterPages.setting:
        return Setting();
    }
  }
}
