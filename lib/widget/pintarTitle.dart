import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pintarr/widget/curvedShape.dart';

class PintarMobileTitle extends StatelessWidget {
  const PintarMobileTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      // color: Colors.green,
      child: Stack(
        children: [
          CurvedShape(),
          Align(
            alignment: Alignment(0, -0.4),
            child: Container(
              height: 150,
              margin: EdgeInsets.only(top: 12.5, bottom: 12.5),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SvgPicture.asset('assets/logo.svg'),
              ),
            ),
          ),
          Align(
            alignment: Alignment(0, 0.7),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'PINTAR CARE',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    letterSpacing: 3,
                    color: Colors.grey[800]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PintarTitle extends StatelessWidget {
  final bool small;
  const PintarTitle(this.small, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 300,
      // color: Colors.amber,
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset('assets/logo.svg'),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'PINTAR CARE',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: small ? 18 : 22,
                letterSpacing: small ? 1.5 : 3,
                color: Colors.grey[800]),
          ),
        ],
      ),
    );
  }
}
