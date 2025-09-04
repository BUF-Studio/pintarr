import 'package:flutter/material.dart';
import 'package:pintarr/after/afterNavi.dart';
import 'package:pintarr/content/report/reportPage.dart';
import 'package:pintarr/content/unit/unitPage.dart';
import 'package:pintarr/model/client.dart';
import 'package:pintarr/service/clientBloc.dart';
import 'package:pintarr/service/fire/database.dart';
import 'package:pintarr/widget/responsive.dart';
import 'package:pintarr/widget/tile.dart';
import 'package:provider/provider.dart';

class ClientBar extends StatelessWidget {
  const ClientBar({super.key});

  // final List<Client> client = [
  //   Client(name: 'pintar'),
  //   Client(name: 'kpj'),
  //   Client(name: 'gleneagle'),
  // ];

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<ClientBloc>(context);
    // final cli = Provider.of<Client?>(context);
    final client = Provider.of<List<Client?>?>(context);
    final unit = Provider.of<UnitNavi>(context);
    final report = Provider.of<ReportNavi>(context);

    final navi = Provider.of<AfterNavi>(context);

    final Database database = Provider.of<Database>(context);
    final win = Provider.of<bool>(context);
    return ListView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: client!.length,
      itemBuilder: (context, index) {
        return Tile(
          title: Text(client[index]!.name),
          selected: client[index]!.id == bloc.cid,
          color: Colors.white,
          selectedColor: Colors.grey[300],
          trail: Responsive.isMobile(context)
              ? null
              : const Icon(Icons.arrow_forward_ios),
          tap: () {
            bloc.updateCid(client[index]!.id!);
            if (client[index]!.pintar) navi.updatePage(AfterPages.dashboard);

            unit.updateUnit(UnitPages.main);
            report.updateReport(ReportPages.main);
            if (win) {
              if (client[index]!.pintar) {
                database.clientsStreamUpdate();
              } else {
                database.clientStreamUpdate(client[index]!.id);
              }
            }
            if (Responsive.isMobile(context)) Navigator.pop(context);
          },
        );
      },
    );
  }
}
