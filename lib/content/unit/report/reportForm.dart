import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pintarr/content/unit/unitPage.dart';
import 'package:pintarr/model/agent.dart';
import 'package:pintarr/model/checklist.dart';
import 'package:pintarr/model/checklistItem.dart';
import 'package:pintarr/model/client.dart';
import 'package:pintarr/model/report.dart';
import 'package:pintarr/model/reportType.dart';
import 'package:pintarr/model/type.dart';
import 'package:pintarr/model/unit.dart';
import 'package:pintarr/service/controller/checklistController.dart';
import 'package:pintarr/service/controller/reportController.dart';
import 'package:pintarr/service/controller/unitController.dart';
import 'package:pintarr/service/fire/database.dart';
import 'package:pintarr/service/format.dart';
import 'package:pintarr/service/load.dart';
import 'package:pintarr/service/realTime.dart';
import 'package:pintarr/widget/alert.dart';
import 'package:pintarr/widget/button.dart';
import 'package:pintarr/widget/dropDown.dart';
import 'package:pintarr/widget/responsive.dart';
import 'package:pintarr/widget/textBox.dart';
import 'package:provider/provider.dart';
import 'package:pintarr/service/focus.dart';

// extension Utility on BuildContext {
//   void nextEditableTextFocus() {
//     do {
//       FocusScope.of(this).nextFocus();
//     } while (FocusScope.of(this).focusedChild.context.widget is! EditableText);
//   }
// }

class ReportForm extends StatefulWidget {
  final Unit unit;
  const ReportForm(this.unit, {Key? key}) : super(key: key);
  @override
  _ReportFormState createState() => _ReportFormState();
}

class _ReportFormState extends State<ReportForm> {
  final _formKey = GlobalKey<FormState>();

  List<dynamic> ans = [];
  List<String> que = [];
  List<String> val = [];

  var condition = [
    'Good',
    'Problem',
    'Down',
  ];

  String? con;
  String? com;
  ReportType? rtype;

  bool? belt = false;
  String? beltSize;

  File? att;

