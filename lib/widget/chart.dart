import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pintarr/widget/responsive.dart';

class Chart extends StatelessWidget {
  final double percent;
  final String center, title;
  final Color color;
  const Chart(
      {Key? key, required this.percent,
      required this.center,
      required this.title,
      required this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // print(double.infinity);
    return Container(
      // color: Colors.amber,
      // width: double.infinity,
      // height: ,
      margin: const EdgeInsets.only(top: 5),
      child: CircularPercentIndicator(
        backgroundColor: Colors.grey[200]!,
        radius: Responsive.isMobile(context) ? 45 : 90,
        lineWidth: Responsive.isMobile(context) ? 3 : 7,
        animation: true,
        percent: percent,
        center: Text(
          center,
          style: TextStyle(
            fontSize: Responsive.isMobile(context) ? 18 : 25,
            // fontWeight: FontWeight.bold,
          ),
        ),
        footer: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Container(
            height: 40,
            child: Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Responsive.isMobile(context) ? 14 : 16,

                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        circularStrokeCap: CircularStrokeCap.round,
        progressColor: color,
      ),
    );
  }
}
