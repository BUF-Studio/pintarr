import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pintarr/model/agent.dart';
import 'package:pintarr/model/client.dart';
import 'package:pintarr/service/fire/auth.dart';
import 'package:pintarr/service/fire/database.dart';
import 'package:pintarr/service/format.dart';
import 'package:pintarr/widget/alert.dart';
import 'package:pintarr/widget/button.dart';
import 'package:pintarr/widget/textDetail.dart';
import 'package:pintarr/widget/title.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final agent = Provider.of<Agent?>(context);
    final auth = Provider.of<Auth>(context);
    final database = Provider.of<Database>(context);
    Client? client = Provider.of<Client?>(context);
    if (agent!.pintar) {
      final clients = Provider.of<List<Client?>?>(context);
      client = clients!.firstWhereOrNull((e) => e!.id == agent.cid);
    }

    return PageTemp(
      title: 'Profile',
      children: [
        TextDetail('Username', agent.username),
        TextDetail('Join', Format.epochToString(agent.join)),
        TextDetail('Client', client?.name ?? ''),

        Button(
          text: 'Logout',
          press: auth.signOut,
        ),
        const SizedBox(
          height: 40,
        ),
        if (Platform.isIOS)
          Button(
            text: 'Delete Account',
            press: () {
              Alert.box(
                context,
                'Delete account',
                const Text('Are you sure to delete your account?'),
                <Widget>[
                  Alert.cancel(context),
                  Alert.ok(context, () {
                    database.deleteAgent(agent.id);
                    auth.delete();
                    Navigator.pop(context);
                  }, 'Sure'),
                ],
              );
            },
          ),
        // TextDetail('Email', agent.),
      ],
    );
  }
}
