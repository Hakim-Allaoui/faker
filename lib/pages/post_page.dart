import 'dart:io';

import 'package:faker/models/comment_model.dart';
import 'package:faker/models/post_model.dart';
import 'package:faker/models/reactions_model.dart';
import 'package:faker/models/profile_model.dart';
import 'package:faker/providers/firestore_helper.dart';
import 'package:faker/utils/ads_helper.dart';
import 'package:faker/utils/auth.dart';
import 'package:faker/utils/navigator.dart';
import 'package:faker/utils/theme.dart';
import 'package:faker/utils/tools.dart';
import 'package:faker/widgets/appbar.dart';
import 'package:faker/widgets/post/comment.dart';
import 'package:faker/widgets/post/custom_editable_text.dart';
import 'package:faker/widgets/drawer.dart';
import 'package:faker/widgets/post/post_bottom_row.dart';
import 'package:faker/widgets/post/post_pictures.dart';
import 'package:faker/widgets/post/post_reactions.dart';
import 'package:faker/widgets/profile/profile_pic.dart';
import 'file:///D:/Coding/Android/Flutter/Faker/faker/lib/widgets/post/resizable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';

class PostPage extends StatefulWidget {
  final PostModel post;
  final String postId;

  const PostPage({Key key, this.post, this.postId}) : super(key: key);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  Ads ads;
  bool withText = true;
  String state;
  String addedPostId;
  bool fullScreen = false;

  PostModel post;

  TextEditingController textControllerPhotosCount = new TextEditingController();

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();

  var disableScrolling = false;

  addPostPic({int index}) async {
    File pic = await Tools.selectPic(context);
    if (pic != null) {
      setState(() {
        if (index == null) {
          post.images.add(pic);
        } else {
          post.images[index] = pic;
        }
        state = 'unsaved';
      });
    }
  }

  initPost() async {
    post = PostModel(
      user: ProfileModel(
          name: 'username'.tr().replaceAll("\\n", "\n"),
          otherName: 'other_name'.tr().replaceAll("\\n", "\n"),
          bio: 'Bio Text 💭',
          verified: true),
      elapsedTime: 'two_h'.tr().replaceAll("\\n", "\n"),
      text: 'click_to_write_your_own_post_text'.tr().replaceAll("\\n", "\n"),
      postReactions: ReactionsModel(
        reactions: ["like"],
        reactionsCount: 1,
        commentsCount: 1,
        sharesCount: 1,
      ),
      images: [],
      imagesNb: 0,
      imagesHeight: 300.0,
      comments: [
        /*CommentModel(
          user: ProfileModel(
              name: 'User Name',
              otherName: 'Other Name',
              bio: 'Bio Text 💭',
              verified: false),
          text: 'Click to edit comment ✏.',
          elapsedTime: '15 m',
          commentReactions: ReactionsModel(
            reactions: ["like"],
            reactionsCount: 0,
          ),
          replies: [
            ReplyModel(
              user: new ProfileModel(
                name: 'User Name',
              ),
              text: 'Click to edit reply ✏.',
              elapsedTime: 'Just Now',
              replyReactions: ReactionsModel(
                reactionsCount: 0,
                reactions: ["like"],
              ),
            ),
          ],
        ),*/
      ],
    );
    File pic = await Tools.getImageFileFromAssets('assets/images/blank.png');
    setState(() {
      post.images.add(pic);
      // post.comments[0]?.image = pic;
    });
  }

