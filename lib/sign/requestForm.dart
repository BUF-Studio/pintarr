import 'package:flutter/material.dart';
import 'package:pintarr/model/agent.dart';
import 'package:pintarr/model/client.dart';
import 'package:pintarr/service/fire/auth.dart';
import 'package:pintarr/service/fire/database.dart';
import 'package:pintarr/service/load.dart';
import 'package:pintarr/widget/alert.dart';
import 'package:pintarr/widget/button.dart';
import 'package:pintarr/widget/textBox.dart';
import 'package:provider/provider.dart';
import 'package:pintarr/service/focus.dart';
//testcomment

class RequestForm extends StatefulWidget {
  const RequestForm({Key? key}) : super(key: key);

  // RequestForm(this.state);
  // final SignState state;
  @override
  _RequestFormState createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _name = '';
  String? _pass = '';

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    // final node = FocusScope.of(context);

    final auth = Provider.of<Auth>(context);
    final agent = Provider.of<Agent?>(context);
    final database = Provider.of<Database>(context);
    final clients = Provider.of<List<Client?>?>(context);
    // final Navi navi = Provider.of<Navi>(context);
    final win = Provider.of<bool>(context);
    // final AgentStream? stream = win ? Provider.of<AgentStream>(context) : null;
    // final ClientsStream? cstream =
    //     win ? Provider.of<ClientsStream>(context) : null;
    err(e) {
      var message = 'An error occurred, please check your credentials!';
      // print(message);
      if (e.message != null) {
        message = e.message;
      }
      return Alert.box(context, 'Error', Text(message), <Widget>[
        Alert.ok(context, () {
          Navigator.of(context).pop();
        }, 'Try Again')
      ]);
    }

    final load = Provider.of<Load>(context);

    submit() async {
      bool valid = _formKey.currentState!.validate();

      if (valid) {
        load.updateLoad(true);
        _formKey.currentState!.save();
        _name = _name?.trim();
        List<Client?>? cli = [];
        if (win) {
          cli = await database.getClients();
        } else {
          cli = clients;
        }
        // print(clients);
        bool ade = false;
        for (var c in cli!) {
          // print(c.name);
          if (c!.name == _name && c.password == _pass) {
            Agent agt = agent!.copy();
            agt.cid = c.id;
            database.setAgent(agt);
            ade = true;
            break;
          }
        }
        load.updateLoad(false);
        if (!ade) {
          return Alert.box(context, 'Invalid Info',
              const Text('Invalid client name or password.'), <Widget>[
            Alert.ok(context, () {
              Navigator.of(context).pop();
            }, 'Try Again')
          ]);
        }
      }
    }

    // final AgentStream stream = win ? Provider.of<AgentStream>(context) : null;
    // out() {
    //   auth.signOut();
    // }

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Please fill in the client name and password.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Your request will be verified by Pintar Care admin or requested client side admin.',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          NameTextBox(
            init: _name ?? '',
            complete: () => context.nextEditableTextFocus(),
            // complete: () => node.nextFocus(),
            enable: _loading == false,
            onSaved: (v) {
              _name = v;
            },
            text: 'Client Name',
            validateText: 'Please enter client name.',
          ),
          PasswordTextBox(
            init: _pass ?? '',
            complete: submit,
            text: 'Password',
            validateText: 'Please enter password. ',
            enable: _loading == false,
            onSaved: (value) {
              _pass = value;
            },
          ),
          Button(
            press: submit,
            text: 'Request',
          ),
        ],
      ),
    );
  }
}
