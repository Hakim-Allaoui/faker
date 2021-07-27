import 'package:faker/pages/page_page.dart';
import 'package:faker/pages/saved_posts_page.dart';
import 'package:faker/pages/saved_profiles.dart';
import 'package:faker/utils/ads_helper.dart';
import 'package:faker/utils/auth.dart';
import 'package:faker/utils/strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:faker/utils/theme.dart';
import 'package:faker/utils/tools.dart';
import 'package:faker/widgets/appbar.dart';
import 'package:faker/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:faker/utils/navigator.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:faker/pages/profile_page.dart';

class TabTitle {
  String title;
  Widget content;
  int id;

  TabTitle(this.title, this.content, this.id);
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();

  Ads ads;
  TabController mTabController;
  PageController mPageController = PageController(initialPage: 0);
  List<TabTitle> tabList;
  var currentPage = 0;

  var isPageCanChanged = true;

  initTabData() {
    tabList = [
      new TabTitle(
          'disclaimer'.tr().replaceAll("\\n", "\n"),
          Markdown(
            data: Strings.disclaimer,
            styleSheet: MarkdownStyleSheet(
              p: MyTextStyles.subTitle,
            ),
            onTapLink: (link) async {
              Tools.launchURL(link);
            },
          ),
          0),
      new TabTitle(
          'how_to_use'.tr().replaceAll("\\n", "\n"),
          Markdown(
            data: Strings.howToUse,
            styleSheet: MarkdownStyleSheet(
              p: MyTextStyles.subTitle,
            ),
            onTapLink: (link) async {
              Tools.launchURL(link);
            },
          ),
          1),
    ];
  }

  onPageChange(int index, {PageController p, TabController t}) async {
    if (p != null) {
      //determine which switch is
      isPageCanChanged = false;
      await mPageController.animateToPage(index,
          duration: Duration(milliseconds: 500),
          curve: Curves
              .ease); //Wait for pageview to switch, then release pageivew listener
      isPageCanChanged = true;
    } else {
      mTabController.animateTo(index); //Switch Tabbar
    }
  }

  @override
  void initState() {
    super.initState();
    ads = new Ads();
    ads.loadInter();
    Tools.checkAppVersion(context);

    initTabData();
    mTabController = TabController(
      length: tabList.length,
      vsync: this,
    );
    mTabController.addListener(() {
      //TabBar listener
      if (mTabController.indexIsChanging) {
        onPageChange(mTabController.index, p: mPageController);
      }
    });

    Future.delayed(Duration(seconds: 1), () {
      Tools.showProDialog(context);
    });
  }

