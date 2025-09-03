import 'package:firebase_auth/firebase_auth.dart';
import 'package:firedart/auth/exceptions.dart';
import 'package:firedart/auth/user_gateway.dart' as use;
import 'package:firedart/firedart.dart' as fire;
import 'package:pintarr/model/agent.dart';
import 'package:pintarr/service/fire/database.dart';
import 'package:pintarr/service/realTime.dart';

class Users {
  Users({required this.uid});
  final String uid;
}

// abstract class Auth {
//   Stream<Users> get onAuthStateChanged;
//   // Future<Users> signInAnonymously();
//   Future<void> signInWithEmailAndPassword(String email, String password);
//   Future<void> createUserWithEmailAndPassword(
//       String name, String email, String password, Database database,AgentStream stream);

//   Future<void> signOut();
//   Future<void> verify();
//   Future<void> reset(email);
//   bool get isVerify;
//   String get email;
//   get current;
// }

class Auth {
  final bool win;
  Auth(this.win);
  // var FirebaseAuth.instance;
  // final FirebaseAuth.instance = win? fire.FirebaseAuth.instance:FirebaseAuth.instance;

  // init() async {
  //   // if (Platform.isWindows) {
  //   //   String apiKey = "AIzaSyCd_mWXX4R1X-kmJfATx2JABc1KEl5XcLY";
  //   //   fire.FirebaseAuth.initialize(apiKey, fire.VolatileStore());
  //   //   FirebaseAuth.instance = fire.FirebaseAuth.instance;
  //   // } else {
  //   //   print('non');
  //   //   FirebaseAuth.instance = FirebaseAuth.instance;
  //   // }
  // }

  Users? _userFromFirebase(User? user) {
    if (user == null) {
      return null;
    }
    return Users(
      uid: user.uid,
    );
  }

  Users? _userFromFiredart(bool sign) {
    if (!sign) {
      return null;
    }

    return Users(
      uid: fire.FirebaseAuth.instance.userId,
    );
  }

  Stream<Users?> get onAuthStateChanged {
    if (win) {
      return fire.FirebaseAuth.instance.signInState.map(_userFromFiredart);
    }
    return FirebaseAuth.instance.authStateChanges().map(_userFromFirebase);
  }

  Future<void> signOut() async {
    if (win) {
      fire.FirebaseAuth.instance.signOut();
    } else {
      await FirebaseAuth.instance.signOut();
    }
  }

  Future<void> delete() async {
    if (win) {
     
    } else {
      await FirebaseAuth.instance.currentUser!.delete();
    }
  }

  Future<void> verify() async {
    if (win) {
      fire.FirebaseAuth.instance.requestEmailVerification();
    } else {
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
    }
    // await FirebaseAuth.instance.currentUser.;
  }

  get current async {
    if (win) return await fire.FirebaseAuth.instance.getUser();
    return FirebaseAuth.instance.currentUser;
  }

  Future<void> reload() async {
    await FirebaseAuth.instance.currentUser?.reload();
  }

  Future<void> reset(email) async {
    if (win) {
      fire.FirebaseAuth.instance.resetPassword(email);
    } else {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    }
  }

  Future<use.User?> getUser() async {
    return await fire.FirebaseAuth.instance.getUser();
  }

  Future<bool> get isVerify async {
    if (win) {
      use.User? user = await getUser();
      return user?.emailVerified ?? false;
    }

    return FirebaseAuth.instance.currentUser?.emailVerified ?? false;
  }

  Future<String?> get email async {
    if (win) {
      use.User? user = await getUser();
      return user?.email;
    }
    return FirebaseAuth.instance.currentUser?.email;
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    print('sign');
    try {
      if (win) {
        await fire.FirebaseAuth.instance.signIn(email, password);
      } else {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
      }
    } on FirebaseAuthException catch (e) {
      print('fire');
      throw e;
    } on AuthException catch (e) {
      print('auth');
      throw e;
    } catch (e) {
      print('e');
      throw e;
    }
  }

  Future<void> createUserWithEmailAndPassword(
      String name, String email, String password, Database database) async {
    int t = await RealTime.intNow();
    try {
      if (win) {
        final authResult =
            await fire.FirebaseAuth.instance.signUp(email, password);
        Agent agent = Agent(
          id: authResult.id,
          username: name,
          access: false,
          admin: false,
          pintar: false,
          join: t,
        );
        await database.setAgent(agent);

        await verify();
      } else {
        final authResult = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        Agent agent = Agent(
          id: authResult.user!.uid,
          username: name,
          access: false,
          admin: false,
          join: t,
          pintar: false,
        );
        await database.setAgent(agent);
        await authResult.user?.sendEmailVerification();
      }
    } on FirebaseAuthException catch (e) {
      throw e;
    } on AuthException catch (e) {
      throw e;
    } catch (e) {
      throw (e);
    }
  }
}
