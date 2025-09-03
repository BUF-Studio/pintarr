import 'package:flutter/material.dart';

// class PassFailButton extends StatelessWidget {
//   PassFailButton(this.pass, this.fail);
//   final pass, fail;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Row(
//         children: <Widget>[
//           Button(Colors.red, fail, 'fail', TextStyle(fontSize: 15)),
//           Button(Colors.green, pass, 'pass', TextStyle(fontSize: 15)),
//         ],
//       ),
//     );
//   }
// }

class Button extends StatelessWidget {
  const Button({
    Key? key,
    // this.color: Colors.blue,
    this.press,
    this.text = 'test',
    // this.textColor: Colors.white,
  }) : super(key: key);
  final void Function()? press;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      height: 45,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          elevation: 3,
          // padding: const EdgeInsets.all(8),
        ),
        onPressed: press,
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Text(
            text,
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class SmallButt extends StatelessWidget {
  final void Function()? func;
  final String? text;
  final Widget? child;
  final Color? color;
  const SmallButt({Key? key, this.func, this.text, this.child, this.color})
    : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        onPressed: func,
        style: ElevatedButton.styleFrom(
          // backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        ),
        child: child ?? Text(text!),
      ),
    );
    // return Container(
    //   margin: const EdgeInsets.symmetric(horizontal: 20),

    //   child: ElevatedButton(
    //     onPressed: func,
    //     style: ButtonStyle(
    //       // foregroundColor: color,
    //       backgroundColor: MaterialStateProperty.all(color),
    //       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    //         RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
    //       ),
    //     ),
    //     child: Container(
    //       padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
    //       child: child ?? Text(text!),
    //     ),
    //   ),
    // );
  }
}
