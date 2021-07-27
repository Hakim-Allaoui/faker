import 'package:easy_localization/easy_localization.dart';
import 'package:faker/utils/strings.dart';
import 'package:faker/utils/theme.dart';
import 'package:faker/utils/tools.dart';
import 'package:faker/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguagePage extends StatefulWidget {
  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String currentLang;
  int langIndex = 0;

  List<String> languages = ['English', 'العربية' ,'Français', 'Español', 'Vietnamese', 'Português', 'Italian'];
  List<String> languageCodes = ['en', 'ar', 'fr', 'es', 'vi', 'pt', 'it',];

  void _handleRadioValueChange(int value) async {
    final SharedPreferences prefs = await _prefs;
    langIndex = value;
    currentLang = languageCodes[langIndex];
    prefs.setString("currentLang", currentLang);
    EasyLocalization.of(context).locale = Locale(currentLang);
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
                  'language'.tr().replaceAll("\\n", "\n"),
                  style: MyTextStyles.bigTitleBold.apply(color: Palette.black),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future: SharedPreferences.getInstance(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    currentLang = snapshot.data.getString('currentLang');

                    if (currentLang == null) {
                      currentLang = 'en';
                    }

                    return Column(
                        children: languages.map((lang) {
                      return Card(
                        child: ListTile(
                          title: Text(lang),
                          trailing: Radio(
                            value: languages.indexOf(lang),
                            groupValue: languageCodes.indexOf(currentLang),
                            onChanged: _handleRadioValueChange,
                          ),
                          onTap: () async {
                            _handleRadioValueChange(languages.indexOf(lang));
                          },
                        ),
                      );
                    }).toList());
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
                    Tools.launchURL('mailto:${Strings.contact_email}?subject=translate%20${Tools.packageInfo.appName.split(' ').join('%20')}');
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
                          style: MyTextStyles.titleBold.apply(color: Colors.white),
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
