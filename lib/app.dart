import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firedart/firedart.dart' as fire;
import 'package:flutter/services.dart';
import 'package:pintarr/after/afterNavi.dart';
import 'package:pintarr/app/landing.dart';
import 'package:pintarr/before/beforeNavi.dart';
import 'package:pintarr/color.dart';
import 'package:pintarr/content/agent/agentPage.dart';
import 'package:pintarr/content/dashboard/livePage.dart';
import 'package:pintarr/content/report/reportPage.dart';
import 'package:pintarr/content/unit/unitPage.dart';
import 'package:pintarr/provide.dart';
import 'package:pintarr/service/clientBloc.dart';
import 'package:pintarr/service/controller/checklistController.dart';
import 'package:pintarr/service/controller/reportController.dart';
import 'package:pintarr/service/controller/unitController.dart';
import 'package:pintarr/service/fire/auth.dart';
import 'package:pintarr/service/fire/database.dart';
import 'package:pintarr/service/fire/preference.dart';
import 'package:pintarr/service/load.dart';
import 'package:pintarr/service/veri.dart';
import 'package:pintarr/widget/rightShift.dart';

// import 'package:pintarr/veri.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final bool win = Platform.isWindows;

    // final bool win = true;
    // final bool win = false;
    init() async {
      fire.FirebaseAuth.initialize(
        'AIzaSyB3uNb3bCdOLF--TJR2_fpw4_a4s1wR69Y',
        await PreferencesStore.create(),
      );
      fire.Firestore.initialize('pintar-care-v3-5f8c4');

      // await Future.delayed(Duration(milliseconds: 1));
    }

    ok() async {}

    return FutureBuilder(
      future: win ? init() : ok(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Database database = Database(win);
          // RealDatabase real = RealDatabase();
          return MultiProvider(
            providers: [
              Provider<bool>(create: (context) => win),
              Provider<UnitsController>(
                create: (context) => UnitsController(database, win),
              ),
              Provider<ReportsController>(
                create: (context) => ReportsController(database, win),
              ),
              Provider<ChecklistsController>(
                create: (context) => ChecklistsController(database, win),
              ),
              // if (win)
              //   Provider<UnitStream>(
              //     create: (context) => UnitStream(real),
              //   ),
              // if (win)
              //   Provider<ClientStream>(
              //     create: (context) => ClientStream(real),
              //   ),
              // if (win)
              //   Provider<ClientsStream>(
              //     create: (context) => ClientsStream(real),
              //   ),
              // if (win)
              //   Provider<AgentsStream>(
              //     create: (context) => AgentsStream(real),
              //   ),
              // if (win)
              //   Provider<AgentStream>(
              //     create: (context) => AgentStream(real),
              //   ),
              // if (win)
              //   Provider<ReportStream>(
              //     create: (context) => ReportStream(real),
              //   ),
              Provider<Auth>(create: (context) => Auth(win)),
              Provider<Database>(create: (context) => database),
              ChangeNotifierProvider<Load>(create: (_) => Load()),
              ChangeNotifierProvider<ClientBloc>(create: (_) => ClientBloc()),
              ChangeNotifierProvider<AgentNavi>(create: (_) => AgentNavi()),
              ChangeNotifierProvider<ReportNavi>(create: (_) => ReportNavi()),
              ChangeNotifierProvider<UnitNavi>(create: (_) => UnitNavi()),
              ChangeNotifierProvider<BeforeNavi>(create: (_) => BeforeNavi()),
              ChangeNotifierProvider<AfterNavi>(create: (_) => AfterNavi()),
              ChangeNotifierProvider<DashboardNavi>(
                create: (_) => DashboardNavi(),
              ),
              ChangeNotifierProvider<Veri>(create: (_) => Veri()),
            ],
            child: Provide(
              builders: (context, snapshot) {
                return Listener(
                  onPointerDown: (_) {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.focusedChild?.unfocus();
                    }
                  },
                  child: ShiftRightFixer(
                    child: MaterialApp(
                      debugShowCheckedModeBanner: false,
                      title: 'Pintar Care',
                      home: Landing(snapshot),
                      // theme: ThemeData(
                      //   // primaryColor: darkBlue,
                      //   colorScheme: ColorScheme.fromSwatch().copyWith(
                      //     secondary: lightBlue,
                      //     primary: darkBlue,
                      //   ),

                      //   // colorScheme.secondary
                      //   // backgroundColor: Colors.grey[100],
                      //   appBarTheme: const AppBarTheme(
                      //     // backgroundColor: darkBlue,
                      //     systemOverlayStyle: SystemUiOverlayStyle(
                      //         // systemNavigationBarColor:
                      //         //     Colors.blue, // Navigation bar
                      //         // statusBarColor: Colors.red,
                      //         statusBarColor: darkBlue,
                      //         statusBarBrightness:
                      //             Brightness.dark // Status bar
                      //         ),
                      //     // brightness: Brightness.dark,
                      //     iconTheme: IconThemeData(
                      //       color: Colors.white,
                      //     ),
                      //     titleTextStyle: TextStyle(
                      //         color: Colors.white,
                      //         fontSize: 20.0,
                      //         fontWeight: FontWeight.w500,
                      //         textBaseline: TextBaseline.alphabetic,
                      //         letterSpacing: 0.15),
                      //     // textTheme: TextTheme(
                      //     //   headline6: TextStyle(
                      //     //      ),
                      //     // ),
                      //   ),
                      // ),
                      theme: ThemeData(
                        useMaterial3: false, // 👈 Force Material 2 look
                        primaryColor: darkBlue,
                        colorScheme: ColorScheme.fromSwatch().copyWith(
                          primary: darkBlue,
                          secondary: lightBlue,
                        ),
                        appBarTheme: const AppBarTheme(
                          backgroundColor: darkBlue,
                          systemOverlayStyle: SystemUiOverlayStyle(
                            statusBarColor: darkBlue,
                            statusBarBrightness: Brightness.dark,
                          ),
                          iconTheme: IconThemeData(color: Colors.white),
                          titleTextStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.15,
                          ),
                        ),
                      ),

                      // home: After(),
                    ),
                  ),
                );
              },
            ),
          );
        }
        return Container();
      },
    );
  }
}
