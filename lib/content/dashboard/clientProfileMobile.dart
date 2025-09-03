import 'package:flutter/material.dart';
import 'package:pintarr/content/dashboard/clientProfile.dart';
import 'package:pintarr/content/mobile.dart';
import 'package:pintarr/model/client.dart';

class ClientProfileMobile extends StatelessWidget {
  final Client client;
  const ClientProfileMobile(this.client, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Mobile(
      title: 'Client\'s Profile',
      body: ClientProfile(client),
    );
  }
}
