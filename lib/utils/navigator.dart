import 'package:flutter/material.dart';

class HKNavigator{
  static void goAuth(BuildContext context){
    Navigator.pushReplacementNamed(context, '/auth');
  }

  static void goHome(BuildContext context){
    Navigator.pushReplacementNamed(context, '/home');
  }

  static Future<void> goPost(BuildContext context,{VoidCallback onPop}) async {
    Navigator.pushNamed(context, '/post').then((value) => onPop != null ? onPop() : null);
  }


  static Future<void> goProfile(BuildContext context,{VoidCallback onPop}) async {
    Navigator.pushNamed(context, '/profile').then((value) => onPop != null ? onPop() : null);
  }

  static Future<void> goSavedPosts(BuildContext context, {VoidCallback onPop}) async {
    Navigator.pushNamed(context, '/savedPosts').then((value) => onPop != null ? onPop() : null);
  }

  static void goPrivacy(BuildContext context){
    Navigator.pushNamed(context, '/privacy');
  }

  static void goAbout(BuildContext context){
    Navigator.pushNamed(context, '/about');
  }

  static void goTranslate(BuildContext context){
    Navigator.pushNamed(context, '/translate');
  }

  static void goSettings(BuildContext context) {
    Navigator.pushNamed(context, '/settings');
  }

  static void goMoreApps(BuildContext context) {
    Navigator.pushNamed(context, '/more_apps');
  }

  static void goLanguage(BuildContext context){
    Navigator.pushNamed(context, '/language');
  }

}