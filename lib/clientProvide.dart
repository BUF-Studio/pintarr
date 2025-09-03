import 'package:flutter/material.dart';
import 'package:pintarr/model/agent.dart';
import 'package:pintarr/model/checklist.dart';
import 'package:pintarr/model/client.dart';
import 'package:pintarr/model/report.dart';
import 'package:pintarr/model/unit.dart';
import 'package:pintarr/service/clientBloc.dart';
import 'package:pintarr/service/controller/checklistController.dart';
import 'package:pintarr/service/controller/reportController.dart';
import 'package:pintarr/service/controller/unitController.dart';
import 'package:pintarr/service/fire/database.dart';
import 'package:pintarr/splash.dart';
import 'package:provider/provider.dart';

class ClientProvide extends StatelessWidget {
  const ClientProvide(this.child, {Key? key}) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context);
    final Agent? agent = Provider.of<Agent?>(context);

    // final AfterNavi after = Provider.of<AfterNavi>(context);
    final ClientBloc bloc = Provider.of<ClientBloc>(context);
    final UnitsController unitsController =
        Provider.of<UnitsController>(context);
    final ReportsController reportsController =
        Provider.of<ReportsController>(context);
    final ChecklistsController checklistsController =
        Provider.of<ChecklistsController>(context);

    return StreamBuilder<Client?>(
        stream: database.clientStream(
            agent!.pintar ? (bloc.cid ?? agent.cid!) : agent.cid!),
        builder: (context, cs) {
          if (cs.connectionState == ConnectionState.waiting)
            return const Splash();
          final Client? client = cs.data;

          if (bloc.cid == null && client == null && agent.cid != null) {
            bloc.updateCid(agent.cid!);
          }

          unitsController.updateClient(client);
          reportsController.updateClient(client);

          // after.init();
          // print('provide');
          // print(client.id);
          return MultiProvider(
            providers: [
              ProxyProvider0<Client?>(
                update: (_, __) => client,
              ),

              if (client?.id != null)
                StreamProvider<List<Unit>>(
                  create: (_) => unitsController.stream,
                  initialData: const [],
                  updateShouldNotify: (_, __) => true,
                  // updateShouldNotify: ,
                ),
              if (client?.id != null)
                StreamProvider<List<Report>>(
                  initialData: [],
                  create: (_) => reportsController.stream,
                  updateShouldNotify: (_, __) => true,
                ),
              if (client?.id != null)
                StreamProvider<List<Checklist>>(
                  initialData: [],
                  create: (_) => checklistsController.stream,
                  updateShouldNotify: (_, __) => true,
                ),

              if (client?.id != null)
                StreamProvider<List<Agent?>?>(
                  create: (_) => database.agentsStream(client!.id!),
                  initialData: const [],
                ),
            ],
            child: child,
          );
        });
  }
}
