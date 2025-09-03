import 'package:firebase_auth/firebase_auth.dart';
import 'package:firedart/auth/exceptions.dart';
import 'package:flutter/material.dart';
import 'package:pintarr/before/beforeNavi.dart';
import 'package:pintarr/service/fire/auth.dart';
import 'package:pintarr/service/fire/database.dart';
import 'package:pintarr/service/load.dart';
import 'package:pintarr/service/stream/agentStream.dart';
import 'package:pintarr/widget/alert.dart';
import 'package:pintarr/widget/button.dart';
import 'package:pintarr/widget/textBox.dart';
import 'package:pintarr/widget/title.dart';
import 'package:provider/provider.dart';

enum SignState {
  signIn,
  signUp,
  forget,
}

class SignInForm extends StatefulWidget {
  const SignInForm({Key? key}) : super(key: key);

  // SignInForm(this.state);
  // final SignState state;
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = '';
  String _pass = '';
  String _name = '';
  String _com = '';

  SignState state = SignState.signIn;

  bool _loading = false;

  title() {
    if (state == SignState.signIn) return 'Sign In';
    if (state == SignState.signUp) return 'Sign Up';
    if (state == SignState.forget) return 'Forget Password';
  }

  text() {
    if (state == SignState.signIn) return 'Sign In';
    if (state == SignState.signUp) return 'Sign Up';
    if (state == SignState.forget) return 'Confirm';
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);

    final auth = Provider.of<Auth>(context);
    final page = Provider.of<BeforeNavi>(context);
    // final agents = Provider.of<List<Agent>>(context);
    // final Navi navi = Provider.of<Navi>(context);
    final win = Provider.of<bool>(context);
    // final AgentStream? stream = win ? Provider.of<AgentStream>(context) : null;
    err(e) {
      var message = 'An error occurred, please check your credentials!';
      // print(message);
      if (e.message != null) {
        message = e.message;
      }
      return Alert.box(context, 'Error', Text(message), <Widget>[
        Alert.ok(context, () {
          Navigator.of(context).pop();
        }, 'Try Again')
      ]);
    }

    final load = Provider.of<Load>(context);

    submit() async {
      node.unfocus();
      bool valid = _formKey.currentState!.validate();

      if (valid) {
        load.updateLoad(true);
        _formKey.currentState!.save();

        try {
          if (state == SignState.signIn) {
            await auth.signInWithEmailAndPassword(_email, _pass);
            // navi.updatePage(Pages.profile);
          }

          if (state == SignState.signUp) {
            if (_pass != _com) {
              return;
            }
            final database = Provider.of<Database>(context, listen: false);
            // List<Agent> agents = await database.getAgents();

            // List<String> agentName = [];
            // for (var i in agents) {
            //   agentName.add(i.username.toLowerCase());
            // }

            // if (agentName.contains(_name.toLowerCase())) {
            //   return err(
            //       'Your username has been used. Please try another username.');
            // }

            await auth.createUserWithEmailAndPassword(
                _name, _email, _pass, database);
            // navi.updatePage(Pages.profile);
          }
          if (state == SignState.forget) {
            auth.reset(_email);
            page.updatePage(BeforePages.forget, mail: _email);
          }
          load.updateLoad(false);
        } on FirebaseAuthException catch (e) {
          load.updateLoad(false);
          // print('fire');
          return err(e);
        } on AuthException catch (e) {
          load.updateLoad(false);
          // print('auth');
          return err(e);
        } catch (e) {
          load.updateLoad(false);
          return err(e);
        }
      }
    }

    // final AgentStream stream = win ? Provider.of<AgentStream>(context) : null;
// asdzczxczxczxzxczxczxzxzx
    return PageTemp(
      card: false,
      title: title(),
      onBack: state == SignState.forget
          ? () {
              setState(() {
                state = SignState.signIn;
              });
            }
          : null,
      children: [
        Form(
          key: _formKey,
          child: Column(
            // mainAxisAlignment: ,
            // crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (state == SignState.forget)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    'Enter your email to reset your account\'s password.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              if (state == SignState.signUp)
                NameTextBox(
                  init: _name,
                  complete: () => node.nextFocus(),
                  enable: _loading == false,
                  onSaved: (v) {
                    _name = v;
                  },
                  text: 'Username',
                  validateText: 'Please enter your username.',
                ),
              EmailTextBox(
                init: _email,
                complete: () =>
                    state == SignState.forget ? submit() : node.nextFocus(),
                enable: _loading == false,
                onSaved: (v) {
                  _email = v;
                },
                text: 'Email',
                validateText: 'Please enter your email.',
              ),
              if (state == SignState.signUp || state == SignState.signIn)
                PasswordTextBox(
                  init: _pass,
                  complete: () =>
                      state == SignState.signIn ? submit() : node.nextFocus(),
                  text: 'Password',
                  validateText: 'Please enter your password. ',
                  enable: _loading == false,
                  onSaved: (value) {
                    _pass = value!;
                  },
                ),
              if (state == SignState.signUp)
                PasswordTextBox(
                  init: _com,
                  text: 'Confirm Password',
                  complete: () => submit(),
                  validateText: 'Please confirm your password. ',
                  enable: _loading == false,
                  onSaved: (value) {
                    _com = value!;
                  },
                ),
              if (state == SignState.signIn)
                TextButton(
                    onPressed: () {
                      setState(() {
                        state = SignState.forget;
                      });
                    },
                    child: Text('Forget Password ? ')),
              if (state == SignState.signIn) Text('Do not have an account?'),
              if (state == SignState.signIn)
                TextButton(
                    onPressed: () {
                      setState(() {
                        state = SignState.signUp;
                      });
                    },
                    child: Text('Sign Up')),
              if (state == SignState.signUp) Text('Have an account?'),
              if (state == SignState.signUp)
                TextButton(
                  onPressed: () {
                    setState(() {
                      state = SignState.signIn;
                    });
                  },
                  child: Text('Sign In'),
                ),
              Button(
                
                press: submit,
                text: text(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
