import 'package:flutter/material.dart';
import 'package:pintarr/content/agent/main/userList.dart';
import 'package:pintarr/content/agent/main/userRequest.dart';
import 'package:pintarr/content/dashboard/clientProfile.dart';
import 'package:pintarr/model/agent.dart';
import 'package:pintarr/model/client.dart';
import 'package:provider/provider.dart';

class MainAgent extends StatelessWidget {
  const MainAgent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Agent? agent = Provider.of<Agent?>(context);
    final Client? client = Provider.of<Client?>(context);

    return Column(
      children: [
        UserRequest(),
        UserList(),
        if (agent!.admin) ClientProfile(client),
        // if(agent.admin)
      ],
    );
  }
}
