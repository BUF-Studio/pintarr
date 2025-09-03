import 'package:flutter/material.dart';

class Empty extends StatelessWidget {
  final String text;
  const Empty(this.text, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Text(
                text,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}
