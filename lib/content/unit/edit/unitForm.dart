import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pintarr/content/dashboard/unitCondition.dart';
import 'package:pintarr/content/unit/detail/unitDetailMobile.dart';
import 'package:pintarr/content/unit/unitPage.dart';
import 'package:pintarr/model/client.dart';
import 'package:pintarr/model/type.dart';
import 'package:pintarr/model/unit.dart';
import 'package:pintarr/service/controller/unitController.dart';
import 'package:pintarr/service/fire/database.dart';
import 'package:pintarr/service/load.dart';
import 'package:pintarr/service/realTime.dart';
import 'package:pintarr/service/stream/clientStream.dart';
import 'package:pintarr/service/stream/unitStream.dart';
import 'package:pintarr/widget/button.dart';
import 'package:pintarr/widget/dropDown.dart';
import 'package:pintarr/widget/responsive.dart';
import 'package:pintarr/widget/textBox.dart';
import 'package:provider/provider.dart';
import 'package:pintarr/service/focus.dart';

class UnitForm extends StatefulWidget {
  final Unit? unit;
  const UnitForm(this.unit, {Key? key}) : super(key: key);
  // final back;
  // UnitForm(this.back);
  @override
  _UnitFormState createState() => _UnitFormState();
}

class _UnitFormState extends State<UnitForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _serial = '';
  String? _type;
  // String _minor = '';
  // String _major = '';
  String? _location;
  String _newLocation = '';
  String _brand = '';
  String _model = '';

  bool? _belt;
  String _beltSize = '';

  @override
  Widget build(BuildContext context) {
    Unit? unitt = widget.unit;
    final page = Provider.of<UnitNavi>(context);
    final client = Provider.of<Client?>(context);
    final database = Provider.of<Database>(context);
    final win = Provider.of<bool>(context);
    // final clientStream = win ? Provider.of<ClientStream>(context) : null;
    final FocusNode node = FocusScope.of(context);
    final load = Provider.of<Load>(context);
    final UnitsController unitsController =
        Provider.of<UnitsController>(context);
    // load.updateLoad(true);
    // load.updateLoad(false);

    next(Unit unit) {
      if (!Responsive.isMobile(context)) {
        page.updateUnit(UnitPages.detail, ut: unit);
      }
      if (Responsive.isMobile(context)) {
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UnitDetailMobile(unit),
            ));
      }
    }

    submit() async {
      bool valid = _formKey.currentState!.validate();

      if (valid) {
        load.updateLoad(true);
        _formKey.currentState!.save();

        if (unitt == null) {
          Unit unit = Unit(
            location: _location == 'New Location' ? _newLocation : _location!,
            model: _model,
            brand: _brand,
            serialNo: _serial,
            unitname: _name,
            type: _type!,
            // lastUpdate:(win ?? FieldValue.serverTimestamp());
            // lastUpdate:(win ?? FieldValue.serverTimestamp()),
          );

          if (_location == 'New Location') {
            Client newclient = client!.copy();
            List<String> newloc = [];
            newloc.addAll(client.location);
            newloc.add(_newLocation);
            newclient.location = newloc;
            database.setClient(newclient);
          }

          var unitId = await unitsController.addUnit(unit);
          unit.id = unitId;

          next(unit);

          // widget.back(null);
        } else {
          Unit unit = Unit(
            location: (_location ?? unitt.location) == 'New Location'
                ? _newLocation
                : (_location ?? unitt.location),
            model: _model == '' ? unitt.model : _model,
            brand: _brand == '' ? unitt.brand : _brand,
            serialNo: _serial == '' ? unitt.serialNo : _serial,
            unitname: _name == '' ? unitt.unitname : _name,
            type: _type ?? unitt.type,
            id: unitt.id,
            current: unitt.current,
            lastMonthService: unitt.lastMonthService,
            lastHalfService: unitt.lastHalfService,
            lastYearService: unitt.lastYearService,
            belt: _belt ?? unitt.belt,
            beltSize: _beltSize == '' ? unitt.beltSize : _beltSize,
          );

          unitsController.updateUnit(unit);

          if (_location == 'New Location') {
            Client newclient = client!.copy();
            List<String> newloc = [];
            newloc.addAll(client.location);
            newloc.add(_newLocation);
            newclient.location = newloc;
            database.setClient(newclient);
          }
          // widget.back();
          next(unit);
        }
        load.updateLoad(false);
      }
    }

    List<String> loc = [];
    loc.addAll(client!.location);
    loc.add('New Location');

    if (loc.length == 1) _location = 'New Location';

    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          NameTextBox(
            complete: () => context.nextEditableTextFocus(),
            init: unitt?.unitname ?? _name,
            onSaved: (value) {
              _name = value;
            },
            text: 'Unit Name',
            validateText: 'Please enter a unit name. ',
          ),
          NameTextBox(
            complete: () => context.nextEditableTextFocus(),
            init: unitt?.serialNo ?? _serial,
            onSaved: (value) {
              _serial = value;
            },
            text: 'Serial Number',
            validateText: 'Please enter the serial no. of the unit. ',
          ),
          NameTextBox(
            complete: () => context.nextEditableTextFocus(),
            init: unitt?.brand ?? _brand,
            onSaved: (value) {
              _brand = value;
            },
            text: 'Brand',
            validateText: 'Please enter the brand of the unit. ',
          ),
          NameTextBox(
            complete: () => node.unfocus(),
            init: unitt?.model ?? _model,
            onSaved: (value) {
              _model = value;
            },
            text: 'Model',
            validateText: 'Please enter the model of the unit. ',
          ),
          // Text('Type'),
          DropDown(
            item: (e) {
              return DropItem.item(
                name: e,
                value: e,
              );
            },
            validateText: 'Please enter the type of the unit.',
            list: AcType.acType(false),
            onChanged: (n) {
              setState(() {
                _type = n;
              });
            },
            text: 'Type',
            value: _type ?? unitt?.type,
          ),

          DropDown(
            item: (e) {
              return DropItem.item(
                name: e,
                value: e,
              );
            },
            list: loc,
            validateText: 'Please enter the location of the unit.',
            onChanged: (n) {
              setState(() {
                _location = n;
              });
            },
            text: 'Location',
            value: _location ?? unitt?.location,
          ),

          if (_location == 'New Location')
            NameTextBox(
              complete: () => node.unfocus(),
              init: _newLocation,
              onSaved: (value) {
                _newLocation = value;
              },
              text: 'New Location',
              validateText: 'Please fill in the location of the unit.',
            ),

          if (unitt != null &&
              (((_type ?? unitt.type) == AcType.fcu) ||
                  ((_type ?? unitt.type) == AcType.fan)))
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
                    value: (_belt ?? unitt.belt) ?? false,
                    onChanged: (v) {
                      setState(() {
                        _belt = v;
                      });
                    },
                  ),
                ],
              ),
            ),

          if (unitt != null && (_type ?? unitt.type) == AcType.ahu)
            NameTextBox(
              complete: () => node.unfocus(),
              init: unitt.beltSize ?? _beltSize,
              onSaved: (value) {
                _beltSize = value;
              },
              text: 'Motor Size Belt',
            ),

          Button(
            text: unitt == null ? 'Add' : 'Update',
            press: submit,
          ),
        ],
      ),
    );
  }
}
