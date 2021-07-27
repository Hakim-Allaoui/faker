import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:faker/utils/ads_helper.dart';
import 'package:faker/utils/strings.dart';
import 'package:faker/utils/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart'
    show SystemChrome, SystemUiOverlayStyle, rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart';
import 'package:intl/intl.dart' as intl;
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Tools {
  static double height = 781.0909090909091;
  static double width = 392.72727272727275;
  static AndroidDeviceInfo androidInfo;
  static RemoteConfig remoteConfig;
  static FirebaseMessaging firebaseMessaging;

  static initAppSettings() async {
    await Firebase.initializeApp();
    await initAppInfo();
    await getDeviceInfo();
    await Ads.init();
    await initFireMessaging();
    await copyFiles();
    await getProFeatures();
    cleanStatusBar();

    logger.i("""
    height      : $height
    width       : $width
    packageName : ${packageInfo.packageName}
    appName     : ${packageInfo.appName}
    buildNumber : ${packageInfo.buildNumber}
    version     : ${packageInfo.version}""");
  }

  static cleanStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ));
  }

  static PackageInfo packageInfo = PackageInfo(
    appName: ' ',
    packageName: ' ',
    version: ' ',
    buildNumber: ' ',
  );

  static Future<void> initAppInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    packageInfo = info;
  }

  static Future<void> getDeviceInfo() async {
    androidInfo = await DeviceInfoPlugin().androidInfo;
    var release = androidInfo.version.release;
    var sdkInt = androidInfo.version.sdkInt;
    var manufacturer = androidInfo.manufacturer;
    var model = androidInfo.model;
    Tools.logger.i("""
Android       : $release
SDK           : $sdkInt
manufacturer  : $manufacturer
model         : $model""");
  }

  static Future<void> initializeFlutterFire() async {
    await Firebase.initializeApp();
  }

  static void getDeviceDimensions(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    print('===> height : $height \n===> width  : $width');
  }

  static var logger = Logger(
    printer: PrettyPrinter(methodCount: 1, colors: false, prefix: true),
  );

  static launchURL(String url) async {
    /*if (await canLaunch(url)) {
      await launch(url);
      Tools.logger.wtf('==> lunching url : $url');
    } else {
      Tools.logger.e('Could not launch $url');
    }*/
    try {
      await launch(url);
    } catch (e) {
      Tools.logger.e('Could not launch $url, error: $e');
    }
  }

  static Future<File> selectPic(BuildContext context) async {
    final picker = ImagePicker();
    File _image;

    final imageSource = await showModalBottomSheet<ImageSource>(
        context: context,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15.0),
                topLeft: Radius.circular(15.0))),
        builder: (BuildContext ctx) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 4.0,
                      width: 50.0,
                      decoration: BoxDecoration(
                          color: Palette.greyLight,
                          borderRadius: BorderRadius.circular(100.0)),
                    ),
                  ),
                ),
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: Palette.greyLight,
                        borderRadius: BorderRadius.circular(100.0)),
                    child: new Icon(
                      Icons.image,
                      color: Palette.greyDark,
                    ),
                  ),
                  title: new Text(
                    'gallery'.tr().replaceAll("\\n", "\n"),
                    style: MyTextStyles.titleBold.apply(
                      color: Palette.greyDark,
                    ),
                  ),
                  onTap: () => Navigator.pop(context, ImageSource.gallery),
                ),
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: Palette.greyLight,
                        borderRadius: BorderRadius.circular(100.0)),
                    child: new Icon(
                      Icons.camera_alt,
                      color: Palette.greyDark,
                    ),
                  ),
                  title: new Text(
                    'camera'.tr().replaceAll("\\n", "\n"),
                    style: MyTextStyles.titleBold.apply(
                      color: Palette.greyDark,
                    ),
                  ),
                  onTap: () => Navigator.pop(context, ImageSource.camera),
                ),
              ],
            ),
          );
        });
    File newPic;
    if (imageSource != null) {
      final file = await picker.getImage(source: imageSource);
      if (file != null) {
        _image = File(file.path);

        final newPath =
            '${(await getApplicationDocumentsDirectory()).path}/${_image.path.split('/').last}';
        if (!File(newPath).existsSync()) {
          newPic = await _image.copy(newPath);
          await _image.delete();
        }
      }
    }
    return newPic;
  }

  static Future<File> getImageFileFromAssets(String path) async {
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/${path.split('/').last}');
    if (!file.existsSync()) {
      final byteData = await rootBundle.load('$path');
      await file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    }
    return file;
  }

  static Future<void> copyFiles() async {
    final files = [
      'assets/images/blank.png',
      'assets/images/profile.png',
      'assets/images/no_image.png'
    ];

    for (var item in files) {
      final file = File(
          '${(await getApplicationDocumentsDirectory()).path}/${item.split('/').last}');

      if (!file.existsSync()) {
        final byteData = await rootBundle.load(item);
        await file.writeAsBytes(byteData.buffer
            .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
      }
    }
  }

  static File getLocalImage(String path) {
    File image = path != null
        ? File(path).existsSync()
            ? File(path)
            : File(
                '/data/user/0/com.prank.fakepost.faker/app_flutter/no_image.png')
        : File('/data/user/0/com.prank.fakepost.faker/app_flutter/profile.png');
    return image;
  }

  static File getCoverLocalImage(String path) {
    File image = path != null
        ? File(path).existsSync()
            ? File(path)
            : File(
                '/data/user/0/com.prank.fakepost.faker/app_flutter/no_image.png')
        : File('/data/user/0/com.prank.fakepost.faker/app_flutter/blank.png');
    return image;
  }

  static Future<String> fetchRemoteConfig(String key) async {
    try {
      remoteConfig = await RemoteConfig.instance;
      await remoteConfig.fetch(expiration: const Duration(seconds: 0));
      await remoteConfig.activateFetched();
      String body = remoteConfig.getString(key);
      // logger.i('fetched config: $body');
      return body;
    } catch (e) {
      logger.e(e.toString());
      return '';
    }
  }

  static getProFeatures() async {
    final proFeatures = await fetchRemoteConfig('pro_features');

    logger.i('Pro features: $proFeatures');

    var str = proFeatures;

    Strings.proText = json.decode(str ?? '').cast<String>();
  }

  static checkAppVersion(BuildContext context) async {
    try {
      String newVersion = await fetchRemoteConfig('latest_version');

      double currentVersion =
          double.parse(newVersion.trim().replaceAll(".", ""));
      double installedVersion =
          double.parse(packageInfo.version.trim().replaceAll(".", ""));

      logger.i(
          'Current version: $currentVersion \nInstalled version: $installedVersion');

      if (installedVersion < currentVersion) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'update_available'.tr().replaceAll("\\n", "\n"),
              style: MyTextStyles.titleBold,
            ),
            content: new Text(
              'update_message'.tr(args: [newVersion]),
              style: MyTextStyles.title,
            ),
            actions: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                        borderRadius: new BorderRadius.circular(100.0),
                        color: Palette.greyDarken),
                    child: FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'later'.tr().replaceAll("\\n", "\n"),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: new BorderRadius.circular(100.0),
                      gradient: RadialGradient(
                        colors: Palette.gradientColors2,
                        center: Alignment.bottomLeft,
                        radius: 2.0,
                      ),
                    ),
                    child: FlatButton(
                      onPressed: () {
                        var url =
                            'https://play.google.com/store/apps/details?id=' +
                                Strings.packageName;
                        Tools.launchURL(url);
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'update'.tr().replaceAll("\\n", "\n"),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }
    } catch (e) {
      Tools.logger.wtf(e.toString());
    }
  }

  static showProDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Scaffold(
        body: Container(
          height: Tools.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Palette.facebookBlue,
                Palette.rose,
                Palette.rose,
                Palette.move,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: SizedBox(),
                      onPressed: null,
                    ),
                    Expanded(
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: Palette.white.withOpacity(0.5),
                        size: 30.0,
                      ),
                    ),
                    IconButton(
                      icon: Container(
                        padding: EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                            color: Palette.white.withOpacity(0.3),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 3.0,
                              )
                            ]),
                        child: Icon(
                          Icons.close,
                          color: Palette.greyLight,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        // Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              Text(
                'Unlock Premium Features 🎉',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Palette.white,
                    shadows: [
                      Shadow(
                        color: Palette.black,
                        blurRadius: 8.0,
                      )
                    ]),
              ),
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: Tools.width * 0.20),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(100.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black38,
                                    blurRadius: 5.0,
                                  )
                                ]),
                            child: Image.asset(
                              'assets/images/faker_pro.png',
                              width: Tools.width * 0.3,
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            'Faker Pro: Unlimited Posts, Comments and Profiles Maker',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 10.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: Strings.proText.map((e) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '$e',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    /*Text(
                                  'Only 5.56\$',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25.0,
                                    color: Colors.green,
                                  ),
                                ),*/
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Tools.launchURL(
                              'https://play.google.com/store/apps/details?id=com.prank.fakepost.fakerpro');
                        },
                        child: Image.asset(
                          'assets/images/google-play-badge.png',
                          width: Tools.width * 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static bool isDirectionRTL(BuildContext context) {
    return intl.Bidi.isRtlLanguage(
        Localizations.localeOf(context).languageCode);
  }

  static initFireMessaging() async {
    firebaseMessaging = FirebaseMessaging();
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        Tools.logger.wtf("onMessage: $message");
        if (message['data']['cpa_offer'] != null &&
            message['data']['cpa_offer'] != '') {
          try {
            // Tools.showCpaDialog(context, message);
          } catch (e) {
            Tools.logger.e("error: $e");
          }
        } else
          // Tools.showItemDialog(context, message);
          Tools.logger.wtf("Somthing");
      },
      onResume: (Map<String, dynamic> message) async {
        Tools.logger.wtf("onResume: $message");
        if (message['data']['cpa_offer'] != null &&
            message['data']['cpa_offer'] != '') {
          try {
            // Tools.showCpaDialog(context, message);
          } catch (e) {
            Tools.logger.e("error: $e");
          }
        } else
          // Tools.showItemDialog(context, message);
          Tools.logger.wtf("onResume: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        Tools.logger.wtf("From Tools================> onLaunch: $message");
//        MyNavigator.goNotifFetch(context: context, imageUrl: message['data']['imageUrl']);
        if (message['data']['cpa_offer'] != null &&
            message['data']['cpa_offer'] != '') {
          try {
            // Tools.showCpaDialog(context, message);
          } catch (e) {
            Tools.logger.e("error: $e");
          }
        } else
          // Tools.showItemDialog(context, message);
          Tools.logger.wtf("Somthing");
      },
      onBackgroundMessage: myBackgroundMessageHandler,
    );
    String token = await firebaseMessaging.getToken();
    Tools.logger.i('Messaging Token : $token');
  }
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  Tools.logger.wtf(
      '============================= catched handler ${message['data']['imageUrl']}');
  if (message.containsKey('data')) {
// Handle data message
    final dynamic data = message['data'];
    Tools.logger
        .wtf('==================> MessageHolder (data) ' + data.toString());
  }

  if (message.containsKey('notification')) {
// Handle notification message
    final dynamic notification = message['notification'];
    Tools.logger.wtf('==================> MessageHolder (notification) ' +
        notification.toString());
  }
// Or do other work.


  return await Future.value(message);
}
