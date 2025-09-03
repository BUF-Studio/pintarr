import 'package:flutter/material.dart';

class TileTemp extends StatelessWidget {
  final String left;
  final String right;
  const TileTemp({Key? key, 
    required this.left,
    required this.right,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(left),
        ),
        SizedBox(
          width: 10,
        ),
        Text(right),
        SizedBox(
          width: 5,
        ),
       
      ],
    );
  }
}
