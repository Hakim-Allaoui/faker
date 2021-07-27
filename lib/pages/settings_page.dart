import 'package:faker/utils/ads_helper.dart';
import 'package:faker/utils/navigator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:faker/utils/theme.dart';
import 'package:faker/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();
  Ads ads;

  @override
  void initState() {
    super.initState();
    ads = new Ads();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Palette.greyLight,
      body: Stack(
        children: <Widget>[
          Positioned(
            right: -100.0,
            bottom: -100.0,
            child: Opacity(
              child: SvgPicture.asset(
                'assets/icons/settings.svg',
                width: 400.0,
              ),
              opacity: 0.2,
            ),
          ),
          Column(
            children: <Widget>[
              CustomAppBar(
                scaffoldKey: scaffoldKey,
                bannerAd: ads.getBannerAd(),
                leading: IconButton(
                  icon: SvgPicture.asset(
                    'assets/icons/backarrow.svg',
                    color: Colors.black,
                    width: 15.0,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                title: Text(
                  'settings'.tr().replaceAll("\\n", "\n"),
                  style: MyTextStyles.bigTitleBold.apply(color: Palette.black),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Card(
                      child: ListTile(
                        title: Text('language'.tr()),
                        onTap: () {
                          HKNavigator.goLanguage(context);
                        },
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: Text('help_translate'.tr()),
                        onTap: () {
                          HKNavigator.goTranslate(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}