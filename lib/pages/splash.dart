import 'package:faker/utils/theme.dart';
import 'package:faker/utils/tools.dart';
import 'package:flutter/material.dart';
import 'package:faker/utils/navigator.dart';
import 'package:easy_localization/easy_localization.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  Future<void> initThenGoHomeScreen() async {
    Future.wait([
      Future.delayed(Duration(seconds: 3), () {
        print("===( delayed Future )================> : Just delayed");
      })
    ]).then((value) {
      HKNavigator.goAuth(context);
      // HKNavigator.goAuth(context);
      // HKNavigator.goHome(context);
    });
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    controller.repeat(reverse: true);
    // initThenGoHomeScreen();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Tools.getDeviceDimensions(context);
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Palette.scaffold,
        ),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: SizedBox(),
            ),
            Expanded(
              flex: 4,
              child: Container(
                child: Center(
                  child: ScaleTransition(
                    scale: Tween(begin: 1.0, end: 1.1).animate(CurvedAnimation(
                        parent: controller, curve: Curves.ease)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image.asset(
                        'assets/icon.png',
                        width: Tools.width / 4,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text('initializing'.tr().replaceAll("\\n", "\n"), style: MyTextStyles.bigTitle),
            ),
          ],
        ),
      ),
    );
  }
}
