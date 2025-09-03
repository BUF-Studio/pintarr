import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Alert {
  static cancel(context) {
    if (Platform.isIOS || Platform.isMacOS) {
      return CupertinoDialogAction(
        isDefaultAction: true,
        child: Text("Cancel"),
        onPressed: () {
          Navigator.pop(context);
        },
      );
    }
    return TextButton(
      child: Text('Cancel'),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  static ok(context, func, text) {
    if (Platform.isIOS || Platform.isMacOS) {
      return CupertinoDialogAction(
        isDefaultAction: true,
        child: Text(text ?? 'Confirm'),
        onPressed: func,
      );
    }
    return TextButton(
      child: Text(text ?? 'Confirm'),
      onPressed: func,
    );
  }

  static box(context, text, Widget con, acc) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        if (Platform.isIOS || Platform.isMacOS) {
          return CupertinoAlertDialog(
            title: Text(text),
            content: con,
            actions: acc,
          );
        }
        return AlertDialog(
          title: Text(
            text,
          ),
          content: con,
          actions: acc,
        );
      },
    );
  }

  

  // static Future change(context) {
  //   return box(
  //       context, 'Sure to quit?', Text('Your changes may not be saved.'), <Widget>[
  //     cancel(context),
  //     ok(context, () {
  //       Navigator.pop(context);
  //       Navigator.pop(context);
  //     }, null)
  //   ]);
  // }
}
