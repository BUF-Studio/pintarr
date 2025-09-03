import 'package:flutter/material.dart';
import 'package:pintarr/model/client.dart';
import 'package:pintarr/model/unit.dart';
import 'package:pintarr/qr/qrManager.dart';
import 'package:pintarr/service/pdf.dart';
import 'package:pintarr/widget/alert.dart';
import 'package:pintarr/widget/button.dart';
import 'package:pintarr/widget/tile.dart';
import 'package:provider/provider.dart';

class ViewUnitQr extends StatelessWidget {
  final Unit unit;
  const ViewUnitQr(this.unit, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final client = Provider.of<Client?>(context);
    final Pdf pdf = Provider.of<Pdf>(context);
    // final page = Provider.of<UnitNavi>(context);
    dld() {
      return Alert.box(
          context,
          'Downloaded',
          Text(
              'Qr Code successfully downloaded. Please check your download folder.'),
          <Widget>[
            Alert.ok(context, () {
              Navigator.pop(context);
            }, 'Ok')
          ]);
    }

    fail() {
      return Alert.box(context, 'Failed',
          Text('Cant find download directory. Failed to download.'), <Widget>[
        Alert.ok(context, () {
          Navigator.pop(context);
        }, 'Ok')
      ]);
    }

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            width: double.infinity,
            child: QrManager.create(unit.id),
          ),
        ),
        Button(
          press: () async {
            // download
            return Alert.box(
                context,
                'Download',
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Tile(
                      title: const Text('Large'),
                      tap: () async {
                        try {
                          await pdf.qrCode([unit], 1,
                              '${client!.name}_${unit.unitname}_LargeQrCode');
                          Navigator.pop(context);
                          dld();
                        } catch (e) {
                          fail();
                        }
                      },
                    ),
                    Tile(
                      title:const Text('Medium'),
                      tap: () async {
                        try {
                          await pdf.qrCode([unit], 2,
                              '${client!.name}_${unit.unitname}_MediumQrCode');
                          Navigator.pop(context);
                          dld();
                        } catch (e) {
                          fail();
                        }
                      },
                    ),
                    Tile(
                      title: const Text('Normal'),
                      tap: () async {
                        try {
                          await pdf.qrCode([unit], 4,
                              '${client!.name}_${unit.unitname}_NormalQrCode');
                          Navigator.pop(context);
                          dld();
                        } catch (e) {
                          fail();
                        }
                      },
                    ),
                    Tile(
                      title: const Text('Small'),
                      tap: () async {
                        try {
                          await pdf.qrCode([unit], 12,
                              '${client!.name}_${unit.unitname}_SmallQrCode');
                          Navigator.pop(context);
                          dld();
                        } catch (e) {
                          fail();
                        }
                      },
                    ),
                  ],
                ),
                <Widget>[
                  Alert.cancel(context),
                ]);
            // await Pdf()
            //     .qrCode([unit], 1, '${client.name}_${unit.unitname}_QrCode');
          },
          text: 'Download',
        )
      ],
    );
  }
}
