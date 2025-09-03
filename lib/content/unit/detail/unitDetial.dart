import 'package:flutter/material.dart';
import 'package:pintarr/content/unit/detail/viewUnitQrMobile.dart';
import 'package:pintarr/content/unit/unitPage.dart';
import 'package:pintarr/model/type.dart';
import 'package:pintarr/model/unit.dart';
import 'package:pintarr/qr/qrManager.dart';
import 'package:pintarr/service/format.dart';
import 'package:pintarr/widget/responsive.dart';
import 'package:pintarr/widget/textDetail.dart';
import 'package:provider/provider.dart';

class UnitDetail extends StatelessWidget {
  final Unit unit;
  const UnitDetail(this.unit, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final page = Provider.of<UnitNavi>(context);

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          height: 135,
          child: Center(
            child: GestureDetector(
              onTap: () {
                if (!Responsive.isMobile(context)) {
                  page.updateUnit(UnitPages.qr, ut: unit);
                }
                if (Responsive.isMobile(context)) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewUnitQrMobile(unit),
                      ));
                }
              },
              child: QrManager.create(unit.id),
            ),
          ),
        ),
        TextDetail('Unit Name', unit.unitname),
        TextDetail('Unit Serial No.', unit.serialNo),
        TextDetail('Unit Brand', unit.brand ),
        TextDetail('Unit Model', unit.model),
        TextDetail('Unit Type', unit.type),
        TextDetail('Unit Location', unit.location),

        TextDetail('Current Condition', unit.current ?? '---'),

        TextDetail('Last Monthly Service',
            Format.epochToString(unit.lastMonthService)),
        TextDetail('Last Half-yearly Service',
            Format.epochToString(unit.lastHalfService)),
        TextDetail(
            'Last Yearly Service', Format.epochToString(unit.lastYearService)),
        // TextDetail('Last Service', Format.epochToString(unit.lastService)),
        // TextDetail(
        //     'Last Major Service', Format.epochToString(unit.lastMajorService)),

        if (unit.type == AcType.ahu)
          TextDetail('Motor Size Belt', unit.beltSize ?? ''),
        if ((unit.type == AcType.fcu || unit.type == AcType.fan) &&
            unit.belt != null)
          TextDetail('With Belt', unit.belt! ? 'Yes' : 'No'),

        // TextDetail('Service Interval', unit.interval.toString()),
      ],
    );
  }
}
