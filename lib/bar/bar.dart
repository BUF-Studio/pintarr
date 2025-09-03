import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pintarr/after/afterNavi.dart';
import 'package:pintarr/bar/clientBarr.dart';
import 'package:pintarr/bar/functionBar.dart';
import 'package:pintarr/model/agent.dart';
import 'package:pintarr/model/client.dart';
import 'package:pintarr/service/fire/database.dart';
import 'package:pintarr/widget/responsive.dart';
import 'package:pintarr/widget/tile.dart';
import 'package:pintarr/widget/title.dart';
import 'package:provider/provider.dart';

class Bar extends StatelessWidget {
  const Bar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navi = Provider.of<AfterNavi>(context);
    final client = Provider.of<Client?>(context);
    final agent = Provider.of<Agent?>(context);
    final Database database = Provider.of<Database>(context);
    final win = Provider.of<bool>(context);
    // Stream
    // final node
    return SafeArea(
      child: Container(
        // width: 220,

        // width: 100,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // if (Responsive.isMobile(context))

            // if (!Responsive.isMobile(context))
            // if (!Responsive.isMobile(context))

            const SizedBox(height: 10),

            Tile(
              title: const Text('Pintar Care'),
              lead: Container(
                width: 50,
                height: 50,
                child: SvgPicture.asset('assets/logo.svg'),
              ),
              selected: false,
              trail: win
                  ? Refresh(() {
                      if (agent!.pintar) database.clientsStreamUpdate();
                      if (agent.cid != null && agent.access) {
                        database.clientStreamUpdate(client!.id);
                        database.agentsStreamUpdate(client.id);
                      }
                      database.agentStreamUpdate(agent.id);
                    })
                  : Responsive.isMobile(context)
                      ? Material(
                          color: Colors.white,
                          // color: Colors.red,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                          ),
                        )
                      : null,
            ),
            const Divider(),
            // Text(Responsive.isTablet(context) ? 'tab' : 'bar'),
            if (!agent!.pintar)
              Tile(
                title: Text(client!.name),
              ),
            if (agent.pintar)
              Expanded(
                child: ClientBar(),
              ),
            if (!Responsive.isMobile(context))
              Expanded(
                child: FunctionBar(),
              ),

            if (!Responsive.isMobile(context)) const SizedBox(height: 20),
            if (!Responsive.isMobile(context))
              Tile(
                color: Colors.white,
                selectedColor: Colors.grey[100],
                lead: const Icon(Icons.settings),
                title: const Text('Setting'),
                tap: () {
                  navi.updatePage(AfterPages.setting);
                },
              ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