  @override
  Widget build(BuildContext context) {
    List<String?>? type = [
      reportTypeToString(ReportType.month),
      if (widget.unit.type == AcType.split ||
          widget.unit.type == AcType.waste ||
          widget.unit.type == AcType.chik ||
          widget.unit.type == AcType.frek)
        reportTypeToString(ReportType.three),
      if (widget.unit.type != AcType.split &&
          widget.unit.type != AcType.waste &&
          widget.unit.type != AcType.chik &&
          widget.unit.type != AcType.frek)
        reportTypeToString(ReportType.half),
      if (widget.unit.type != AcType.split &&
          widget.unit.type != AcType.waste &&
          widget.unit.type != AcType.chik &&
          widget.unit.type != AcType.frek)
        reportTypeToString(ReportType.year),
      reportTypeToString(ReportType.repair),
      reportTypeToString(ReportType.breakdown),
    ];
    final page = Provider.of<UnitNavi>(context);
    final client = Provider.of<Client?>(context);
    final agent = Provider.of<Agent?>(context);
    final database = Provider.of<Database>(context);
    final ChecklistsController checklistsController =
        Provider.of<ChecklistsController>(context);
    final win = Provider.of<bool>(context);
    // final clientStream = win ? Provider.of<ClientStream>(context) : null;
    final Checklist check = checklistsController.getChecklist(widget.unit.type);

    print('check');
    print(check);
    final List<ChecklistItem> ques = check.item;
    final FocusNode node = FocusScope.of(context);

    final load = Provider.of<Load>(context);
    final UnitsController unitsController =
        Provider.of<UnitsController>(context);
    final ReportsController reportsController =
        Provider.of<ReportsController>(context);

    submit() async {
      bool valid = _formKey.currentState!.validate();

      if (valid) {
        load.updateLoad(true);
        _formKey.currentState!.save();

        Alert.box(
            context,
            'Submit Report',
            const Text(
                'Sure to submit report? Once submitted, editing are not allowed.'),
            <Widget>[
              Alert.cancel(context),
              Alert.ok(context, () async {
                var t;
                try {
                  t = await RealTime.now();
                } catch (e) {
                  t = DateTime.now();
                }
                Unit unit = widget.unit;

                // List<Map<String, dynamic>> data = [];
                // for (var t = 0; t < que.length; t++) {
                //   var nd = {
                //     'ques': que[t],
                //     'ans': ans[t],
                //     'val': val[t],
                //   };
                //   data.add(nd);
                // }

                var mon = Format.dateToMonth(t);

                List<String?> data = [];

                for (var a in ans) {
                  // print(a);
                  if (a == null) {
                    data.add(null);
                  } else {
                    if (a.runtimeType == bool) {
                      data.add(a ? 'Pass' : 'Fail');
                    } else {
                      data.add(a.join(' / '));
                    }
                  }
                }

                Unit ut = widget.unit.copy();
                if ((widget.unit.type == AcType.fcu ||
                        widget.unit.type == AcType.fan) &&
                    (widget.unit.belt == null || widget.unit.belt != belt)) {
                  ut.belt = belt;
                  unitsController.updateUnit(ut);
                }

                if ((widget.unit.type == AcType.ahu &&
                    (widget.unit.beltSize == null ||
                        widget.unit.beltSize == ''))) {
                  ut.beltSize = beltSize;
                  unitsController.updateUnit(ut);
                }

                Report rep = Report(
                  unitname: unit.unitname,
                  data: data,
                  by: agent!.username,
                  checked: false,
                  comment: com ?? '',
                  date: t.millisecondsSinceEpoch,
                  current: con!,
                  reportType: rtype!,
                  cid: client!.id!,
                  mon: mon,
                  uid: unit.id!,
                  location: unit.location,
                  serial: unit.serialNo,
                  model: unit.model,
                  type: unit.type,
                  version: check.version,
                  belt: ut.belt,
                  beltSize: ut.beltSize,
                );

                if (!client.mon.contains(mon)) {
                  Client cli = client.copy();
                  List<int> newMon = [];
                  newMon.addAll(client.mon);
                  newMon.add(mon);
                  newMon.sort((b, a) => a.compareTo(b));
                  // print('newMon');
                  // print(newMon);
                  cli.mon = newMon;
                  database.setClient(cli);
                }

                // Unit ut = widget.unit.copy();
                // ut.lastService = t.millisecondsSinceEpoch;
                // if (rtype == 'Major Service')
                //   ut.lastMajorService = t.millisecondsSinceEpoch;

                // database.setUnit(ut, client.id, unitStream);

                // var rid =

                reportsController.addReport(rep);

                // if (att != null) {
                //   String filename = client.id + '_' + rid + '.pdf';
                //   final ref = FirebaseStorage.instance
                //       .ref()
                //       .child('report')
                //       .child(filename);
                //   await ref.putFile(att);

                //   var url = await ref.getDownloadURL();

                //   rep.attachName = filename;
                //   rep.id = rid;
                //   rep.attachUrl = url;
                //   database.setReport(rep, client.id, reportStream);
                // }
                Navigator.of(context).pop();
                if (Responsive.isMobile(context)) {
                  Navigator.of(context).pop();
                } else {
                  page.updateUnit(UnitPages.detail, ut: ut);
                }
              }, 'Sure')
            ]);
        load.updateLoad(false);
        // Report report =
      }
    }

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(top: 5, left: 20),
            child: Text(
              'Report Type :',
              style: TextStyle(fontSize: 18),
            ),
          ),
          DropDown(
            item: (e) {
              return DropItem.item(
                name: e,
                value: e,
              );
            },
            list: type,
            validateText: 'Please select the type of the report.',
            onChanged: (n) {
              setState(() {
                rtype = reportTypeFromString(n);
                print('rtypr');
                print(rtype);
              });
            },
            text: 'Report Type',
            value: reportTypeToString(rtype),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 20),
            child: Text(
              'Unit Current Condition :',
              style: TextStyle(fontSize: 18),
            ),
          ),
          DropDown(
            item: (e) {
              return DropItem.item(
                name: e,
                value: e,
              );
            },
            list: condition,
            validateText: 'Please enter the current condition of the unit.',
            onChanged: (n) {
              setState(() {
                con = n;
              });
            },
            text: 'Unit Current Condition',
            value: con,
          ),
          if ((widget.unit.type == AcType.fcu ||
                  widget.unit.type == AcType.fan) &&
              widget.unit.belt == null)
            Padding(
              padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'With Belt',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Switch(
                    value: belt ?? widget.unit.belt!,
                    onChanged: (v) {
                      setState(() {
                        belt = v;
                      });
                    },
                  ),
                ],
              ),
            ),
          if (widget.unit.type == AcType.ahu &&
              (widget.unit.beltSize == null || widget.unit.beltSize == ''))
            const Padding(
              padding: EdgeInsets.only(top: 15, left: 20),
              child: Text(
                'Motor Size Belt:',
                style: TextStyle(fontSize: 18),
              ),
            ),
          if (widget.unit.type == AcType.ahu &&
              (widget.unit.beltSize == null || widget.unit.beltSize == ''))
            NameTextBox(
              complete: () => node.unfocus(),
              onSaved: (value) {
                beltSize = value;
              },
              validateText: 'Please fill in this field.',
              text: 'Motor Size Belt',
            ),
          const SizedBox(
            height: 10,
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: ques.length,
              itemBuilder: (context, index) {
                var q = ques[index];

                if (q.pass && ans.length < ques.length) ans.add(true);
                if (!q.pass && ans.length < ques.length) {
                  List<String> i = [];
                  for (var e in q.value!) {
                    i.add('');
                  }
                  ans.add(i);
                }

                if (ans[index] == null) {
                  ans[index] = true;
                }

                if (que.length < ques.length) {
                  if (q.pass) {
                    val.add('');
                  } else {
                    val.add(q.value![0]!);
                  }
                  que.add(q.des);
                }

                if ((widget.unit.type == AcType.fcu ||
                        widget.unit.type == AcType.fan) &&
                    (!(widget.unit.belt ?? belt!) &&
                        q.belt != null &&
                        q.belt!)) {
                  ans[index] = null;
                  return Container();
                }
                if (widget.unit.type == AcType.cas &&
                    q.belt != null &&
                    q.belt!) {
                  ans[index] = null;
                  return Container();
                }

                if (rtype != null &&
                    rtype != ReportType.month &&
                    rtype != ReportType.half &&
                    rtype != ReportType.three &&
                    rtype != ReportType.year &&
                    q.service != null &&
                    q.service!) {
                  ans[index] = null;
                  return Container();
                }
                if (rtype != null &&
                    rtype != ReportType.repair &&
                    rtype != ReportType.breakdown &&
                    q.service != null &&
                    !q.service!) {
                  ans[index] = null;
                  return Container();
                }

                if (rtype != null &&
                    q.half != null &&
                    q.half! &&
                    rtype != ReportType.repair &&
                    rtype != ReportType.breakdown &&
                    rtype != ReportType.half &&
                    rtype != ReportType.three &&
                    rtype != ReportType.year) {
                  ans[index] = null;
                  return Container();
                }
                if (rtype != null &&
                    q.year != null &&
                    q.year! &&
                    rtype != ReportType.repair &&
                    rtype != ReportType.breakdown &&
                    rtype != ReportType.year) {
                  ans[index] = null;
                  return Container();
                }

                // if (rtype != null &&
                //     q.half != null &&
                //     q.half &&
                //     rtype != ReportType.half) {
                //   ans[index] = null;
                //   return Container();
                // }
                // if (rtype != null &&
                //     q.year != null &&
                //     !q.year &&
                //     rtype != ) {
                //   ans[index] = null;
                //   return Container();
                // }

                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),

                  // const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        child: Text(
                          q.des,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      if (q.pass) _pass(index),
                      if (!q.pass)
                        _ans(
                          index,
                          q.value,
                        ),
                    ],
                  ),
                );
              }),
          MultilineTextBox(
            complete: () => node.unfocus(),
            onSaved: (v) {
              com = v;
            },
            text: 'Comment',
          ),
          Button(
            text: 'Submit',
            press: submit,
            // press: () {},
          ),
        ],
      ),
    );
  }

  _pass(index) {
    return Container(
      height: 60,
      child: Row(
        children: [
          Expanded(
            child: _passButton(index, false, 'X'),
          ),
          Expanded(
            child: _passButton(index, true, '/'),
          ),
        ],
      ),
    );
  }

  _passButton(index, pass, text) {
    return Center(
      child: Container(
        child: Material(
          color: Colors.grey[50],
          child: InkWell(
            // hoverColor: ,
            // highlightColor: Colors.red,
            onTap: () {
              setState(() {
                ans[index] = pass;
              });
              // print(ans[index]);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              decoration: ans[index] == pass
                  ? BoxDecoration(
                      border: Border.all(
                        width: 3,
                        color: pass ? Colors.green : Colors.red,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    )
                  : const BoxDecoration(),
              child: Text(
                text,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _ans(index, value) {
    // _text =

    return Container(
        width: double.infinity,
        child: Row(
          children: [
            expandedTextbox(value, index, 0),
            if (value.length == 3 || value.length == 2) slash(),
            if (value.length == 3 || value.length == 2)
              expandedTextbox(value, index, 1),
            if (value.length == 3) slash(),
            if (value.length == 3) expandedTextbox(value, index, 2),
          ],
        ));
  }

  Text slash() => Text(
        '/',
        style: TextStyle(fontSize: Responsive.isMobile(context) ? 18 : 30),
      );

  expandedTextbox(value, index, idx) {
    return Expanded(
      child: value[idx] == ''
          ? NameTextBox(
              complete: () => context.nextEditableTextFocus(),
              onSaved: (v) {
                ans[index][idx] = v;
              },

              validateText: 'Please fill in ths field',
              // text: ,
            )
          : NumTextBox(
              complete: () => context.nextEditableTextFocus(),
              onSaved: (v) {
                ans[index][idx] = v;
              },
              suffix: value[idx],
              validateText: 'Please fill in ths field',
            ),
    );
  }
}

// 8tq4fy7VBSQsZDHm73pzP3cD6Ei1
