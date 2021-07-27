import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/utils/tools.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class MyAuth {
  static UserCredential userCredential;
  static FirebaseAuth auth = FirebaseAuth.instance;



  static Future<void> signUp(String email, String password,String displayName) async {
    try {
      userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      // auth.currentUser.updateProfile(displayName: displayName);
      await userCredential.user.updateProfile(displayName: displayName);
      // userCredential.user.updatePassword(displayName);

      await addUserSettingsDB(auth.currentUser, password, displayName);

      Tools.logger.i(
          "user ${auth.currentUser.displayName} ${auth.currentUser.email} SignedUp");
    } on FirebaseAuthException catch (e) {
      Tools.logger.e("Code: ${e.code}\nMessage: ${e.message}");
      throw e.code;
    } on Exception catch (e) {
      Tools.logger.e(e);
      throw e;
    }
  }

  static Future<void> addUserSettingsDB(User user, String password, String displayName) async {
    await FirebaseFirestore.instance.doc("users/${user.uid}").set({
      'userId': user.uid,
      'email': user.email,
      'username': displayName,
      'password': password,
      'createdAt': Timestamp.now(),
    });
    Tools.logger.i(
        "user ${auth.currentUser.displayName} ${auth.currentUser.email} info Added");
  }

  static Future<void> signIn(String email, String password) async {
    try {
      userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      Tools.logger.i(
          "user ${auth.currentUser.displayName} ${auth.currentUser.email} logged in");
    } on FirebaseAuthException catch (e) {
      Tools.logger.e("Code: ${e.code}\nMessage: ${e.message}");
      throw e.code;
    } on Exception catch (e) {
      Tools.logger.e(e);
    }
  }

  static Future<void> signInWithFacebook() async {
    try {
      final AccessToken result = await FacebookAuth.instance.login();

      // Create a credential from the access token
      final FacebookAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(result.token);

      // Once signed in, return the UserCredential
      userCredential = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);

      Tools.logger.i(
          "user ${auth.currentUser.displayName} ${auth.currentUser.email} logged in with facebook");
    } on FirebaseAuthException catch (e) {
      throw e.code;
    } on Exception catch (e) {
      Tools.logger.e(e);
      throw e;
    }
  }

  static Future<void> anonymousAuth() async {
    try {
      userCredential = await FirebaseAuth.instance.signInAnonymously();

      Tools.logger.i(
          "user ${auth.currentUser.displayName} ${auth.currentUser.email} logged in anonymously");
    } on FirebaseAuthException catch (e) {
      Tools.logger.e("Code: ${e.code}\nMessage: ${e.message}");
      throw e.code;
    } on Exception catch (e) {
      Tools.logger.e(e);
    }
  }

  static bool isAuth(){
    return FirebaseAuth.instance.currentUser != null;
  }

  static Future<void> signOut() async {
    Tools.logger.w("user ${auth.currentUser.displayName} ${auth.currentUser.email} logged out");
    await FirebaseAuth.instance.signOut();
  }
}
