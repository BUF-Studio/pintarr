import 'package:flutter/material.dart';
import 'package:pintarr/content/dashboard/clientProfile.dart';
import 'package:pintarr/content/dashboard/dashboard.dart';
import 'package:pintarr/model/client.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final page = Provider.of<DashboardNavi>(context);
    switch (page.page) {
      case DashboardPages.main:
        return Dashboard();
      case DashboardPages.client:
        return ClientProfile(page.client);
     
      default:
        return Dashboard();
    }
  }
}

class DashboardNavi extends ChangeNotifier {
  DashboardPages page = DashboardPages.main;
  Client? client;
  String? actype;

  void updateDashboard(
    DashboardPages newPage, {
    Client? cli,
    String? type,
  }) {
    page = newPage;
    client = cli;
    actype = type;
    notifyListeners();
  }
}

enum DashboardPages { main, client }
