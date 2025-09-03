import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pintarr/after/afterNavi.dart';
import 'package:pintarr/model/agent.dart';
import 'package:pintarr/service/fire/auth.dart';
import 'package:pintarr/service/veri.dart';
import 'package:pintarr/sign/requestPage.dart';
import 'package:pintarr/sign/verify.dart';
import 'package:pintarr/widget/safe.dart';
import 'package:provider/provider.dart';

enum LandingState { request, waiting }

class LoginLanding extends StatefulWidget {
  const LoginLanding(this.verify, {Key? key}) : super(key: key);
  final bool verify;

  @override
  _LoginLandingState createState() => _LoginLandingState();
}

class _LoginLandingState extends State<LoginLanding> {
  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() {
        verify = widget.verify;
      });
    }
  }

  late bool verify;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    final win = Provider.of<bool>(context);
    final Veri ver = Provider.of<Veri>(context);

    // verify = ver.ver;

    print(verify);

    reload() {
      Timer _timer;
      Future(() async {
        _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
          // print('reload');
          if (!win) {
            await auth.reload();
          }
          if (await auth.isVerify) {
            // print('ver');
            ver.update(true);

            timer.cancel();
            setState(() {
              verify = true;
            });
          }
        });
      });
    }

    if (!verify) reload();

    final Agent? agent = Provider.of<Agent?>(context);
    if (agent == null) return Container();
    // print(agent.cid);
    if (!verify) {
      return Scaffold(
        body: Safe(
          child: Verify(),
        ),
      );
    }
    if (agent.cid == null || !agent.access) {
      return Scaffold(
        body: Safe(
          child: RequestPage(),
        ),
      );
    }
    return AfterPage();
  }
}
