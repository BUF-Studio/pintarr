import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_mail_app_plus/open_mail_app_plus.dart';
import 'package:pintarr/before/before.dart';
import 'package:pintarr/before/beforeNavi.dart';
import 'package:pintarr/service/fire/auth.dart';
import 'package:pintarr/widget/alert.dart';
import 'package:pintarr/widget/button.dart';
import 'package:pintarr/widget/responsive.dart';
import 'package:pintarr/widget/title.dart';
import 'package:provider/provider.dart';

class Verify extends StatelessWidget {
  final String? email;
  const Verify({Key? key, this.email}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);

    Future<String?> getEmail() async {
      return await auth.email;
    }

    out() {
      auth.signOut();
    }

    final page = Provider.of<BeforeNavi>(context);

    return Before(
      child: PageTemp(
        title: email != null ? 'Reset Password' : 'Verify Email',
        onBack: email == null
            ? null
            : () {
                page.updatePage(BeforePages.signIn);
              },
        card: false,
        sub: email != null
            ? null
            : (Responsive.isMobile(context)
                  ? IconButton(
                      onPressed: out,
                      icon: const Icon(Icons.logout, color: Colors.red),
                    )
                  : PageButt('Logout', onTap: out)),
        children: [
          Container(
            width: double.infinity,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    'Please ${email != null ? 'check' : 'verify'} your email${email != null ? ' to reset your password' : ''}.',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 5),
                if (email == null)
                  const Text(
                    'We have send the email to ',
                    style: TextStyle(fontSize: 16),
                  ),
                if (email != null)
                  const Text(
                    'We have send the intruction on how to reset your password to ',
                    style: TextStyle(fontSize: 16),
                  ),
                const SizedBox(height: 15),
                if (email != null)
                  Text(
                    email!,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                // ElevatedButton(onPressed: (){}, child: Text('Sign in')),
                if (email == null)
                  FutureBuilder<String?>(
                    future: getEmail(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container();
                      }
                      String? _email = snapshot.data;
                      return Text(
                        '$_email',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                const SizedBox(height: 20),

                // if ios,android
                if (Platform.isIOS || Platform.isAndroid)
                  // Button(
                  //   press: () async {
                  //     var result = await OpenMailApp.openMailApp();
                  //     if (!result.didOpen && !result.canOpen) {
                  //       return Alert.box(context, 'Failed',
                  //           const Text('No mail apps installed.'), <Widget>[
                  //         Alert.ok(context, () {
                  //           Navigator.of(context).pop();
                  //         }, 'Ok')
                  //       ]);
                  //     } else if (!result.didOpen && result.canOpen) {
                  //       showDialog(
                  //         context: context,
                  //         builder: (_) {
                  //           return MailAppPickerDialog(
                  //             mailApps: result.options,
                  //           );
                  //         },
                  //       );
                  //     }
                  //   },
                  //   text: email != null ? 'Check' : 'Verify',
                  // ),
                  Button(
                    press: () async {
                      // Use the new package
                      var result = await OpenMailAppPlus.openMailApp();
                      if (!result.didOpen && !result.canOpen) {
                        // If no mail apps are found
                        return Alert.box(
                          context,
                          'Failed',
                          const Text('No mail apps installed.'),
                          <Widget>[
                            Alert.ok(context, () {
                              Navigator.of(context).pop();
                            }, 'Ok'),
                          ],
                        );
                      } else if (!result.didOpen && result.canOpen) {
                        // If multiple mail apps are found, show the picker dialog
                        showDialog(
                          context: context,
                          builder: (_) {
                            return MailAppPickerDialog(
                              mailApps: result.options,
                            );
                          },
                        );
                      }
                    },
                    text: email != null ? 'Check' : 'Verify',
                  ),
                const SizedBox(height: 20),

                Text(
                  'Did not receive ${email != null ? 'password reset' : 'verification'} email?',
                ),
                TextButton(
                  onPressed: email != null
                      ? () {
                          auth.reset(email);
                        }
                      : () {
                          auth.verify();
                        },
                  child: const Text('Resend'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
