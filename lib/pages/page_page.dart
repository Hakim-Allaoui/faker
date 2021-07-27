import 'package:faker/models/profile_model.dart';
import 'package:faker/utils/ads_helper.dart';
import 'package:faker/utils/theme.dart';
import 'package:faker/utils/tools.dart';
import 'package:faker/widgets/page/page_main_bottons.dart';
import 'package:faker/widgets/post/custom_editable_text.dart';
import 'package:faker/widgets/page/page_widgets.dart';
import 'package:faker/widgets/profile/cover_pic.dart';
import 'package:faker/widgets/profile/profile_pic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NewPage extends StatefulWidget {
  @override
  _NewPageState createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  Ads ads;
  int selectedIndex = 0;
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();

  @override
  void initState() {
    ads = new Ads();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Palette.secondary,
      endDrawer: Drawer(),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: <Widget>[
          Container(
            height: Tools.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: <Widget>[
                Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width / 1.6,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          CoverPic(
                            onClicked: () => ads.showInter(),
                            user: ProfileModel(),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.width / 4,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black54,
                                  Colors.transparent,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset(
                                'assets/icons/backarrow.svg',
                                width: 20.0,
                                color: Colors.white,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(6.0),
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.4),
                                    borderRadius:
                                        BorderRadius.circular(100.0)),
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.search,
                                      color: Palette.greyDark,
                                    ),
                                    Text(
                                      'Page Name',
                                      style: TextStyle(
                                        color: Palette.greyDark,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset(
                                'assets/icons/share_fill.svg',
                                width: 20.0,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 8.0,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            ProfilePic(
                              user: ProfileModel(),
                              onImageChose: (photo) {
                                setState(() {});
                              },
                              size: 65.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: <Widget>[
                                  CustomEditableText(
                                    title: 'Name',
                                    text: 'Page Name',
                                    textStyle: MyTextStyles.fbTitleBigBold,
                                  ),
                                  CustomEditableText(
                                    title: 'Category',
                                    text: 'Page Category',
                                    textStyle: MyTextStyles.fbText
                                        .apply(color: Palette.greyDark),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectedIndex == 0
                                ? selectedIndex = 1
                                : selectedIndex = 0;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              child: SvgPicture.asset(
                                selectedIndex == 0
                                    ? "assets/icons/like_strock.svg"
                                    : "assets/icons/like_fill.svg",
                                height: 25.0,
                              ),
                            ),
                            Text(
                              selectedIndex == 0 ? 'Like' : 'Liked',
                              style: MyTextStyles.fbText.apply(
                                  color: selectedIndex == 0
                                      ? Palette.greyDarken
                                      : Color(0XFF5C94FF)),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                ButtonRowPage(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 85.0,
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height: 35.0,
                              width: 35.0,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(100.0),
                                  color: Palette.greyLight,
                                  border: Border.all(
                                      color: Colors.white, width: 2.0)),
                              child: ProfilePic(
                                user: ProfileModel(),
                                onImageChose: (photo) {
                                  setState(() {});
                                },
                              ),
                            ),
                            Positioned(
                              left: 25.0,
                              child: Container(
                                height: 35.0,
                                width: 35.0,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(100.0),
                                    color: Palette.greyLight,
                                    border: Border.all(
                                        color: Colors.white, width: 2.0)),
                                child: ProfilePic(
                                  user: ProfileModel(),
                                  onImageChose: (photo) {
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                            Positioned(
                              left: 50.0,
                              child: Container(
                                height: 35.0,
                                width: 35.0,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(100.0),
                                    color: Palette.greyLight,
                                    border: Border.all(
                                        color: Colors.white, width: 2.0)),
                                child: ProfilePic(
                                  user: ProfileModel(),
                                  onImageChose: (photo) {
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Expanded(
                        child: CustomEditableText(
                          text:
                              'name1, name2, name3 and 61,350 other like this',
                        ),
                      )
                    ],
                  ),
                ),
                Divider(
                  height: 0.0,
                ),
                Container(
                  height: 50.0,
                  width: MediaQuery.of(context).size.width,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      Container(
                        height: 50.0,
                        child: DefaultTabController(
                          length: 11,
                          child: PreferredSize(
                            preferredSize: new Size(MediaQuery.of(context).size.width, 50.0),
                            child: TabBar(
                              labelStyle: MyTextStyles.bigTitle.apply(color: Palette.greyLight),
                              labelColor: Palette.facebookNewBlue,
                              unselectedLabelColor: Palette.greyDark,
                              isScrollable: true,
                              labelPadding: EdgeInsets.all(8.0),
                              indicatorColor: Palette.facebookNewBlue,
                              tabs: [
                                Tab(text: 'Home'),
                                Tab(text: 'Posts'),
                                Tab(text: 'Reviews'),
                                Tab(text: 'Videos'),
                                Tab(text: 'Photos'),
                                Tab(text: 'About'),
                                Tab(text: 'Community'),
                                Tab(text: 'Events'),
                                Tab(text: 'Offers'),
                                Tab(text: 'Groups'),
                                Tab(text: 'Jobs'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 6.0,
                  color: Palette.greyDark,
                ),
                SizedBox(height: 5.0,),
                Expanded(child: AboutSection()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
