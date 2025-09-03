import 'package:flutter/material.dart';
import 'package:pintarr/model/agent.dart';
import 'package:pintarr/model/client.dart';
import 'package:pintarr/service/fire/database.dart';
import 'package:pintarr/service/stream/agentsStream.dart';
import 'package:pintarr/widget/button.dart';
import 'package:pintarr/widget/empty.dart';
import 'package:pintarr/widget/pageList.dart';
import 'package:pintarr/widget/responsive.dart';
import 'package:pintarr/widget/tile.dart';
import 'package:provider/provider.dart';

class UserRequest extends StatelessWidget {
  const UserRequest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Database database = Provider.of<Database>(context);
    final Client? client = Provider.of<Client?>(context);
    final Agent? agent = Provider.of<Agent?>(context);
    final List<Agent?>? agents = Provider.of<List<Agent?>?>(context);
    final bool win = Provider.of<bool>(context);
    // final AgentsStream? agentsStream =
    //     win ? Provider.of<AgentsStream>(context) : null;

    List<Agent?> req = [
      // Agent(username: 'asda'),
      // Agent(username: 'asda'),
    ];

    req.addAll(agents!.where((e) => !e!.access && e.cid == client!.id));

    app(index) {
      Agent agt = req[index]!.copy();
      agt.access = true;
      // agt.
      if (client!.pintar) agt.pintar = true;
      database.setAgent(agt);
      if (win) database.agentsStreamUpdate(client.id);
    }

    dec(index) {
      Agent agt = req[index]!.copy();
      agt.cid = null;
      database.setAgent(agt);
      if (win) database.agentsStreamUpdate(client!.id);
    }

    return PageList(
      refresh: win
          ? () {
              database.agentsStreamUpdate(client!.id);
            }
          : null,
      title: '${client!.name} User Request',
      listView: req.isEmpty
          ? Empty('No User Request')
          : ListView.builder(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: req.length,
              itemBuilder: (context, index) {
                return Tile(
                  tap: () {},
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(req[index]!.username),
                      if (!agent!.admin) Container(),
                      if (agent.admin)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!Responsive.isMobile(context))
                              SmallButt(
                                color: Colors.red,
                                text: 'Decline',
                                func: () {
                                  dec(index);
                                },
                              ),
                            if (Responsive.isMobile(context))
                              IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    dec(index);
                                  }),
                            if (Responsive.isMobile(context))
                              IconButton(
                                  icon: const Icon(
                                    Icons.done,
                                    color: Colors.green,
                                  ),
                                  onPressed: () {
                                    app(index);
                                  }),
                            if (!Responsive.isMobile(context))
                              SmallButt(
                                color: Colors.green,
                                text: 'Approve',
                                func: () {
                                  app(index);
                                },
                              ),
                          ],
                        ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
