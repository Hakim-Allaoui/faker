import 'package:faker/models/profile_model.dart';
import 'package:faker/pages/profile_page.dart';
import 'package:faker/providers/firestore_helper.dart';
import 'package:faker/utils/ads_helper.dart';
import 'package:faker/utils/navigator.dart';
import 'package:faker/utils/theme.dart';
import 'package:faker/utils/tools.dart';
import 'package:faker/widgets/appbar.dart';
import 'package:faker/widgets/drawer.dart';
import 'package:faker/widgets/profile/profile_minimal_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';

class SavedProfiles extends StatefulWidget {
  final String userId;

  const SavedProfiles({Key key, this.userId}) : super(key: key);
  
  @override
  _SavedProfilesState createState() => _SavedProfilesState();
}

class _SavedProfilesState extends State<SavedProfiles> {
  Ads ads;

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();

  @override
  void initState() {
    super.initState();


    ads = new Ads();
    ads.loadInter();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: HKDrawer(scaffoldKey: scaffoldKey,showInterCallBack: () => ads.showInter(),),
      backgroundColor: Colors.white,
      floatingActionButton: widget.userId != null
          ? Profiles.profiles.length > 0
          ? FloatingActionButton(
        onPressed: () async {
          HKNavigator.goProfile(context, onPop: () {
            setState(() {});
          });
        },
        backgroundColor: Palette.gradient1,
        child: Icon(
          Icons.add,
          color: Palette.white,
        ),
      )
          : SizedBox()
          : SizedBox(),
      bottomNavigationBar: SizedBox(
        height: 50.0,
        child: ads.getBannerAd(),
      ),
      body: Column(
        children: [
          CustomAppBar(
            scaffoldKey: scaffoldKey,
            leading: IconButton(
              icon: SvgPicture.asset(
                'assets/icons/backarrow.svg',
                color: Colors.black,
                width: 20.0,
              ),
              onPressed: () async {
                Navigator.pop(context);
              },
            ),
            title: Text(
              'saved_profiles'.tr().replaceAll("\\n", "\n"),
              style: MyTextStyles.bigTitleBold,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: widget.userId == null
                ? buildSignInWidget()
                : buildProfilesWidget(),
          ),
        ],
      ),
    );
  }

  Widget buildProfilesWidget() {
    Tools.logger.d("${Profiles.profiles.length} Profiles Retrieved");

    if (/*MyAuth.isAuth() && */ Profiles.profiles.length == 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'empty'.tr().replaceAll("\\n", "\n"),
            style: MyTextStyles.bigTitleBold.apply(color: Palette.greyDark),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.0),
          IconButton(
            onPressed: () async {
              HKNavigator.goProfile(context, onPop: () {
                setState(() {});
              });
              ads.showInter();
            },
            icon: Icon(
              Icons.add_circle_rounded,
              size: 30.0,
              color: Palette.greyDark,
            ),
          ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3.0),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: Profiles.profiles.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 6,
          childAspectRatio: 0.6,
        ),
        itemBuilder: (ctx, index) {
          ProfileModel profile = Profiles.profiles.values.elementAt(index);
          String id = Profiles.profiles.keys.elementAt(index);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.0),
            child: Container(
              decoration: BoxDecoration(
                color: Palette.greyLight,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 2.0,
                  )
                ],
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ProfileMiniWidget(profile: profile),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black12,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: IconButton(
                                iconSize: 15.0,
                                onPressed: () async {
                                  removeDialog().then((value) async {
                                    if (value == true) {
                                      await Profiles.deleteProfile(id);
                                      setState(() {});
                                    }
                                  });
                                },
                                icon: Container(
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      color: Colors.white70,
                                      shape: BoxShape.circle),
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                              child: VerticalDivider(),
                            ),
                            Expanded(
                              child: IconButton(
                                iconSize: 15.0,
                                onPressed: () {
                                  Tools.logger.d("Post edited");
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (ctx) {
                                          return ProfilePage(
                                            profile: profile,
                                            profileId: id,
                                          );
                                        },
                                        settings: RouteSettings(name: 'profile'),
                                      )).then((value) {
                                    setState(() {});
                                  });
                                },
                                icon: Container(
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      color: Colors.white70,
                                      shape: BoxShape.circle),
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildSignInWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'login_to_see_saved_profiles'.tr().replaceAll("\\n", "\n"),
          style: MyTextStyles.bigTitleBold.apply(color: Palette.greyDark),
        ),
        SizedBox(height: 20.0),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 0.0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.0),
            gradient: RadialGradient(
              colors: [
                Palette.online,
                Palette.gradient1,
              ],
              center: Alignment.bottomLeft,
              radius: 2.0,
            ),
          ),
          child: FlatButton(
            padding: EdgeInsets.all(20.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0),
            ),
            child: Text(
              'login'.tr().replaceAll("\\n", "\n"),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            onPressed: () async {
              HKNavigator.goAuth(context);
              ads.showInter();
            },
          ),
        ),
      ],
    );
  }

  Future<bool> removeDialog() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            'delete_post'.tr().replaceAll("\\n", "\n"),
            style: MyTextStyles.title.apply(color: Colors.black),
            textAlign: TextAlign.center,
          ),
          content: Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: new BorderRadius.circular(100.0),
                      color: Colors.black,
                    ),
                    child: FlatButton(
                        padding: EdgeInsets.all(8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(100.0),
                        ),
                        child: Text(
                          'cancel'.tr().replaceAll("\\n", "\n"),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () async {
                          Navigator.pop(context, false);
                        }),
                  ),
                ),
                SizedBox(
                  width: 8.0,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: new BorderRadius.circular(100.0),
                      color: Colors.red,
                    ),
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(100.0),
                      ),
                      child: new Text(
                        'delete'.tr().replaceAll("\\n", "\n"),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () async {
                        Navigator.pop(context, true);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}