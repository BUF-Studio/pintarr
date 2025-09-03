import 'package:flutter/material.dart';
import 'package:pintarr/content/dashboard/livePage.dart';
import 'package:pintarr/model/agent.dart';
import 'package:pintarr/model/client.dart';
import 'package:pintarr/service/clientBloc.dart';
import 'package:pintarr/service/fire/database.dart';
import 'package:pintarr/service/load.dart';
import 'package:pintarr/widget/alert.dart';
import 'package:pintarr/widget/button.dart';
import 'package:pintarr/widget/responsive.dart';
import 'package:pintarr/widget/textBox.dart';
import 'package:pintarr/widget/title.dart';
import 'package:provider/provider.dart';
import 'package:pintarr/service/focus.dart';

class ClientProfile extends StatefulWidget {
  final Client? client;
  const ClientProfile(this.client, {Key? key}) : super(key: key);

  @override
  _ClientProfileState createState() => _ClientProfileState();
}

class _ClientProfileState extends State<ClientProfile> {
   String? _name;
   String? _pass;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Agent? agent = Provider.of<Agent?>(context);
    final ClientBloc bloc = Provider.of<ClientBloc>(context);
    final Database database = Provider.of<Database>(context);
    final DashboardNavi page = Provider.of<DashboardNavi>(context);
    final Client? client = Provider.of<Client?>(context);
    final List<Client?>? clients = Provider.of<List<Client?>?>(context);
    final win = Provider.of<bool>(context);
   
    final load = Provider.of<Load>(context);
    // load.updateLoad(l);

    err(e) {
      return Alert.box(context, 'Error', Text(e), <Widget>[
        Alert.ok(context, () {
          Navigator.of(context).pop();
        }, 'Try Again')
      ]);
    }

    submit() async {
      bool valid = _formKey.currentState!.validate();
      if (valid) {
        load.updateLoad(true);
        _formKey.currentState!.save();

        List<String> clientName = [];
        for (var i in clients!) {
          clientName.add(i!.name.toLowerCase());
        }

        if (widget.client == null) {
          if (clientName.contains(_name!.toLowerCase())) {
            load.updateLoad(false);
            return err(
                'This client name has been used. Please try another name.');
          }
          Client cli = Client(
            name: _name!,
            password: _pass!,
            pintar: false,
            location: [],
            mon: [],

          );
          var id = await database.addClient(cli);
          cli.id = id;
          page.updateDashboard(DashboardPages.client,cli: cli);
        } else {
          Alert.box(
            context,
            'Sure to update?',
            const Text('Are you sure to update client profile?'),
            <Widget>[
              Alert.cancel(context),
              Alert.ok(context, () {
                Navigator.pop(context);
                Client cli = widget.client!.copy();
                // print(_name);
                // print(cli.name);
                if (clientName.contains(_name!.toLowerCase()) &&
                    _name != cli.name) {
                  load.updateLoad(false);
                  return err(
                      'This client name has been used. Please try another name.');
                }
                cli.name = _name!;
                cli.password = _pass!;
                database.setClient(cli);
                if (win) {
                  if (client!.pintar) {
                    database.clientsStreamUpdate();
                  } else {
                    database.clientStreamUpdate(client.id);
                  }
                }
              }, 'Sure'),
            ],
          );
        }

        load.updateLoad(false);
      }
    }

    chg() {
      if (Responsive.isMobile(context)) {
        Navigator.of(context).pop();
      }
      bloc.updateCid(widget.client!.id!);
      page.updateDashboard(DashboardPages.main);
    }

    return Form(
      key: _formKey,
      child: PageTemp(
        title: 'Client Profile',
        onBack: page.page == DashboardPages.client
            ? () {
                page.updateDashboard(DashboardPages.main);
              }
            : null,
        sub: client!.pintar &&
                agent!.admin &&
                widget.client != null &&
                !widget.client!.pintar
            ? PageButt('Delete', onTap:() {
                Alert.box(
                  context,
                  'Sure to delete?',
                  Text('Do you sure to delete ${widget.client!.name}?'),
                  <Widget>[
                    Alert.cancel(context),
                    Alert.ok(context, () {
                      database.deleteClient(widget.client!.id!);
                      Navigator.pop(context);
                      if (Responsive.isMobile(context)) {
                        Navigator.pop(context);
                      } else {
                        page.updateDashboard(DashboardPages.main);
                      }
                    }, 'Sure'),
                  ],
                );

                // bloc.updateCid(widget.client.id);
              })
            : null,
        children: [
          NameTextBox(
            complete: () => context.nextEditableTextFocus(),
            init: widget.client?.name ?? _name,
            onSaved: (v) {
              _name = v;
            },
            validateText: 'Please enter client name.',
            text: 'Name',
          ),
          PasswordTextBox(
            complete: () => submit,
            init: widget.client?.password ?? _pass,
            onSaved: (v) {
              _pass = v;
            },
            validateText: 'Please enter client password.',
            text: 'Password',
          ),
          Button(
            text: widget.client == null ? 'Add' : 'Update',
            press: submit,
          ),
          SizedBox(
            height: 20,
          ),
          if (client.pintar &&
              widget.client != null &&
              !widget.client!.pintar)
            Button(
              text: 'View Client',
              press: chg,
            ),
        ],
      ),
    );
  }
}
