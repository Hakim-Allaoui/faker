import 'package:faker/utils/ads_helper.dart';
import 'package:faker/utils/strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:faker/utils/theme.dart';
import 'package:faker/utils/tools.dart';
import 'package:faker/widgets/appbar.dart';
import 'package:faker/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();

  Ads ads;

  @override
  void initState() {
    super.initState();
    ads = new Ads();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: HKDrawer(scaffoldKey: scaffoldKey,showInterCallBack: () => ads.showInter(),),
      backgroundColor: Palette.greyLight,
      body: Stack(
        children: <Widget>[
          Positioned(
            right: -100.0,
            bottom: -100.0,
            child: Opacity(
              child: SvgPicture.asset(
                'assets/icons/about.svg',
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
                  'about'.tr().replaceAll("\\n", "\n"),
                  style: MyTextStyles.bigTitleBold.apply(color: Palette.black),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Markdown(
                  data: Strings.aboutText,
                  onTapLink: (link) async {
                    Tools.launchURL(link);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