  @override
  void dispose() {
    // ads.disposeInter();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: confirmExit,
      child: Scaffold(
        backgroundColor: Palette.greyLight,
        key: scaffoldKey,
        drawer: HKDrawer(
          scaffoldKey: scaffoldKey,
          showInterCallBack: () => ads.showInter(),
        ),
        body: Column(
          children: [
            CustomAppBar(
              scaffoldKey: scaffoldKey,
              showInterCallBack: ads.showInter,
              title: Text(
                'home'.tr().replaceAll("\\n", "\n"),
                style: MyTextStyles.bigTitleBold,
                textAlign: TextAlign.center,
              ),
            ),
            ads.getBannerAd(),
            Container(
              color: Palette.greyLight,
              height: 38.0,
              child: TabBar(
                isScrollable: true,
                //Can you scroll
                controller: mTabController,
                labelColor: Palette.facebookBlue,
                indicatorColor: Palette.facebookBlue,
                unselectedLabelColor: Palette.greyDark,
                labelStyle:
                    TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                unselectedLabelStyle: TextStyle(fontSize: 16.0),
                tabs: tabList.map((item) {
                  return Tab(
                    text: item.title,
                  );
                }).toList(),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    color: Palette.greyLight,
                  ),
                  PageView.builder(
                    itemCount: tabList.length,
                    onPageChanged: (index) {
                      if (isPageCanChanged) {
                        // because the pageview switch will call back this method, it will trigger the switch tabbar operation, so define a flag, control pageview callback
                        onPageChange(index);
                      }
                    },
                    controller: mPageController,
                    itemBuilder: (BuildContext context, int index) {
                      return tabList[index].content;
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: new BorderRadius.circular(100.0),
                            color: Palette.facebookBlue,
                          ),
                          child: FlatButton(
                              padding: EdgeInsets.all(10.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100.0),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'create_post'
                                          .tr()
                                          .replaceAll("\\n", "\n"),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(4.0),
                                    decoration:
                                        BoxDecoration(shape: BoxShape.circle),
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 20.0,
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: () {
                                HKNavigator.goPost(context, onPop: null);
                                ads.showInter();
                              }),
                        ),
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100.0),
                            color: Palette.facebookBlue,
                          ),
                          child: FlatButton(
                              padding: EdgeInsets.all(10.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(100.0),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'create_profile'
                                          .tr()
                                          .replaceAll("\\n", "\n"),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(4.0),
                                    decoration:
                                        BoxDecoration(shape: BoxShape.circle),
                                    child: Icon(
                                      Icons.person_add_alt_1,
                                      color: Colors.white,
                                      size: 20.0,
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProfilePage(
                                        // profileId: MyAuth.auth.currentUser?.uid,
                                        ),
                                    settings: RouteSettings(
                                      name: "profile",
                                    ),
                                  ),
                                );
                                ads.showInter();
                              }),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(top: 8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100.0),
                            color: Palette.facebookBlue,
                          ),
                          child: FlatButton(
                              padding: EdgeInsets.all(10.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(100.0),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'saved_posts'
                                          .tr()
                                          .replaceAll("\\n", "\n"),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(4.0),
                                    decoration:
                                        BoxDecoration(shape: BoxShape.circle),
                                    child: Icon(
                                      Icons.save,
                                      color: Colors.white,
                                      size: 20.0,
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SavedPostsPage(
                                      userId: MyAuth.auth.currentUser?.uid,
                                    ),
                                    settings: RouteSettings(
                                      name: "savedPosts",
                                    ),
                                  ),
                                );
                                ads.showInter();
                              }),
                        ),
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(top: 8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100.0),
                            color: Palette.facebookBlue,
                          ),
                          child: FlatButton(
                              padding: EdgeInsets.all(10.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(100.0),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'saved_profiles'
                                          .tr()
                                          .replaceAll("\\n", "\n"),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(4.0),
                                    decoration:
                                        BoxDecoration(shape: BoxShape.circle),
                                    child: Icon(
                                      Icons.save,
                                      color: Colors.white,
                                      size: 20.0,
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SavedProfiles(
                                      userId: MyAuth.auth.currentUser?.uid,
                                    ),
                                    settings: RouteSettings(
                                      name: "savedPosts",
                                    ),
                                  ),
                                );
                                ads.showInter();
                              }),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(top: 8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100.0),
                            color: Palette.facebookBlue,
                          ),
                          child: FlatButton(
                              padding: EdgeInsets.all(10.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(100.0),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'saved_pages'
                                          .tr()
                                          .replaceAll("\\n", "\n"),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(4.0),
                                    decoration:
                                        BoxDecoration(shape: BoxShape.circle),
                                    child: Icon(
                                      Icons.save,
                                      color: Colors.white,
                                      size: 20.0,
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: () {
                                /*Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SavedPostsPage(
                                            userId:
                                                MyAuth.auth.currentUser?.uid),
                                        settings:
                                            RouteSettings(name: "savedPosts")));*/

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NewPage()));
                                ads.showInter();
                              }),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> confirmExit() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text(
              'confirmation'.tr().replaceAll("\\n", "\n"),
              style: MyTextStyles.titleBold,
            ),
            content: new Text(
              'do_you_want_to_exit'.tr().replaceAll("\\n", "\n"),
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
                        Navigator.of(context).pop(true);
                      },
                      child: new Text(
                        'exit'.tr().replaceAll("\\n", "\n"),
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
                        Navigator.of(context).pop(false);
                      },
                      child: new Text(
                        'cancel'.tr().replaceAll("\\n", "\n"),
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
        )) ??
        false;
  }
}
