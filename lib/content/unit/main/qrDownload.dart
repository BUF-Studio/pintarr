import 'package:flutter/material.dart';
import 'package:pintarr/model/client.dart';
import 'package:pintarr/model/unit.dart';
import 'package:pintarr/service/controller/unitController.dart';
import 'package:pintarr/service/pdf.dart';
import 'package:pintarr/service/stream/unitStream.dart';
import 'package:pintarr/widget/alert.dart';
import 'package:pintarr/widget/tile.dart';
import 'package:pintarr/widget/title.dart';
import 'package:provider/provider.dart';

class QrsDownload extends StatelessWidget {
  const QrsDownload({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final units = Provider.of<List<Unit>>(context);
    final client = Provider.of<Client?>(context);
    final win = Provider.of<bool>(context);
    final Pdf pdf = Provider.of<Pdf>(context);
    // final cstream = Provider.of<ClientStream>(context);
    // List<Unit> unitss = [];
    // unitss.addAll(units);
    dld() {
      return Alert.box(
          context,
          'Downloaded',
          const Text(
              'Qr Codes successfully downloaded. Please check your download folder.'),
          <Widget>[
            Alert.ok(context, () {
              Navigator.pop(context);
            }, 'Ok')
          ]);
    }

    fail() {
      return Alert.box(
          context,
          'Failed',
          const Text('Cant find download directory. Failed to download.'),
          <Widget>[
            Alert.ok(context, () {
              Navigator.pop(context);
            }, 'Ok')
          ]);
    }

    return PageTemp(
      title: 'Download Qr Codes',
      sub: PageButt(
        'Download',
        onTap: () async {
          String name = '${client!.name}QrCodes';
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
                        await pdf.qrCode(units, 1, name + 'Large');
                        Navigator.pop(context);

                        dld();
                        // Alert.box(context, loc, null, <Widget>[
                        //   Alert.cancel(context),
                        // ]);
                      } catch (e) {
                        fail();
                      }
                    },
                  ),
                  Tile(
                    title: const Text('Medium'),
                    tap: () async {
                      try {
                        await pdf.qrCode(units, 2, name + 'Medium');
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
                        await pdf.qrCode(units, 4, name + 'Normal');
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
                        await pdf.qrCode(units, 12, name + 'Small');
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
        },
      ),
    );
  }
}
