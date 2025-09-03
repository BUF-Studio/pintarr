import 'package:flutter/material.dart';
import 'package:pintarr/content/unit/edit/unitForm.dart';
import 'package:pintarr/content/unit/unitPage.dart';
import 'package:pintarr/model/client.dart';
import 'package:pintarr/model/unit.dart';
import 'package:pintarr/service/controller/unitController.dart';
import 'package:pintarr/service/fire/database.dart';
import 'package:pintarr/service/importFile.dart';
import 'package:pintarr/service/stream/clientStream.dart';
import 'package:pintarr/service/stream/unitStream.dart';
import 'package:pintarr/widget/alert.dart';
import 'package:pintarr/widget/title.dart';
import 'package:provider/provider.dart';

class EditUnitPage extends StatelessWidget {
  const EditUnitPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final page = Provider.of<UnitNavi>(context);
    final client = Provider.of<Client?>(context);
    final database = Provider.of<Database>(context);
    // final win = Provider.of<bool>(context);
    // final stream = win ? Provider.of<UnitStream>(context) : null;
    // final cstream = win ? Provider.of<ClientStream>(context) : null;
    final UnitsController unitsController=  Provider.of<UnitsController>(context);

    import() async {
      try {
        var pp = await ImportFile().readUnit(client!.location);
        if (pp.runtimeType == int) {
          return Alert.box(
            context,
            'Failed',
            Text('Format Error on line $pp'),
            <Widget>[
              Alert.ok(context, () {
                Navigator.pop(context);
              }, 'Ok')
            ],
          );
        } else {
          for (Unit p in pp[0]) {
            database.addUnit(client.id!, p);
          }
          if (client.location.length != pp[1].length) {
            Client ccli = client.copy();
            ccli.location = pp[1];
            database.setClient(ccli);
          }

          return Alert.box(
            context,
            'Success',
            Text('Succesfully imported ${pp.length} units'),
            <Widget>[
              Alert.ok(context, () {
                Navigator.pop(context);
                // widget.back();
              }, 'Ok')
            ],
          );
        }
      } catch (e) {}
    }

    delete() {
      Alert.box(
          context,
          'Sure to Delete ?',
          Text(
              'Once deleted, all data will be deleted and cannot be recovered.'),
          <Widget>[
            Alert.cancel(context),
            Alert.ok(
              context,
              () {
                unitsController.deleteUnit(page.unit!);
                
                Navigator.pop(context);
                page.updateUnit(UnitPages.main);
              },
              'Ok',
            ),
          ]);
    }

    return PageTemp(
      title: page.unit == null ? 'Add Unit' : 'Update Unit',
      sub: page.unit == null
          // ?
          ? PageButt(
              'Import File',
              onTap: import,
            )
          : PageButt(
              'Delete Unit',
              onTap: delete,
            ),
      children: [
        UnitForm(page.unit),
      ],
      onBack: () {
        page.unit == null
            ? page.updateUnit(UnitPages.main)
            : page.updateUnit(UnitPages.detail, ut: page.unit);
      },
    );
  }
}
