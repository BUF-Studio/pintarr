import 'package:flutter/material.dart';
import 'package:pintarr/content/agent/main/mainAgent.dart';
import 'package:pintarr/model/agent.dart';
import 'package:provider/provider.dart';

class AgentPage extends StatelessWidget {
  const AgentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final page = Provider.of<AgentNavi>(context);
    switch (page.page) {
      case AgentPages.main:
        return MainAgent();
      case AgentPages.edit:
        return Container();

      // default:
    }
  }
}

class AgentNavi extends ChangeNotifier {
  AgentPages page = AgentPages.main;
  Agent? agent;

  void updateAgent(
    AgentPages newPage,
    Agent ut,
  ) {
    page = newPage;
    agent = ut;
    notifyListeners();
  }
}

enum AgentPages { main, edit }
