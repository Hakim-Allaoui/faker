import 'package:faker/utils/strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:faker/utils/theme.dart';
import 'package:faker/utils/tools.dart';
import 'package:faker/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TranslatePage extends StatefulWidget {
  @override
  _TranslatePageState createState() => _TranslatePageState();
}

class _TranslatePageState extends State<TranslatePage> {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Palette.greyLight,
      body: Stack(
        children: <Widget>[
          Positioned(
            right: 20.0,
            bottom: 80.0,
            child: Opacity(
              child: SvgPicture.asset(
                'assets/icons/translate.svg',
                width: 300.0,
              ),
              opacity: 0.2,
            ),
          ),
          Column(
            children: <Widget>[
              CustomAppBar(
                scaffoldKey: scaffoldKey,
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
                  'help_translate'.tr().replaceAll("\\n", "\n"),
                  style: MyTextStyles.bigTitleBold.apply(color: Palette.black),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Markdown(
                  data: Strings.translateContribution,
                  onTapLink: (link) async {
                    Tools.launchURL(link);
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: new BorderRadius.circular(100.0),
                  color: Palette.move,
                  gradient: RadialGradient(
                    colors: Palette.gradientColors2,
                    center: Alignment.bottomLeft,
                    radius: 10.0,
                  ),
                ),
                child: FlatButton(
                  padding: EdgeInsets.all(10.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(100.0),
                  ),
                  onPressed: () {
                    // Tools.launchURL('mailto:${Strings.contact_email}?subject=translate%20${Tools.packageInfo.appName.split(' ').join('%20')}');
                    Tools.launchURL(
                        'https://docs.google.com/spreadsheets/d/1wJKFa4EpBaIMUYhRoIXG1hZleuS-dVcPywrlsoLu9QQ/edit?usp=sharing');
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: SvgPicture.asset(
                            'assets/icons/translate.svg',
                            width: 30.0,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'help_translate'.tr().replaceAll("\\n", "\n"),
                          style:
                              MyTextStyles.titleBold.apply(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
