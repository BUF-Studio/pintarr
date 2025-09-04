import 'dart:io';
import 'package:collection/collection.dart';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:flutter_qr_reader/flutter_qr_reader.dart';
import 'package:pintarr/after/afterNavi.dart';
import 'package:pintarr/content/unit/detail/unitDetailMobile.dart';
import 'package:pintarr/content/unit/unitPage.dart';
import 'package:pintarr/model/unit.dart';
import 'package:pintarr/qr/scanPage.dart';
import 'package:pintarr/service/importFile.dart';
import 'package:pintarr/widget/alert.dart';
import 'package:pintarr/widget/responsive.dart';
import 'package:pintarr/widget/textBox.dart';
import 'package:provider/provider.dart';
// import 'package:qr_code_tools/qr_code_tools.dart';

class SearchBarr extends StatelessWidget {
  final void Function(dynamic)? chg;
  // final void Function()? clear;
  final String? init;
  // final TextEditingController? con;
  const SearchBarr({
    Key? key,
    this.chg,
    this.init,

    // this.press,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // final UnitsController unitsController = Provider.of<UnitsController>(context);
    final units = Provider.of<List<Unit>>(context);
    final navi = Provider.of<AfterNavi>(context);
    final unitNavi = Provider.of<UnitNavi>(context);

    MobileScannerController controller = MobileScannerController();

    alert() {
      return Alert.box(
        context,
        'Error',
        const Text('Error while interprting qrcode from image.'),
        <Widget>[
          Alert.ok(context, () {
            Navigator.of(context).pop();
          }, 'Try Again'),
        ],
      );
      // print(e);
    }

    qr() async {
      if (Platform.isIOS || Platform.isAndroid) {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const ScanPage()));
      } else {
        String? path = await ImportFile.choose();

        try {
          final result = await controller.analyzeImage(path!);

          if (result!.barcodes.isNotEmpty) {
            String? res = result.barcodes.first.rawValue;

            Unit? unit = units.firstWhereOrNull((e) => e.id == res);
            if (unit != null) {
              if (!Responsive.isMobile(context)) {
                navi.updatePage(AfterPages.unit);
                unitNavi.updateUnit(
                  UnitPages.detail,
                  ut: unit,
                  backk: unitNavi.unit,
                );
              }
              if (Responsive.isMobile(context)) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => UnitDetailMobile(unit),
                  ),
                );
              }
            }
          }
        } catch (e) {
          alert();
        }

        // try {
        //   var result = await FlutterQrReader.imgScan(path!);

        //   Unit? unit = units.firstWhereOrNull((e) => e.id == result);
        //   if (unit != null) {
        //     if (!Responsive.isMobile(context)) {
        //       navi.updatePage(AfterPages.unit);
        //       unitNavi.updateUnit(UnitPages.detail,
        //           ut: unit, backk: unitNavi.unit);
        //     }
        //     if (Responsive.isMobile(context)) {
        //       Navigator.of(context).push(MaterialPageRoute(
        //           builder: (context) => UnitDetailMobile(unit)));
        //     }
        //   }
        // } catch (e) {
        //   alert();
        // }
      }
    }

    return Row(
      children: [
        Expanded(
          child: SearchTextBox(
            onChg: chg,
            init: init,
            // controller: con,
          ),
        ),

        IconButton(icon: const Icon(Icons.qr_code), onPressed: qr),
        const SizedBox(width: 20),
      ],
    );
  }
}
