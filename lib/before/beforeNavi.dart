import 'package:flutter/material.dart';
import 'package:pintarr/sign/signInPage.dart';
import 'package:pintarr/sign/verify.dart';
import 'package:provider/provider.dart';

class BeforePage extends StatelessWidget {
  const BeforePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final page = Provider.of<BeforeNavi>(context);
    return page.page == BeforePages.signIn
        ? SignInPage()
        : Verify(
            email: page.email!,
          );
  }
}

class BeforeNavi extends ChangeNotifier {
  BeforePages page = BeforePages.signIn;
  String? email;
  // List<Client> client = [];

  void updatePage(BeforePages newPage, {String? mail}) {
    page = newPage;
    email = mail;
    notifyListeners();
  }
}

enum BeforePages {
  signIn,
  forget,
}
