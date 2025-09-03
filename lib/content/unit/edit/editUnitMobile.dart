import 'package:flutter/material.dart';
import 'package:pintarr/content/mobile.dart';
import 'package:pintarr/content/unit/edit/unitForm.dart';
import 'package:pintarr/model/unit.dart';
import 'package:pintarr/service/clientBloc.dart';
import 'package:pintarr/service/controller/unitController.dart';
import 'package:pintarr/service/fire/database.dart';
import 'package:pintarr/widget/alert.dart';
import 'package:provider/provider.dart';

class EditUnitMobile extends StatelessWidget {
  final Unit? unit;
  const EditUnitMobile(this.unit, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Database database = Provider.of<Database>(context);
    final ClientBloc client = Provider.of<ClientBloc>(context);
    final UnitsController unitsController =
        Provider.of<UnitsController>(context);

    return Mobile(
      body: UnitForm(unit),
      action: [
        if (unit != null)
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              Alert.box(
                  context,
                  'Sure to Delete ?',
                  const Text(
                      'Once deleted, all data will be deleted and cannot be recovered.'),
                  <Widget>[
                    Alert.cancel(context),
                    Alert.ok(
                      context,
                      () {
                        unitsController.deleteUnit(unit!);
                       

                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      'Ok',
                    ),
                  ]);
            },
          ),
      ],
      title: 'Units',
    );
  }
}
