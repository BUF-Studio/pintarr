import 'package:flutter/material.dart';
import 'package:pintarr/app/loginLanding.dart';
import 'package:pintarr/before/beforeNavi.dart';
import 'package:pintarr/service/fire/auth.dart';
import 'package:pintarr/service/veri.dart';
import 'package:pintarr/widget/safe.dart';
import 'package:provider/provider.dart';

class Landing extends StatelessWidget {
  const Landing(this.snapshot, {Key? key}) : super(key: key);
  final AsyncSnapshot<Users?> snapshot;
  // final bool verify;
  @override
  Widget build(BuildContext context) {
    final Veri ver = Provider.of<Veri>(context);
    // if (verify) ver.update(verify);]


    return snapshot.hasData
        ? LoginLanding()
        : Scaffold(
            body: Safe(
              child: BeforePage(),
            ),
          );
    // return After();
  }
}
