import 'package:easy_localization_loader/easy_localization_loader.dart';
import 'package:faker/pages/about_page.dart';
import 'package:faker/pages/auth_page.dart';
import 'package:faker/pages/language_page.dart';
import 'package:faker/pages/home_page.dart';
import 'package:faker/pages/profile_page.dart';
import 'package:faker/pages/more_apps_page.dart';
import 'package:faker/pages/post_page.dart';
import 'package:faker/pages/privacy_policy_page.dart';
import 'package:faker/pages/saved_posts_page.dart';
import 'package:faker/pages/settings_page.dart';
import 'package:faker/pages/splash.dart';
import 'package:faker/pages/translate_page.dart';
import 'package:faker/providers/firestore_helper.dart';
import 'package:faker/utils/tools.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:easy_localization/easy_localization.dart';

var routes = <String, WidgetBuilder>{
  '/auth': (BuildContext context) => AuthPage(),
  '/home': (BuildContext context) => HomePage(),
  '/post': (BuildContext context) => PostPage(),
  '/profile': (BuildContext context) => ProfilePage(),
  '/savedPosts': (BuildContext context) => SavedPostsPage(),
  '/about': (BuildContext context) => AboutPage(),
  '/privacy': (BuildContext context) => PrivacyPage(),
  '/translate': (BuildContext context) => TranslatePage(),
  '/settings': (BuildContext context) => SettingsPage(),
  '/more_apps': (BuildContext context) => MoreApps(),
  '/language': (BuildContext context) => LanguagePage(),
};

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Tools.initAppSettings();
  runApp(
    EasyLocalization(
      supportedLocales: [
        Locale('en'),
        Locale('ar'),
        Locale('fr'),
        Locale('es'),
        Locale('vi'),
        Locale('pt'),
        Locale('it'),
      ],
      path: 'assets/translations/langs.csv',
      fallbackLocale: Locale('en'),
      assetLoader: CsvAssetLoader(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Faker',
      navigatorObservers: <NavigatorObserver>[observer],
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      localizationsDelegates: context.localizationDelegates,
      theme: ThemeData(
          primarySwatch: Colors.indigo,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Montserrat'
        // fontFamily: 'San Fransisco'
      ),
      routes: routes,
      home: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, app) {
          if (app.hasError) return HomePage();
          if (app.connectionState == ConnectionState.done)
            return StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, auth) {
                  if (auth.connectionState == ConnectionState.waiting)
                    return SplashPage();

                  if (auth.data != null) {
                    return FutureBuilder(
                      future: Future.wait([Posts.getUserPosts(), Profiles.getUserProfiles()]),
                      builder: (context, snapshot) {
                        if(snapshot.connectionState == ConnectionState.waiting) return SplashPage();
                        return HomePage();
                      }
                    );
                  } else {
                    return AuthPage();
                  }
                });

          return SplashPage();
        },
      ),
    );
  }
}
