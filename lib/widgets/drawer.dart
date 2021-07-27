import 'package:faker/utils/auth.dart';
import 'package:faker/utils/navigator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:faker/utils/theme.dart';
import 'package:faker/utils/tools.dart';
import 'package:faker/widgets/rate_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HKDrawer extends StatelessWidget {
  final VoidCallback showInterCallBack;
  final GlobalKey<ScaffoldState> scaffoldKey;

  HKDrawer({this.showInterCallBack, this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.width * 0.6,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Positioned(
                    top: -MediaQuery.of(context).size.width * 0.9,
                    child: Container(
                      height: MediaQuery.of(context).size.width * 1.5,
                      width: MediaQuery.of(context).size.width * 1.5,
                      decoration: BoxDecoration(
                        color: Palette.facebookBlue,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Image.asset(
                      'assets/icon.png',
                      width: 100.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 30.0, top: 10.0),
                      child: Text(
                        Tools.packageInfo.appName,
                        style:
                            MyTextStyles.titleBold.apply(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  Palette.move.withOpacity(0.5),
                                  Palette.rose,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Palette.rose,
                                  blurRadius: 2.0,
                                )
                              ],
                            ),
                            child: IconButton(
                              icon: SvgPicture.asset(
                                'assets/icons/pro_badge.svg',
                                width: 30.0,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                Tools.showProDialog(context);
                              },
                            ),
                          ),
                          Text(
                            'Go Pro',
                            style: TextStyle(
                              fontSize: 10.0,
                              fontWeight: FontWeight.bold,
                              color: Palette.move,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            MyAuth.isAuth()
                ? Padding(
                    padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 8.0),
                    child: FlatButton(
                      padding: EdgeInsets.all(10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(100.0),
                      ),
                      onPressed: () {},
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Palette.greyLight),
                            child: Icon(
                              Icons.person,
                              color: Palette.greyDark,
                              size: 25,
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: Tools.width * .5,
                                child: Text(
                                  'user_caption'.tr(args: [
                                    MyAuth.auth.currentUser.displayName ??
                                        'loading...'
                                  ]),
                                  // 'Username',
                                  style: MyTextStyles.titleBold,
                                  softWrap: true,
                                ),
                              ),
                              Text(
                                '${MyAuth.auth.currentUser.email ?? '-'}',
                                // 'exemple@gmail.com',
                                style: MyTextStyles.subTitle,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                : SizedBox(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.only(left: 8.0, bottom: 8.0, right: 8.0),
                      child: FlatButton(
                        padding: EdgeInsets.all(10.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(100.0),
                        ),
                        onPressed: () {
                          HKNavigator.goHome(context);
                        },
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 10.0,
                            ),
                            SvgPicture.asset(
                              'assets/icons/home.svg',
                              width: 30.0,
                            ),
                            SizedBox(
                              width: 30.0,
                            ),
                            Text(
                              'home'.tr().replaceAll("\\n", "\n"),
                              style: MyTextStyles.titleBold,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, bottom: 8.0, right: 8.0),
                      child: FlatButton(
                        padding: EdgeInsets.all(10.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(100.0),
                        ),
                        onPressed: () async {
                          /*var url =
                              'https://play.google.com/store/apps/details?id=' +
                                  Strings.packageName;
                          Tools.launchURL(url);*/
                          Navigator.pop(context);
                          int count = 0;
                          await showDialog(
                              context: context,
                              builder: (_) => RatingDialog()).then((value) {
                            count = value ?? 0;
                            if (value == null || value <= 3) {
                              if (showInterCallBack != null)
                                this.showInterCallBack();
                              return;
                            }
                          });
                          String text = '';
                          if (count <= 2)
                            text =
                                'Your rating was $count ☹ alright, thank you.';
                          if (count == 3) text = 'Thanks for your rating 🙂';
                          if (count >= 4) text = 'Thanks for your rating 😀';
                          scaffoldKey.currentState.showSnackBar(
                            new SnackBar(
                              content: Text(text),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 10.0,
                            ),
                            SvgPicture.asset(
                              'assets/icons/rate.svg',
                              width: 30.0,
                            ),
                            SizedBox(
                              width: 30.0,
                            ),
                            Text(
                              'rate'.tr().replaceAll("\\n", "\n"),
                              style: MyTextStyles.titleBold,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, bottom: 8.0, right: 8.0),
                      child: FlatButton(
                        padding: EdgeInsets.all(10.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(100.0),
                        ),
                        onPressed: () {
                          /*var url;
                          if (Strings.storeId != "") {
                            url = 'https://play.google.com/store/apps/dev?id=' +
                                Strings.storeId;
                          } else {
                            url =
                                'https://play.google.com/store/apps/developer?id=' +
                                    Strings.storeName.split(' ').join('+');
                          }
                          Tools.launchURL(url);*/
                          Navigator.pop(context);
                          HKNavigator.goMoreApps(context);
                        },
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 10.0,
                            ),
                            SvgPicture.asset(
                              'assets/icons/more.svg',
                              width: 30.0,
                            ),
                            SizedBox(
                              width: 30.0,
                            ),
                            Text(
                              'more_apps'.tr().replaceAll("\\n", "\n"),
                              style: MyTextStyles.titleBold,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, bottom: 8.0, right: 8.0),
                      child: FlatButton(
                        padding: EdgeInsets.all(10.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(100.0),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          HKNavigator.goPrivacy(context);
                        },
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 10.0,
                            ),
                            SvgPicture.asset(
                              'assets/icons/privacy_policy.svg',
                              width: 30.0,
                            ),
                            SizedBox(
                              width: 30.0,
                            ),
                            Text(
                              'privacy_policy'.tr().replaceAll("\\n", "\n"),
                              style: MyTextStyles.titleBold,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, bottom: 8.0, right: 8.0),
                      child: FlatButton(
                        padding: EdgeInsets.all(10.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(100.0),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          HKNavigator.goAbout(context);
                        },
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 10.0,
                            ),
                            SvgPicture.asset(
                              'assets/icons/about.svg',
                              width: 30.0,
                            ),
                            SizedBox(
                              width: 30.0,
                            ),
                            Text(
                              'about'.tr().replaceAll("\\n", "\n"),
                              style: MyTextStyles.titleBold,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 8.0, bottom: 8.0, right: 8.0),
                      child: FlatButton(
                        padding: EdgeInsets.all(10.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(100.0),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          HKNavigator.goSettings(context);
                        },
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 10.0,
                            ),
                            SvgPicture.asset(
                              'assets/icons/settings.svg',
                              width: 30.0,
                            ),
                            SizedBox(
                              width: 30.0,
                            ),
                            Text(
                              'settings'.tr().replaceAll("\\n", "\n"),
                              style: MyTextStyles.titleBold,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 8.0, bottom: 8.0, right: 8.0),
                      child: FlatButton(
                        padding: EdgeInsets.all(10.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(100.0),
                        ),
                        onPressed: () async {
                          if (MyAuth.isAuth())
                            await MyAuth.signOut();
                          else
                            HKNavigator.goAuth(context);
                        },
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 10.0,
                            ),
                            SvgPicture.asset(
                              'assets/icons/logout.svg',
                              width: 30.0,
                            ),
                            SizedBox(
                              width: 30.0,
                            ),
                            Text(
                              MyAuth.isAuth()
                                  ? 'logout'.tr().replaceAll("\\n", "\n")
: 'login'.tr().replaceAll("\\n", "\n"),
                              style: MyTextStyles.titleBold,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Version ${Tools.packageInfo.version}(${Tools.packageInfo.buildNumber})',
                style: MyTextStyles.subTitle.apply(fontSizeFactor: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
