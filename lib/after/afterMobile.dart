import 'package:flutter/material.dart';
import 'package:pintarr/after/bottom.dart';
import 'package:pintarr/bar/bar.dart';
import 'package:pintarr/content/content.dart';
import 'package:pintarr/content/setting/settingMobile.dart';
import 'package:pintarr/model/agent.dart';
import 'package:pintarr/widget/safe.dart';
import 'package:provider/provider.dart';

class AfterMobile extends StatelessWidget {

  AfterMobile({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final Agent? agent = Provider.of<Agent?>(context);
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: const Text('Pintar Care'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingMobile()));
              },
              icon: const Icon(Icons.settings),
            ),
          ),
        ],
        leading: agent!.pintar
            ? IconButton(
                onPressed: () {
                  _key.currentState!.openDrawer();
                },
                icon: const Icon(Icons.menu),
              )
            : null,
      ),
      body: Safe(
        child: SingleChildScrollView(
          child: Content(),
        ),
      ),
      drawer: agent.pintar ? Bar() : null,
      bottomNavigationBar: Bottom(),
    );
  }
}
