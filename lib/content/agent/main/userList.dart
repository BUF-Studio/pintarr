import 'package:flutter/material.dart';
import 'package:pintarr/color.dart';
import 'package:pintarr/model/agent.dart';
import 'package:pintarr/model/client.dart';
import 'package:pintarr/service/fire/database.dart';
import 'package:pintarr/service/stream/agentsStream.dart';
import 'package:pintarr/widget/alert.dart';
import 'package:pintarr/widget/empty.dart';
import 'package:pintarr/widget/pageList.dart';
import 'package:pintarr/widget/tile.dart';
import 'package:provider/provider.dart';

class UserList extends StatelessWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Client? client = Provider.of<Client?>(context);
    final Database database = Provider.of<Database>(context);
    final List<Agent?>? agents = Provider.of<List<Agent?>?>(context);

    final Agent? agt = Provider.of<Agent?>(context);
    final bool win = Provider.of<bool>(context);
    // final AgentsStream? agentsStream =
    //     win ? Provider.of<AgentsStream>(context) : null;

    List<Agent?> agent = [];

    agent.addAll(agents!.where((e) => e!.access));
    // print(agents);

    return PageList(
      refresh: win
          ? () {
              database.agentsStreamUpdate(client!.id);
            }
          : null,
      title: '${client!.name} Users',
      listView: agent.isEmpty
          ? Empty('No User Found.')
          : ListView.builder(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: agent.length,
              itemBuilder: (context, index) {
                // print(agent[index].id == agt.id || !agt.admin);
                return Tile(
                  title: Text(agent[index]!.username),
                  lead: IconButton(
                      icon: Icon(
                        Icons.person,
                        color: agent[index]!.admin ? darkBlue : Colors.grey,
                      ),
                      onPressed: agent[index]!.id == agt!.id || !agt.admin
                          ? null
                          : () {
                              Alert.box(
                                context,
                                'Admin',
                                Text(
                                    'Are you sure to give ${agent[index]!.username} admin permission?'),
                                <Widget>[
                                  Alert.cancel(context),
                                  Alert.ok(context, () {
                                    Agent upt = agent[index]!.copy();
                                    upt.admin = upt.admin ? false : true;
                                    database.setAgent(upt);
                                    if (win) database.agentsStreamUpdate(upt.cid);
                                    Navigator.pop(context);
                                  }, 'Sure'),
                                ],
                              );
                            }),
                  trail: agent[index]!.id == agt.id || !agt.admin
                      ? null
                      : IconButton(
                          icon: const Icon(
                            Icons.delete_forever,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            Alert.box(
                              context,
                              'Remove User',
                              Text(
                                  'Are you sure to remove the permission of ${agent[index]!.username} to access Pintar Care?'),
                              <Widget>[
                                Alert.cancel(context),
                                Alert.ok(context, () {
                                  Agent upt = agent[index]!.copy();
                                  upt.admin = false;
                                  upt.access = false;
                                  upt.pintar = false;
                                  upt.cid = null;
                                  database.setAgent(upt);
                                  if (win)database.agentsStreamUpdate(upt.cid);
                                  Navigator.pop(context);
                                }, 'Sure'),
                              ],
                            );
                          }),
                  tap: () {},
                );
              },
            ),
    );
  }
}
