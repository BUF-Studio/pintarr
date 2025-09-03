import 'package:flutter/material.dart';
import 'package:pintarr/before/before.dart';
import 'package:pintarr/model/agent.dart';
import 'package:pintarr/model/client.dart';
import 'package:pintarr/service/fire/auth.dart';
import 'package:pintarr/service/fire/database.dart';
import 'package:pintarr/service/stream/agentStream.dart';
import 'package:pintarr/sign/requestForm.dart';
import 'package:pintarr/widget/responsive.dart';
import 'package:pintarr/widget/title.dart';
import 'package:provider/provider.dart';

class RequestPage extends StatelessWidget {
  const RequestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final node = FocusScope.of(context);

    final auth = Provider.of<Auth>(context);
    final agent = Provider.of<Agent?>(context);
    final Database database = Provider.of<Database>(context);
    final client = agent!.cid == null ? null : Provider.of<Client?>(context);
    // final Navi navi = Provider.of<Navi>(context);
    
    final win = Provider.of<bool>(context);
    // final AgentStream? stream = win ? Provider.of<AgentStream>(context) : null;

    // final AgentStream stream = win ? Provider.of<AgentStream>(context) : null;
    out() {
      auth.signOut();
    }

    return Before(
      child: PageTemp(
        refresh: win
            ? () {
                database.agentStreamUpdate(agent.id);
              }
            : null,
        card: false,
        title: 'Request Access',
        sub: Responsive.isMobile(context)
            ? IconButton(
                onPressed: out,
                icon: const Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
              )
            : PageButt(
                'Logout',
                onTap: out,
              ),
        children: [
          if (agent.cid == null) RequestForm(),
          if (agent.cid != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your request to access to ${client!.name} have not been approved yet.',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Please contact to Pintar Care admin or ${client.name} admin to have permission to access.',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
