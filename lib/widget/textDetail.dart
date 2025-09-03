import 'package:flutter/material.dart';

class TextDetail extends StatelessWidget {
  final String left, right;
  final bool copy;
  const TextDetail(this.left, this.right, {Key? key, this.copy = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Text(
          //     title,
          //     style: TextStyle(fontSize: 16),
          //   ),
          //   Text(
          //     det,
          //     style: TextStyle(fontSize: 16),
          //   ),
          Text(
              left,
              style: TextStyle(fontSize: 16),
              
              
            ),
          SizedBox(
            width: 20,
          ),
          if (copy)
            Expanded(
              child: SelectableText(
                right,
                textAlign: TextAlign.end,
                style: TextStyle(fontSize: 16),
              ),
            ),
          if (!copy)
            Expanded(
              child: Text(
                right,
                textAlign: TextAlign.end,
                style: TextStyle(fontSize: 16),
              ),
            ),
        ],
      ),
    );
  }
}

class TextCheck extends StatelessWidget {
  final String title;
  final bool init;
  final func;
  const TextCheck(this.title, this.init, this.func, {Key? key}) : super(key: key);

  // bool val;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16),
          ),
          Checkbox(
              value: init,
              onChanged: (v) {
                // setState(() {
                //   val = v;
                // });
                func(v);
              })
        ],
      ),
    );
  }
}
