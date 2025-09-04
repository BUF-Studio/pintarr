// import 'package:flutter/material.dart';
// import 'package:pintarr/clientProvide.dart';
// import 'package:pintarr/model/agent.dart';
// import 'package:pintarr/model/client.dart';
// import 'package:pintarr/service/controller/checklistController.dart';
// import 'package:pintarr/service/controller/reportController.dart';
// import 'package:pintarr/service/controller/unitController.dart';
// import 'package:pintarr/service/fire/auth.dart';
// import 'package:pintarr/service/fire/database.dart';
// import 'package:pintarr/service/pdf.dart';
// import 'package:pintarr/service/stream/agentStream.dart';
// import 'package:pintarr/service/stream/clientsStream.dart';
// import 'package:pintarr/service/veri.dart';
// import 'package:pintarr/splash.dart';
// import 'package:provider/provider.dart';

// class Provide extends StatelessWidget {
//   const Provide({Key? key, required this.builders}) : super(key: key);
//   final Widget Function(BuildContext, AsyncSnapshot<Users?>) builders;

//   // _get() async {
//   //   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //   return prefs.getString('uid');
//   // }

//   @override
//   Widget build(BuildContext context) {
//     final bool win = Provider.of<bool>(context);
//     // final bool win = Platform.isWindows;
//     final auth = Provider.of<Auth>(context);
//     final database = Provider.of<Database>(context);

//     final UnitsController unitsController =
//         Provider.of<UnitsController>(context);
//     final ChecklistsController checklistsController =
//         Provider.of<ChecklistsController>(context);
//     final ReportsController reportsController =
//         Provider.of<ReportsController>(context);
//     // final cardStream = win ? Provider.of<CardStream>(context) : null;
//     // final grpStream = win ? Provider.of<GrpStream>(context) : null;
//     // // final deliveryStream = win ? Provider.of<DeliveryStream>(context):null;
//     // final historyStream = win ? Provider.of<HistoryStream>(context) : null;
//     // final proxyStream = win ? Provider.of<ProxyStream>(context) : null;
//     // final snkStream = win ? Provider.of<SnkStream>(context) : null;

//     return StreamBuilder<Users?>(
//       stream: auth.onAuthStateChanged,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting && !win) {
//           return Container();
//         }
//         if (snapshot.connectionState == ConnectionState.waiting && win) {
//           return builders(context, snapshot);
//         }

//         final Users? user = snapshot.data;

//         Future verify() async {
//           final Veri ver = Provider.of<Veri>(context);

//           bool verify = await auth.isVerify;

//           ver.update(verify);
//         }

//         if (user != null) {
//           // auth.signOut();
//           return ProxyProvider0<Users>(
//             update: (_, __) => user,
//             child: FutureBuilder(
//               future: verify(),
//               builder: (context, snap) {
//                 if (snap.connectionState == ConnectionState.waiting) {
//                   return Splash();
//                 }
//                 // bool ver = snap.data[0];

//                 // return ChangeNotifierProvider(create: create)

//                 return StreamBuilder<Agent?>(
//                   stream: database.agentStream(user.uid),
//                   builder: (context, ss) {
//                     if (ss.connectionState == ConnectionState.waiting) {
//                       print('wait');
//                       return Splash();
//                     }

//                     print(ss.data);
//                     Agent? agent = ss.data;
//                     print('agent');
//                     print(agent?.username);
//                     print(user.uid);

//                     unitsController.updateAgent(agent);
//                     reportsController.updateAgent(agent);

//                     checklistsController.update();

//                     return MultiProvider(
//                       providers: [
//                         ProxyProvider0<Agent?>(
//                           update: (_, __) => agent,
//                         ),
//                         if (agent != null &&
//                             (agent.pintar || agent.cid == null || agent.admin))
//                           StreamProvider<List<Client?>?>(
//                             create: (_) => database.clientsStream(),
//                             initialData: const [],
//                           ),
//                         Provider<Pdf>(
//                           create: (_) => Pdf(checklistsController),
//                         ),
//                       ],
//                       child: agent?.cid == null
//                           ? builders(context, snapshot)
//                           : ClientProvide(builders(context, snapshot)),
//                     );
//                   },
//                 );
//               },
//             ),
//           );
//         }
//         return builders(context, snapshot);
//       },
//     );
//   }
// }
// //

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pintarr/clientProvide.dart';
import 'package:pintarr/model/agent.dart';
import 'package:pintarr/model/client.dart';
import 'package:pintarr/service/controller/checklistController.dart';
import 'package:pintarr/service/controller/reportController.dart';
import 'package:pintarr/service/controller/unitController.dart';
import 'package:pintarr/service/fire/auth.dart';
import 'package:pintarr/service/fire/database.dart';
import 'package:pintarr/service/pdf.dart';
import 'package:pintarr/service/veri.dart';
import 'package:pintarr/splash.dart';
import 'package:provider/provider.dart';

class Provide extends StatelessWidget {
  const Provide({super.key, required this.builders});
  final Widget Function(BuildContext, AsyncSnapshot<Users?>) builders;

  @override
  Widget build(BuildContext context) {
    final bool win = Provider.of<bool>(context);
    final auth = Provider.of<Auth>(context);
    final database = Provider.of<Database>(context);

    final unitsController = Provider.of<UnitsController>(context);
    final reportsController = Provider.of<ReportsController>(context);
    final checklistsController = Provider.of<ChecklistsController>(context);

    // Provide auth state as a stream
    return StreamProvider<Users?>.value(
      value: auth.onAuthStateChanged,
      initialData: null,
      catchError: (_, __) => null,
      child: Consumer<Users?>(
        builder: (context, user, _) {
          if (user == null) {
            // No user signed in
            return builders(
              context,
              AsyncSnapshot.withData(ConnectionState.done, null),
            );
          }

          // Verify email asynchronously once
          Future.microtask(() async {
            final auth = Provider.of<Auth>(context, listen: false);
            final ver = Provider.of<Veri>(context, listen: false);

            // check once immediately
            ver.update(await auth.isVerify);

            // keep checking every 5s until verified
            Timer.periodic(const Duration(seconds: 5), (timer) async {
              await auth.reload(); // force refresh FirebaseAuth state
              final verified = await auth.isVerify;
              ver.update(verified);

              if (verified) timer.cancel(); // stop checking once verified
            });
          });

          // Provide agent stream
          return StreamProvider<Agent?>.value(
            value: database.agentStream(user.uid),
            initialData: null,
            catchError: (_, __) => null,
            child: Consumer<Agent?>(
              builder: (context, agent, _) {
                if (agent == null) {
                  return const Splash(); // still loading agent
                }

                // Update controllers safely (outside build loop)
                unitsController.updateAgent(agent);
                reportsController.updateAgent(agent);
                checklistsController.update();

                return MultiProvider(
                  providers: [
                    ProxyProvider0<Agent?>(update: (_, __) => agent),
                    if (agent.pintar || agent.cid == null || agent.admin)
                      StreamProvider<List<Client?>?>.value(
                        value: database.clientsStream(),
                        initialData: const [],
                        catchError: (_, __) => [],
                      ),
                    Provider<Pdf>(create: (_) => Pdf(checklistsController)),
                  ],
                  child: agent.cid == null
                      ? builders(
                          context,
                          AsyncSnapshot.withData(ConnectionState.done, user),
                        )
                      : ClientProvide(
                          builders(
                            context,
                            AsyncSnapshot.withData(ConnectionState.done, user),
                          ),
                        ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
