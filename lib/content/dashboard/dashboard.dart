import 'package:flutter/material.dart';
import 'package:pintarr/content/dashboard/clientProfileMobile.dart';
import 'package:pintarr/content/dashboard/livePage.dart';
import 'package:pintarr/content/dashboard/reportSum.dart';
import 'package:pintarr/content/dashboard/unitCondition.dart';
import 'package:pintarr/content/unit/main/searchUnit.dart';
import 'package:pintarr/model/agent.dart';
import 'package:pintarr/model/checklist.dart';
import 'package:pintarr/model/checklistItem.dart';
import 'package:pintarr/model/client.dart';
import 'package:pintarr/model/report.dart';
import 'package:pintarr/model/type.dart';
import 'package:pintarr/service/clientBloc.dart';
import 'package:pintarr/service/controller/checklistController.dart';
import 'package:pintarr/service/fire/database.dart';
import 'package:pintarr/service/format.dart';
import 'package:pintarr/widget/button.dart';
import 'package:pintarr/widget/responsive.dart';
import 'package:pintarr/widget/tile.dart';
import 'package:pintarr/widget/title.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Client? client = Provider.of<Client?>(context);
    final DashboardNavi page = Provider.of<DashboardNavi>(context);
    final Agent? agent = Provider.of<Agent?>(context);
    final ClientBloc bloc = Provider.of<ClientBloc>(context);
    // final ClientBloc data = Provider.of<ClientBloc>(context);
    // if(client.pintar)

    final List<Checklist> checklists = Provider.of<List<Checklist>>(context);
    final List<Report> reports = Provider.of<List<Report>>(context);
    // final ReportNavi page = Provider.of<ReportNavi>(context);

    final List<Client?>? clients =
        client!.pintar ? Provider.of<List<Client?>?>(context) : null;

    final Database database = Provider.of<Database>(context);

    final List<Client?> cli = [];
    final win = Provider.of<bool>(context);
    // final csstream = win ? Provider.of<ClientsStream>(context) : null;
    // final cstream = win ? Provider.of<ClientStream>(context) : null;

    final ChecklistsController checklistsController =
        Provider.of<ChecklistsController>(context);
    List<String> actype = AcType.acType(false);
    List<Report> report = [];
    if (client.mon.isNotEmpty && reports.isNotEmpty) {
      report.addAll(reports.where((e) => e.mon == client.mon.first));
    }
    if (client.pintar) {
      cli.addAll(clients!.where((element) => !element!.pintar));
    }
    return Column(
      children: [
        if (client.pintar)
          PageTemp(
            refresh: win
                ? () {
                    database.clientsStreamUpdate();
                  }
                : null,
            title: 'Clients',
            sub: agent!.admin
                ? PageButt(
                    'Add Client',
                    onTap: () {
                      page.updateDashboard(DashboardPages.client);
                    },
                  )
                : null,
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemBuilder: (context, index) {
                  return Tile(
                    title: Text(cli[index]!.name),
                    trail: const Icon(Icons.arrow_forward_ios),
                    tap: () {
                      if (agent.admin) {
                        if (Responsive.isMobile(context)) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ClientProfileMobile(cli[index]!)));
                        } else {
                          page.updateDashboard(DashboardPages.client,
                              cli: cli[index]);
                        }
                      } else {
                        bloc.updateCid(cli[index]!.id!);
                      }
                    },
                  );
                },
                itemCount: cli.length,
              ),
            ],
          ),
        // if (client.pintar)
        //   Button(
        //     text: 'Run',
        //     press: () {
        //       // Checklist
        //       final List<Checklist> check =
        //           Provider.of<List<Checklist>>(context, listen: false);
        //       List<String> ac = AcType.acType(false);

        //         // int i = 0;
        //       // for (Checklist c in check) {

        //       //   if (c.type.contains(AcType.fcu) && c.version == 3 && i == 0) {
        //       //     i++;
        //       //     print('run');
        //       //     Checklist checklist = c.copy();
        //       //     checklist.version = 4;
        //       //     checklist.added = Timestamp.now();

        //       //     print(checklist.item);
        //       //     print(checklist.id);

        //       //     checklist.item.add(ChecklistItem(
        //       //         des: 'On Coil Temperature [Return Air Temperature]',
        //       //         pass: false,
        //       //         value: ['˚C']));
        //       //     checklist.item.add(ChecklistItem(
        //       //         des: 'Off Coil Temperature [Supply Air Temperature]',
        //       //         pass: false,
        //       //         value: ['˚C']));

        //       //     // checklist.item.add(
        //       //     //   ChecklistItem(des: 'des', pass: pass)
        //       //     // )
        //       //     database.addChecklist(checklist);
        //       //     // c.delete = Timestamp.now();
        //       //     // print(c.id);
        //       //     // database.setChecklist(c);
        //       //   }
        //         // if (c.type.contains(AcType.fan) ||
        //         //     c.type.contains(AcType.ct) ||
        //         //     c.type.contains(AcType.chill) ||
        //         //     c.type.contains(AcType.con) ||
        //         //     c.type.contains(AcType.chi)) {
        //         //   if (c.version == 2) {
        //         //     Checklist checklist = c.copy();
        //         //     checklist.delete = Timestamp.now();

        //         //     database.setChecklist(checklist);
        //         //   }
        //         // } else {
        //         //   // Checklist checklist = c.copy();
        //         //   // checklist.version = 3;
        //         //   // checklist.item.add(ChecklistItem(
        //         //   //   des: 'Off Coil Temperature',
        //         //   //   pass: false,
        //         //   //   value: ['˚C'],
        //         //   // ));
        //         //   // checklist.added = Timestamp.now();

        //         //   // database.addChecklist(checklist);
        //         // }
        //       // }
        //     },
        //   ),
        // if (client.pintar)
        //   Button(
        //     text: 'Run',
        //     press: () {
        //       List<ChecklistItem> air = [
        //         ChecklistItem(
        //           des: 'Check condensation',
        //           pass: true,
        //         ),
        //         ChecklistItem(
        //           des: 'Check R/A grills and plenum box',
        //           pass: true,
        //         ),
        //         ChecklistItem(
        //           des: 'Check supply and R/A grills and clean',
        //           pass: true,
        //         ),
        //         ChecklistItem(
        //           des: 'Check for air leak and vibration',
        //           pass: true,
        //         ),
        //         ChecklistItem(
        //           des: 'Clean drip trays and flush',
        //           pass: true,
        //         ),
        //         ChecklistItem(
        //           des: 'Clean R/A filters',
        //           pass: true,
        //         ),
        //         ChecklistItem(
        //           des: 'Replace disposable filter if fitted',
        //           pass: true,
        //         ),
        //         ChecklistItem(
        //           des: 'Check coil for dirt build up',
        //           pass: true,
        //         ),
        //         ChecklistItem(
        //           des: 'Check fan op and vibration / belts',
        //           pass: true,
        //         ),
        //         ChecklistItem(
        //           des: 'Check comp mounts / vibration',
        //           pass: true,
        //         ),
        //         ChecklistItem(
        //           des: 'Check for oil leaks and pipework',
        //           pass: true,
        //         ),
        //         ChecklistItem(
        //           des: 'Check condition of condensers',
        //           pass: true,
        //         ),
        //         ChecklistItem(
        //           des: 'Check refrigerant charge',
        //           pass: true,
        //         ),
        //         ChecklistItem(
        //           des: 'Check elec/timers conts and o/loads',
        //           pass: true,
        //         ),
        //         ChecklistItem(
        //           des: 'Check wiring and terminals',
        //           pass: true,
        //         ),
        //         ChecklistItem(
        //           des: 'Check operation cool',
        //           pass: true,
        //         ),
        //         ChecklistItem(
        //           des: 'Check T/stat and setting',
        //           pass: true,
        //         ),
        //         ChecklistItem(
        //           des: 'Check pipe and insulation',
        //           pass: true,
        //         ),
               
        //         ChecklistItem(
        //           des: 'Check signs of water leaks',
        //           pass: true,
        //         ),
        //         ChecklistItem(
        //           des: 'Compressor suction pressure',
        //           pass: false,
        //           value: ['Psig'],
        //         ),
        //         ChecklistItem(
        //           des: 'Outdoor ambient temperature',
        //           pass: false,
        //           value: ['˚C'],
        //         ),
        //         ChecklistItem(
        //           des: 'Supply air temperature',
        //           pass: false,
        //           value: ['˚C'],
        //         ),
        //       ];

        //       List<Checklist> checklists = [
        //         Checklist(type: [AcType.air], item: air, version: 3),
        //       ];

        //       for (Checklist c in checklists) {
        //         database.addChecklist(c);
        //       }
        //     },
        //   ),
       
        if (!client.pintar)
          PageTemp(
            title: '${client.name} Dashboard',
            children: [
              SearchUnit(),
            ],
          ),
        if (!client.pintar)
          PageTemp(
            refresh: win
                ? () {
                    database.clientStreamUpdate(client.id);
                  }
                : null,
            title: 'Units Current Condition',
            children: [
              UnitCondition(),
            ],
          ),
        if (!client.pintar)
          if (client.mon.isNotEmpty)
            PageTemp(
              refresh: win
                  ? () {
                      database.clientStreamUpdate(client.id);
                    }
                  : null,
              title: Format.intToString(client.mon.first),
              children: [
                ReportSum(report),
              ],
            ),
      ],
    );
  }
}