  @override
  void initState() {
    super.initState();
    state = widget.postId == null ? 'unsaved' : 'saved';
    addedPostId = widget.postId;

    if (widget.post == null) {
      initPost();
    } else {
      post = widget.post;
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
    void _showOptions(context, String userId) {
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
                  userId == null
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
                              'please_login_to_save_post'
                                  .tr()
                                  .replaceAll("\\n", "\n"),
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
                                    await updatePost(userId, addedPostId);
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
                            'post_text'.tr().replaceAll("\\n", "\n"),
                            style: MyTextStyles.titleBold.apply(
                              color: Palette.greyDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                    value: withText,
                    onChanged: (val) {
                      bottomSheetSetState(() {
                        withText = val;
                      });
                      setState(() {
                        withText = val;
                      });
                    },
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
                    title: Text(
                      'edit_pictures'.tr().replaceAll("\\n", "\n"),
                      style: MyTextStyles.titleBold.apply(
                        color: Palette.greyDark,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      editPictures(post.images);
                    },
                  ),
                  ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          color: Palette.greyLight,
                          borderRadius: BorderRadius.circular(100.0)),
                      child: new Icon(
                        fullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                        color: Palette.greyDark,
                      ),
                    ),
                    title: Text(
                      fullScreen
                          ? 'exit_full_screen_post'.tr().replaceAll("\\n", "\n")
                          : 'full_screen_post'.tr().replaceAll("\\n", "\n"),
                      style: MyTextStyles.titleBold.apply(
                        color: Palette.greyDark,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        if (fullScreen == false) {
                          fullScreen = true;
                          SystemChrome.setEnabledSystemUIOverlays(
                              [SystemUiOverlay.bottom]);
                        } else {
                          fullScreen = false;
                          SystemChrome.setEnabledSystemUIOverlays(
                              [SystemUiOverlay.bottom, SystemUiOverlay.top]);
                        }
                      });
                    },
                  ),
                  ListTile(
                    leading: SvgPicture.asset(
                      'assets/icons/translate.svg',
                      height: 25.0,
                    ),
                    title: Text(
                      'language'.tr().replaceAll("\\n", "\n"),
                      style: MyTextStyles.titleBold.apply(
                        color: Palette.greyDark,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      HKNavigator.goLanguage(context);
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
        if (fullScreen) {
          setState(() {
            fullScreen = false;
          });
          SystemChrome.setEnabledSystemUIOverlays(
              [SystemUiOverlay.bottom, SystemUiOverlay.top]);
        }
        if (!MyAuth.isAuth()) {
          return Future.value(true);
        } else {
          return confirmExit(MyAuth.auth.currentUser?.uid, addedPostId);
        }
      },
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: false,
        drawer: HKDrawer(
          scaffoldKey: scaffoldKey,
          showInterCallBack: () => ads.showInter(),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: ListView(
              shrinkWrap: true,
              physics: disableScrolling
                  ? NeverScrollableScrollPhysics()
                  : AlwaysScrollableScrollPhysics(),
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 2.0,
                          offset: Offset(0.0, 2.0)),
                    ],
                  ),
                  child: CustomAppBar(
                    scaffoldKey: scaffoldKey,
                    leading: IconButton(
                      icon: SvgPicture.asset(
                        'assets/icons/backarrow.svg',
                        color: Colors.black,
                        width: 15.0,
                      ),
                      onPressed: () {
                        if (fullScreen) {
                          setState(() {
                            fullScreen = false;
                          });
                          SystemChrome.setEnabledSystemUIOverlays(
                              [SystemUiOverlay.bottom, SystemUiOverlay.top]);
                        }
                        !MyAuth.isAuth()
                            ? Navigator.pop(context)
                            : confirmExit(
                                    MyAuth.auth.currentUser?.uid, addedPostId)
                                .then((value) {
                                if (value == true) Navigator.pop(context);
                              });
                      },
                    ),
                    title: Text(
                      'posts_title'.tr().replaceAll("\\n", "\n"),
                      style:
                          MyTextStyles.bigTitleBold.apply(color: Palette.black),
                    ),
                    trailing: IconButton(
                      tooltip: 'options'.tr().replaceAll("\\n", "\n"),
                      icon: Icon(
                        Icons.more_vert,
                        color: Colors.black,
                        size: 25.0,
                      ),
                      onPressed: () {
                        _showOptions(context, MyAuth.auth.currentUser?.uid);
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      ProfilePic(
                        onImageChose: (pic) {
                          post.user.photo = pic;
                          setState(() {
                            state = 'unsaved';
                          });
                        },
                        user: post.user,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  CustomEditableText(
                                    onSubmit: (val) {
                                      post.user.name = val;
                                      setState(() {
                                        state = 'unsaved';
                                      });
                                    },
                                    onVerifiedChange: (val) {
                                      post.user.verified = val;
                                      setState(() {
                                        state = 'unsaved';
                                      });
                                    },
                                    title:
                                        'username'.tr().replaceAll("\\n", "\n"),
                                    verified: post.user.verified,
                                    text: post.user.name,
                                    textStyle: MyTextStyles.fbTitleBold,
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  CustomEditableText(
                                    onSubmit: (val) {
                                      post.elapsedTime = val;
                                      setState(() {
                                        state = 'unsaved';
                                      });
                                    },
                                    title: 'elapsed_time'
                                        .tr()
                                        .replaceAll("\\n", "\n"),
                                    text: post.elapsedTime,
                                    textStyle: MyTextStyles.fbText.apply(
                                      color: Palette.greyDark,
                                      fontSizeFactor: 0.9,
                                    ),
                                  ),
                                  Text(
                                    '  • ',
                                    style: MyTextStyles.fbText.apply(
                                      color: Palette.greyDark,
                                      fontSizeFactor: 0.9,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: SvgPicture.asset(
                                      'assets/icons/globe.svg',
                                      height: 15.0,
                                      color: Palette.greyDark,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 2.0, horizontal: 12.0),
                          color: Colors.white,
                          child: SvgPicture.asset(
                            'assets/icons/more_hor.svg',
                            color: Palette.greyDark,
                            width: 20.0,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                withText
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 8.0),
                        child: CustomEditableText(
                          onSubmit: (val) {
                            post.text = val;
                            setState(() {
                              state = 'unsaved';
                            });
                          },
                          title: 'post_text'.tr().replaceAll("\\n", "\n"),
                          text: post.text,
                          multiline: true,
                          textStyle: MyTextStyles.fbText,
                        ),
                      )
                    : SizedBox(),
                GestureDetector(
                  onTap: () async {
                    List<File> pic = await editPictures(post.images);
                    setState(() {
                      if (pic != null) post.images = pic;
                    });
                  },
                  child: post.images.isEmpty
                      ? SizedBox()
                      : ResizableWidget(
                          onTap: (val) {
                            setState(() {
                              disableScrolling = val;
                            });
                          },
                          onRelease: (val) {
                            post.imagesHeight = val;
                            setState(() {
                              state = 'unsaved';
                            });
                          },
                          maxHeight: Tools.height,
                          height: post.imagesHeight ?? Tools.height * 0.4,
                          dividerHeight: 20.0,
                          child: PostPictures(
                            listImages: post.images,
                            maxHeight: Tools.height,
                            imagesNb: post.imagesNb ?? 0,
                          ),
                        ),
                ),
                Divider(
                  height: 1.0,
                  indent: 10.0,
                  endIndent: 10.0,
                ),
                SizedBox(height: 5.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: PostBottomRow(
                    post: post,
                    addComment: () async {
                      if (post.comments.length < 4) {
                        addComment().then((comment) {
                          if (comment != null) {
                            setState(() {
                              post.comments.add(comment);
                              state = 'unsaved';
                            });
                            // Tools.logger.v('======> comment added:\n ${comment.toJson()}');
                          }
                        });
                      } else {
                        Tools.showProDialog(context);
                      }
                    },
                  ),
                ),
                SizedBox(height: 5.0),
                Divider(
                  height: 5.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 8.0),
                  child: PostReactionsWidget(
                    post: post,
                    onChanged: () {
                      setState(() {
                        state = 'unsaved';
                      });
                    },
                  ),
                ),
                post.comments == null || post.comments.length < 0
                    ? SizedBox()
                    : Column(
                        children: post.comments
                            .map(
                              (item) => Padding(
                                key: Key('keyOfItem' +
                                    post.comments.indexOf(item).toString()),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                ),
                                child: InkWell(
                                  onLongPress: () async {
                                    print(item.toString());
                                    print('===> Deleting item N : ' +
                                        post.comments.indexOf(item).toString());
                                    await removeDialog(
                                        index: post.comments.indexOf(item));
                                    setState(() {
                                      state = 'unsaved';
                                    });
                                  },
                                  child: CommentWidget(
                                    comment: item,
                                    onChanged: () {
                                      setState(() {
                                        state = 'unsaved';
                                      });
                                    },
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: fullScreen == true
            ? SizedBox()
            : Container(
                padding: EdgeInsets.all(8.0),
                height: 60.0,
                width: Tools.width,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Palette.greyLight,
                      width: 2.0,
                    ),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Palette.greyLight,
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              if (post.comments.length < 4) {
                                addComment().then((comment) {
                                  if (comment != null) {
                                    setState(() {
                                      post.comments.add(comment);
                                      state = 'unsaved';
                                    });
                                  }
                                });
                              } else {
                                Tools.showProDialog(context);
                              }
                            },
                            child: Text(
                              'write_a_comment'.tr().replaceAll("\\n", "\n"),
                              style: MyTextStyles.fbText
                                  .apply(color: Palette.greyDark),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: SvgPicture.asset(
                            'assets/icons/camera.svg',
                            width: 25.0,
                            color: Palette.greyDark,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: SvgPicture.asset(
                            'assets/icons/gif.svg',
                            width: 25.0,
                            color: Palette.greyDark,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: SvgPicture.asset(
                            'assets/icons/smiling_face.svg',
                            width: 25.0,
                            color: Palette.greyDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Future<void> updatePost(String userId, String postId) async {
    //add post
    if (postId == null) {
      setState(() {
        state = 'uploading...';
      });

      await Posts.addPost(this.post);

      setState(() {
        state = 'saved';
      });

      Tools.logger.d("Post added successfully");
    } else {
      //modify post
      setState(() {
        state = 'uploading...';
      });

      await Posts.editPost(postId, this.post);

      setState(() {
        state = 'saved';
      });
      Tools.logger.d("Post updated successfully");
    }

    ads.showInter();
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
                      addedPostId == null
                          ? 'post_will_not_be_saved'
                              .tr()
                              .replaceAll("\\n", "\n")
                          : 'changes_not_saved_yet_do_you_want_to_update'
                              .tr()
                              .replaceAll("\\n", "\n"),
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
                                      await updatePost(userId, addedPostId);
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
                                          : 'update'
                                              .tr()
                                              .replaceAll("\\n", "\n"),
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

  Future<bool> removeDialog({int index}) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: Text(
              'delete_comment'.tr().replaceAll("\\n", "\n"),
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
                          child: new Text(
                            'cancel'.tr().replaceAll("\\n", "\n"),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
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
                            'ok'.tr().replaceAll("\\n", "\n"),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () {
                            post.comments.removeAt(index);
                            setState(() {});
                            Navigator.pop(context);
                          }),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<CommentModel> addComment() async {
    CommentModel comment = CommentModel(
        user: ProfileModel(
            name: 'username'.tr().replaceAll("\\n", "\n"),
            otherName: 'Other Name',
            bio: 'bio_text'.tr().replaceAll("\\n", "\n"),
            verified: false),
        text: 'click_to_edit_comment'.tr().replaceAll("\\n", "\n"),
        elapsedTime: 'fifteen_m'.tr().replaceAll("\\n", "\n"),
        commentReactions: ReactionsModel(
          reactions: ["like"],
          reactionsCount: 0,
        ),
        replies: []);

    File userImage;
    File commentImage;
    bool verified = false;

    TextEditingController textControllerUserName = new TextEditingController();
    TextEditingController textControllerComment = new TextEditingController();
    TextEditingController textControllerElapsedTime =
        new TextEditingController();
    TextEditingController textControllerReactsCount =
        new TextEditingController();

    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            'add_new_comment'.tr().replaceAll("\\n", "\n"),
            style: MyTextStyles.bigTitleBold.apply(color: Palette.accent),
            textAlign: TextAlign.center,
          ),
          scrollable: true,
          contentPadding: EdgeInsets.all(8.0),
          content: StatefulBuilder(builder: (context, setState) {
            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, right: 8.0, left: 8.0, bottom: 2.0),
                            child: Text(
                              'user_pic'.tr().replaceAll("\\n", "\n"),
                              style: MyTextStyles.title,
                            ),
                          ),
                          Container(
                            height: 50.0,
                            width: 50.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100.0),
                              color: Palette.greyLight,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100.0),
                              child: ProfilePic(
                                user: comment.user,
                                onImageChose: (photo) {
                                  userImage = photo;
                                  setState(() {
                                    state = 'unsaved';
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, right: 5.0, left: 8.0, bottom: 2.0),
                              child: Text(
                                'name'.tr().replaceAll("\\n", "\n"),
                                style: MyTextStyles.title,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                decoration: BoxDecoration(
                                  color: Palette.greyLight,
                                  borderRadius: BorderRadius.circular(100.0),
                                ),
                                child: Center(
                                  child: TextField(
                                    controller: textControllerUserName,
                                    maxLines: 1,
                                    keyboardType: TextInputType.text,
                                    style: MyTextStyles.fbText,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: textControllerUserName.text,
                                      hintStyle: TextStyle(color: Colors.grey),
                                      suffix: Container(
                                        padding: EdgeInsets.all(5.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                          color: Colors.black,
                                        ),
                                        child: InkWell(
                                          child: Icon(
                                            Icons.clear,
                                            color: Colors.white,
                                            size: 10.0,
                                          ),
                                          onTap: () =>
                                              textControllerUserName.clear(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, right: 8.0, left: 8.0, bottom: 2.0),
                            child: Text(
                              'verified'.tr().replaceAll("\\n", "\n"),
                              style: MyTextStyles.title,
                            ),
                          ),
                          IconButton(
                            icon: SvgPicture.asset(
                              'assets/icons/verified_badge.svg',
                              width: 30.0,
                              color:
                                  verified ? Palette.accent : Palette.greyDark,
                            ),
                            onPressed: () {
                              verified = !verified;
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
                    child: Text(
                      'comment_text'.tr().replaceAll("\\n", "\n"),
                      style: MyTextStyles.title,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        color: Palette.greyLight,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Center(
                        child: TextField(
                          controller: textControllerComment,
                          maxLines: 4,
                          keyboardType: TextInputType.multiline,
                          style: MyTextStyles.fbText,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: textControllerComment.text,
                            hintStyle: TextStyle(color: Colors.grey),
                            suffix: Container(
                              padding: EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100.0),
                                color: Colors.black,
                              ),
                              child: InkWell(
                                child: Icon(
                                  Icons.clear,
                                  color: Colors.white,
                                  size: 10.0,
                                ),
                                onTap: () => textControllerComment.clear(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
                    child: Text(
                      'comment_image'.tr().replaceAll("\\n", "\n"),
                      style: MyTextStyles.title,
                    ),
                  ),
                  //Image PlaceHolder
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: GestureDetector(
                      onTap: () async {
                        commentImage = await Tools.selectPic(context);
                        setState(() {});
                      },
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Container(
                            height: 80.0,
                            decoration: BoxDecoration(
                              color: Palette.greyLight,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: commentImage != null
                                ? Image.file(
                                    Tools.getLocalImage(commentImage.path),
                                    fit: BoxFit.cover)
                                : Image.asset(
                                    'assets/images/blank.png',
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
                    child: Text(
                      'elapsed_time'.tr().replaceAll("\\n", "\n"),
                      style: MyTextStyles.title,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        color: Palette.greyLight,
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      child: Center(
                        child: TextField(
                          controller: textControllerElapsedTime,
                          maxLines: 1,
                          keyboardType: TextInputType.text,
                          style: MyTextStyles.fbText,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: textControllerElapsedTime.text,
                            hintStyle: TextStyle(color: Colors.grey),
                            suffix: Container(
                              padding: EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100.0),
                                color: Colors.black,
                              ),
                              child: InkWell(
                                child: Icon(
                                  Icons.clear,
                                  color: Colors.white,
                                  size: 10.0,
                                ),
                                onTap: () => textControllerElapsedTime.clear(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
                    child: Text(
                      'reacts_count'.tr().replaceAll("\\n", "\n"),
                      style: MyTextStyles.title,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        color: Palette.greyLight,
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      child: Center(
                        child: TextField(
                          controller: textControllerReactsCount,
                          maxLines: 1,
                          keyboardType: TextInputType.number,
                          style: MyTextStyles.fbText,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: textControllerReactsCount.text,
                            hintStyle: TextStyle(color: Colors.grey),
                            suffix: Container(
                              padding: EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100.0),
                                color: Colors.black,
                              ),
                              child: InkWell(
                                child: Icon(
                                  Icons.clear,
                                  color: Colors.white,
                                  size: 10.0,
                                ),
                                onTap: () => textControllerReactsCount.clear(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          actions: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.circular(100.0),
                        color: Palette.greyDarken,
                      ),
                      child: FlatButton(
                          padding: EdgeInsets.all(8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(100.0),
                          ),
                          child: new Text(
                            'cancel'.tr().replaceAll("\\n", "\n"),
                            style: MyTextStyles.titleBold
                                .apply(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(null);
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
                        gradient: RadialGradient(
                          colors: Palette.gradientColors2,
                          center: Alignment.bottomLeft,
                          radius: 2.0,
                        ),
                      ),
                      child: FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(100.0),
                          ),
                          child: new Text(
                            'ok'.tr().replaceAll("\\n", "\n"),
                            style: MyTextStyles.titleBold
                                .apply(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () {
                            comment = CommentModel(
                                user: ProfileModel(
                                    name: textControllerUserName.text != ''
                                        ? textControllerUserName.text
                                        : 'username'
                                            .tr()
                                            .replaceAll("\\n", "\n"),
                                    photo: userImage,
                                    otherName: 'Other Name',
                                    bio:
                                        'bio_text'.tr().replaceAll("\\n", "\n"),
                                    verified: verified),
                                text: textControllerComment.text != ''
                                    ? textControllerComment.text
                                    : 'click_to_edit_comment'
                                        .tr()
                                        .replaceAll("\\n", "\n"),
                                elapsedTime: textControllerElapsedTime.text !=
                                        ''
                                    ? textControllerElapsedTime.text
                                    : 'fifteen_m'.tr().replaceAll("\\n", "\n"),
                                commentReactions: ReactionsModel(
                                  reactions: ["like"],
                                  reactionsCount: int.parse(
                                      textControllerReactsCount.text != ''
                                          ? textControllerReactsCount.text
                                          : '0'),
                                ),
                                image: commentImage,
                                replies: []);
                            ads.showInter();
                            Navigator.pop(context, comment);
                          }),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Future<List<File>> editPictures(List<File> listPictures) async {
    return showModalBottomSheet(
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
                  Expanded(
                    child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: listPictures.length + 1,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, mainAxisSpacing: 20),
                      itemBuilder: (context, index) {
                        return index != listPictures.length
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Stack(
                                  children: [
                                    Container(
                                      height: Tools.width * 0.3,
                                      width: Tools.width * 0.3,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        child: Image.file(
                                            Tools.getLocalImage(
                                                listPictures[index].path),
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0.0,
                                      left: 0.0,
                                      child: IconButton(
                                        iconSize: 15.0,
                                        onPressed: () async {
                                          await addPostPic(index: index);
                                          bottomSheetSetState(() {});
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
                                    Positioned(
                                      top: 0.0,
                                      right: 0.0,
                                      child: IconButton(
                                        iconSize: 15.0,
                                        onPressed: () {
                                          bottomSheetSetState(() {
                                            listPictures.removeAt(index);
                                          });
                                          setState(() {
                                            state = 'unsaved';
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
                                    Positioned(
                                      bottom: 5.0,
                                      left: 5.0,
                                      child: Container(
                                        padding: EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                            color: Colors.white70,
                                            shape: BoxShape.circle),
                                        child:
                                            Center(child: Text('${index + 1}')),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : listPictures.length < 5
                                ? IconButton(
                                    onPressed: () async {
                                      await addPostPic();
                                      bottomSheetSetState(() {});
                                    },
                                    icon: Container(
                                      height: 50.0,
                                      width: 50.0,
                                      decoration: BoxDecoration(
                                        color: Palette.greyLight,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text('+'),
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: Tools.width * 0.3,
                                      width: Tools.width * 0.3,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        color: Palette.greyLight,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text('+',
                                                style: MyTextStyles
                                                    .fbSubTitleBold
                                                    .apply(
                                                        color:
                                                            Palette.greyDark)),
                                            Container(
                                              height: 40.0,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8.0),
                                              decoration: BoxDecoration(
                                                color: Palette.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        100.0),
                                              ),
                                              child: TextField(
                                                controller:
                                                    textControllerPhotosCount,
                                                maxLines: 1,
                                                keyboardType:
                                                    TextInputType.number,
                                                onChanged: (val) {
                                                  post.imagesNb =
                                                      int.parse(val);
                                                  // setState(() {
                                                  state = 'unsaved';
                                                  // });
                                                },
                                                style: MyTextStyles.fbText,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: post.imagesNb
                                                          .toString() ??
                                                      '0',
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey),
                                                  suffix: Container(
                                                    padding:
                                                        EdgeInsets.all(5.0),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100.0),
                                                      color: Colors.black,
                                                    ),
                                                    child: InkWell(
                                                      child: Icon(
                                                        Icons.clear,
                                                        color: Colors.white,
                                                        size: 10.0,
                                                      ),
                                                      onTap: () {
                                                        textControllerPhotosCount
                                                            .clear();
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Text('Photos',
                                                style: MyTextStyles
                                                    .fbSubTitleBold
                                                    .apply(
                                                        color:
                                                            Palette.greyDark)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                      },
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }
}
