import 'package:faker/models/profile_model.dart';
import 'package:faker/utils/ads_helper.dart';
import 'package:faker/utils/auth.dart';
import 'package:faker/utils/strings.dart';
import 'package:faker/utils/tools.dart';
import 'package:faker/utils/theme.dart';
import 'package:faker/widgets/profile/profile_details.dart';
import 'package:faker/widgets/profile/profile_pic.dart';
import 'package:faker/widgets/profile/cover_pic.dart';
import 'package:faker/widgets/profile/profile_main_buttons.dart';
import 'package:faker/widgets/post/custom_editable_text.dart';
import 'package:faker/widgets/profile/profile_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:faker/providers/firestore_helper.dart';

class ProfilePage extends StatefulWidget {
  final ProfileModel profile;

  // final String profileId;
  final String profileId;

  const ProfilePage({Key key, this.profile, this.profileId}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Ads ads;
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();
  ProfileModel profile;
  String state = "unsaved";
  String addedProfileId;

  initProfile() {
    profile = new ProfileModel(
        name: 'User Name',
        otherName: 'Other Name',
        bio: 'Bio Text 💭',
        verified: true,
        hasStory: true,
        showBio: true,
        showOtherName: false,
        viewAs: false,
        mainButton: Strings.labelIconsProfile[6],
        details: {
          Strings.labelIconsDetails[0]: "New York",
          Strings.labelIconsDetails[1]: "University Oxford",
          Strings.labelIconsDetails[2]: "Page",
          Strings.labelIconsDetails[3]: "Facebook",
          Strings.labelIconsDetails[4]: "Someone",
          Strings.labelIconsDetails[5]: "Casablanca, Morocco",
          Strings.labelIconsDetails[6]: "10 000 000 people",
        });
  }

  @override
  void initState() {
    super.initState();

    state = widget.profileId == null ? 'unsaved' : 'saved';
    addedProfileId = widget.profileId;

    if (widget.profile == null) {
      initProfile();
    } else {
      profile = widget.profile;
    }

    ads = new Ads();
    ads.loadInter();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void _showOptions() {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15.0),
                topLeft: Radius.circular(15.0))),
        builder: (BuildContext ctx) {
          return StatefulBuilder(builder: (context, bottomSheetSetState) {
            return Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 4.0,
                        width: 50.0,
                        decoration: BoxDecoration(
                          color: Palette.greyLight,
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                      ),
                    ),
                  ),
                  MyAuth.auth.currentUser?.uid == null
                      ? Opacity(
                          opacity: 0.4,
                          child: ListTile(
                            leading: Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100.0)),
                              child: Icon(
                                Icons.cloud_off,
                                color: Palette.greyDark,
                              ),
                            ),
                            title: Text(
                              'please_login_to_save_profile'.tr().replaceAll("\\n", "\n"),
                              style: MyTextStyles.title.apply(
                                color: Palette.greyDark,
                              ),
                            ),
                            trailing: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.block,
                                color: Palette.greyDark,
                              ),
                            ),
                          ),
                        )
                      : ListTile(
                          leading: Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100.0)),
                            child: new Icon(
                              state != 'saved'
                                  ? state == 'uploading...'
                                      ? Icons.cloud_upload
                                      : Icons.cloud_off
                                  : Icons.cloud_done,
                              color: Palette.greyDark,
                            ),
                          ),
                          title: Text(
                            state.tr(),
                            style: MyTextStyles.title.apply(
                              color: Palette.greyDark,
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: state == 'saved'
                                ? null
                                : () async {
                                    bottomSheetSetState(() {
                                      state = 'uploading...';
                                    });
                                    await updateProfile(
                                        MyAuth.auth.currentUser?.uid,
                                        addedProfileId);
                                    bottomSheetSetState(() {
                                      state = 'saved';
                                    });
                                  },
                            icon: state != 'saved'
                                ? state == 'uploading...'
                                    ? Center(
                                        child: Theme(
                                          data: ThemeData(
                                              accentColor: Palette.greyDark),
                                          child: CircularProgressIndicator(
                                            backgroundColor: Palette.greyLight,
                                            strokeWidth: 2.0,
                                          ),
                                        ),
                                      )
                                    : Stack(
                                        children: [
                                          Icon(
                                            Icons.file_upload,
                                            color: Palette.greyDark,
                                          ),
                                          Positioned(
                                            top: 0.0,
                                            right: 0.0,
                                            child: Container(
                                              height: 10.0,
                                              width: 10.0,
                                              decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color: Colors.white,
                                                      width: 2.0)),
                                            ),
                                          )
                                        ],
                                      )
                                : Icon(
                                    Icons.check,
                                    color: Palette.online,
                                  ),
                          ),
                        ),
                  Divider(),
                  SwitchListTile(
                    title: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              color: Palette.greyLight,
                              borderRadius: BorderRadius.circular(100.0)),
                          child: new Icon(
                            Icons.short_text_outlined,
                            color: Palette.greyDark,
                          ),
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        Expanded(
                          child: Text(
                            'view_as'.tr().replaceAll("\\n", "\n"),
                            style: MyTextStyles.titleBold.apply(
                              color: Palette.greyDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                    value: profile.viewAs,
                    onChanged: (val) {
                      bottomSheetSetState(() {
                        profile.viewAs = val;
                      });
                      setState(() {
                        profile.viewAs = val;
                        state = 'unsaved';
                      });
                    },
                  ),
                  SwitchListTile(
                    title: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              color: Palette.greyLight,
                              borderRadius: BorderRadius.circular(100.0)),
                          child: new Icon(
                            Icons.short_text_outlined,
                            color: Palette.greyDark,
                          ),
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        Expanded(
                          child: Text(
                            'verified'.tr().replaceAll("\\n", "\n"),
                            style: MyTextStyles.titleBold.apply(
                              color: Palette.greyDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                    value: profile.verified,
                    onChanged: (val) {
                      bottomSheetSetState(() {
                        profile.verified = val;
                      });
                      setState(() {
                        profile.verified = val;
                        state = 'unsaved';
                      });
                    },
                  ),
                  SwitchListTile(
                    title: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              color: Palette.greyLight,
                              borderRadius: BorderRadius.circular(100.0)),
                          child: new Icon(
                            Icons.short_text_outlined,
                            color: Palette.greyDark,
                          ),
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        Expanded(
                          child: Text(
                            'show_other_name'.tr().replaceAll("\\n", "\n"),
                            style: MyTextStyles.titleBold.apply(
                              color: Palette.greyDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                    value: profile.showOtherName,
                    onChanged: (val) {
                      bottomSheetSetState(() {
                        profile.showOtherName = val;
                      });
                      setState(() {
                        profile.showOtherName = val;
                        state = 'unsaved';
                      });
                    },
                  ),
                  SwitchListTile(
                    title: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              color: Palette.greyLight,
                              borderRadius: BorderRadius.circular(100.0)),
                          child: new Icon(
                            Icons.short_text_outlined,
                            color: Palette.greyDark,
                          ),
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        Expanded(
                          child: Text(
                            'show_bio'.tr().replaceAll("\\n", "\n"),
                            style: MyTextStyles.titleBold.apply(
                              color: Palette.greyDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                    value: profile.showBio,
                    onChanged: (val) {
                      bottomSheetSetState(() {
                        profile.showBio = val;
                      });
                      setState(() {
                        profile.showBio = val;
                        state = 'unsaved';
                      });
                    },
                  ),
                  SwitchListTile(
                    title: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              color: Palette.greyLight,
                              borderRadius: BorderRadius.circular(100.0)),
                          child: new Icon(
                            Icons.short_text_outlined,
                            color: Palette.greyDark,
                          ),
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        Expanded(
                          child: Text(
                            'has_story'.tr().replaceAll("\\n", "\n"),
                            style: MyTextStyles.titleBold.apply(
                              color: Palette.greyDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                    value: profile.hasStory,
                    onChanged: (val) {
                      bottomSheetSetState(() {
                        profile.hasStory = val;
                      });
                      setState(() {
                        profile.hasStory = val;
                        state = 'unsaved';
                      });
                    },
                  ),
                ],
              ),
            );
          });
        },
      );
    }

    return WillPopScope(
      onWillPop: () {
        if (!MyAuth.isAuth()) {
          return Future.value(true);
        } else {
          return confirmExit(MyAuth.auth.currentUser?.uid, addedProfileId);
        }
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Palette.white,
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: SvgPicture.asset(
                        'assets/icons/backarrow.svg',
                        color: Colors.black,
                        width: 18.0,
                      ),
                      onPressed: () {
                        {
                          !MyAuth.isAuth()
                              ? Navigator.pop(context)
                              : confirmExit(MyAuth.auth.currentUser?.uid,
                                      addedProfileId)
                                  .then((value) {
                                  if (value == true) Navigator.pop(context);
                                });
                        }
                      },
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            color: Palette.greyLight,
                            borderRadius: BorderRadius.circular(100.0)),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.search,
                              color: Palette.greyDark,
                            ),
                            Expanded(
                                child: Text(
                              'Search',
                              style: MyTextStyles.fbText
                                  .apply(color: Palette.greyDark),
                            )),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _showOptions();
                      },
                      icon: Icon(
                        Icons.more_vert,
                        color: Palette.greyDark,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 1.0,
              ),
              Expanded(
                child: Container(
                  width: Tools.width,
                  child: SingleChildScrollView(
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Stack(
                            alignment: Alignment.bottomCenter,
                            overflow: Overflow.visible,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  children: <Widget>[
                                    Stack(
                                      alignment: Alignment.bottomRight,
                                      children: <Widget>[
                                        Container(
                                          height: Tools.width * 0.6,
                                          width: Tools.width,
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10.0),
                                                topRight:
                                                    Radius.circular(10.0)),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10.0),
                                                topRight:
                                                    Radius.circular(10.0)),
                                            child: CoverPic(
                                              onClicked: null,
                                              user: profile,
                                              onImageChose: (image) {
                                                profile.cover = image;
                                                setState(() {
                                                  state = 'unsaved';
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                        profile.viewAs
                                            ? SizedBox()
                                            : CameraButton(
                                                icon: 'assets/icons/camera.svg',
                                                roundedCorners: 6.0,
                                              ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: -Tools.width * 0.25,
                                child: Stack(
                                  alignment: Alignment.bottomRight,
                                  children: <Widget>[
                                    Container(
                                      width: Tools.width * 0.5,
                                      height: Tools.width * 0.5,
                                      margin: EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                      ),
                                      child: Container(
                                        margin: EdgeInsets.all(
                                            profile.hasStory ? 5.0 : 0.0),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                          border: Border.all(
                                              color: profile.hasStory
                                                  ? Palette.facebookNewBlue
                                                  : Colors.transparent,
                                              width:
                                                  profile.hasStory ? 4.0 : 0.0),
                                        ),
                                        child: Container(
                                          margin: EdgeInsets.all(5.0),
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            child: ProfilePic(
                                              user: profile,
                                              size: Tools.width * 0.5,
                                              onImageChose: (image) {
                                                profile.photo = image;
                                                setState(() {
                                                  state = 'unsaved';
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    profile.viewAs
                                        ? SizedBox()
                                        : Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: CameraButton(
                                              icon: 'assets/icons/camera.svg',
                                              roundedCorners: 100.0,
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 10.0,
                                right: 10.0,
                                top: Tools.width * 0.25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                CustomEditableText(
                                  onSubmit: (val) {
                                    profile.name = val;
                                    setState(() {
                                      state = 'unsaved';
                                    });
                                  },
                                  title: 'Name',
                                  text: profile.name,
                                  textStyle: MyTextStyles.fbTitleBigBold,
                                ),
                                profile.showOtherName
                                    ? Row(
                                        children: <Widget>[
                                          Text(
                                            '(',
                                            style: MyTextStyles.fbTitleBigBold
                                                .apply(fontSizeFactor: 0.8),
                                          ),
                                          CustomEditableText(
                                            title: 'Other Name',
                                            text: profile.otherName,
                                            textStyle: MyTextStyles
                                                .fbTitleBigBold
                                                .apply(fontSizeFactor: 0.8),
                                            onSubmit: (val) {
                                              profile.otherName = val;
                                              setState(() {
                                                state = 'unsaved';
                                              });
                                            },
                                          ),
                                          Text(
                                            ')',
                                            style: MyTextStyles.fbTitleBigBold
                                                .apply(fontSizeFactor: 0.8),
                                          ),
                                        ],
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          ),
                          profile.showBio
                              ? Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 15.0),
                                  child: CustomEditableText(
                                    title: 'Bio',
                                    multiline: true,
                                    text: profile.bio,
                                    textStyle: MyTextStyles.fbText
                                        .apply(color: Palette.greyDark),
                                    textAlign: TextAlign.center,
                                    onSubmit: (val) {
                                      profile.bio = val;
                                      setState(() {
                                        state = 'unsaved';
                                      });
                                    },
                                  ),
                                )
                              : SizedBox(),
                          ButtonRowProfile(
                              button: profile.mainButton,
                              onChanged: (val) {
                              profile.mainButton = val;
                              setState(() {
                                state = 'unsaved';
                              });
                            },
                          ),
                          Divider(
                            indent: 10.0,
                            endIndent: 10.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                ProfileDetails(
                                  details: profile.details,
                                  onChanged: (key, val) {
                                    profile.details[key] = val;
                                    setState(() {
                                      state = 'unsaved';
                                    });
                                  },
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.more_horiz,
                                        size: 25.0, color: Color(0xff8F939A)),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        'see_about_info'.tr().replaceAll("\\n", "\n"),
                                        style: MyTextStyles.fbTitle,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> confirmExit(String userId, String postId) async {
    return state == 'saved'
        ? true
        : (await showDialog(
              context: context,
              builder: (context) => StatefulBuilder(
                builder: (context, dialogSetState) {
                  return new AlertDialog(
                    title: new Text(
                      'confirmation'.tr().replaceAll("\\n", "\n"),
                      style: MyTextStyles.titleBold,
                    ),
                    content: new Text(
                      addedProfileId == null
                          ? 'profile_will_not_be_saved'.tr().replaceAll("\\n", "\n")
: 'changes_not_saved_yet_do_you_want_to_update'.tr().replaceAll("\\n", "\n"),
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
                                'discard'.tr().replaceAll("\\n", "\n"),
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
                              borderRadius: BorderRadius.circular(100.0),
                              gradient: RadialGradient(
                                colors: Palette.gradientColors2,
                                center: Alignment.bottomLeft,
                                radius: 2.0,
                              ),
                            ),
                            child: FlatButton(
                              onPressed: state != 'saved'
                                  ? () async {
                                      dialogSetState(() {});
                                      await updateProfile(
                                          userId, addedProfileId);
                                      dialogSetState(() {});
                                      Navigator.of(context).pop(true);
                                    }
                                  : null,
                              child: state != 'unsaved'
                                  ? Center(
                                      child: Theme(
                                        data: ThemeData(
                                            accentColor: Palette.greyDark),
                                        child: CircularProgressIndicator(
                                          backgroundColor: Palette.greyLight,
                                          strokeWidth: 2.0,
                                        ),
                                      ),
                                    )
                                  : Text(
                                      postId == null
                                          ? 'save'.tr().replaceAll("\\n", "\n")
: 'update'.tr().replaceAll("\\n", "\n"),
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
                  );
                },
              ),
            )) ??
            false;
  }

  Future<void> updateProfile(String userId, String postId) async {
    //add Profile
    if (postId == null) {
      setState(() {
        state = 'uploading...';
      });

      addedProfileId = await Profiles.addProfile(this.profile);

      setState(() {
        state = 'saved';
      });
    } else {
      //modify Profile
      setState(() {
        state = 'uploading...';
      });

      await Profiles.editProfile(postId, this.profile);

      setState(() {
        state = 'saved';
      });
      Tools.logger.d("Profile updated successfully");
    }

    ads.showInter();
  }

  editProfilePic() async {
    bool edit = await showModalBottomSheet<bool>(
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
                      Icons.edit,
                      color: Palette.greyDark,
                    ),
                  ),
                  title: new Text(
                    'edit'.tr().replaceAll("\\n", "\n"),
                    style: MyTextStyles.titleBold.apply(
                      color: Palette.greyDark,
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(context, true);
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: Palette.greyLight,
                        borderRadius: BorderRadius.circular(100.0)),
                    child: new Icon(
                      Icons.delete,
                      color: Palette.gradient3,
                    ),
                  ),
                  title: new Text(
                    'delete'.tr().replaceAll("\\n", "\n"),
                    style: MyTextStyles.titleBold.apply(
                      color: Palette.gradient3,
                    ),
                  ),
                  onTap: () => Navigator.pop(context, false),
                ),
              ],
            ),
          );
        });

    if (edit != null) {
      if (edit == false) {
        profile.photo = null;
      } else {
        profile.photo = await Tools.selectPic(context) ?? profile.photo;
      }
    }
  }

  editCoverPic() async {
    bool edit = await showModalBottomSheet<bool>(
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
                      Icons.edit,
                      color: Palette.greyDark,
                    ),
                  ),
                  title: new Text(
                    'edit'.tr().replaceAll("\\n", "\n"),
                    style: MyTextStyles.titleBold.apply(
                      color: Palette.greyDark,
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(context, true);
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: Palette.greyLight,
                        borderRadius: BorderRadius.circular(100.0)),
                    child: new Icon(
                      Icons.delete,
                      color: Palette.gradient3,
                    ),
                  ),
                  title: new Text(
                    'delete'.tr().replaceAll("\\n", "\n"),
                    style: MyTextStyles.titleBold.apply(
                      color: Palette.gradient3,
                    ),
                  ),
                  onTap: () => Navigator.pop(context, false),
                ),
              ],
            ),
          );
        });

    if (edit != null) {
      if (edit == false) {
        profile.photo = null;
      } else {
        profile.photo = await Tools.selectPic(context) ?? profile.photo;
      }
    }
  }
}
