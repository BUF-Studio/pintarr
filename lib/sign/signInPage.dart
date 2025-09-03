import 'package:flutter/material.dart';
import 'package:pintarr/before/before.dart';
import 'package:pintarr/sign/signInForm.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Before(
      child: SignInForm(),
    );
  }
}
