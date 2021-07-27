import 'dart:io';

import 'package:faker/models/comment_model.dart';
import 'package:faker/models/reactions_model.dart';
import 'package:faker/models/reply_model.dart';
import 'package:faker/models/profile_model.dart';
import 'package:faker/utils/theme.dart';
import 'package:faker/utils/tools.dart';
import 'package:faker/widgets/post/comment_bottom_row.dart';
import 'package:faker/widgets/post/comment_reactions.dart';
import 'package:faker/widgets/post/custom_editable_text.dart';
import 'package:faker/widgets/profile/profile_pic.dart';
import 'package:faker/widgets/post/reply.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:faker/utils/ads_helper.dart';
import 'package:easy_localization/easy_localization.dart';

class CommentWidget extends StatefulWidget {
  final CommentModel comment;
  final VoidCallback onChanged;

  const CommentWidget({Key key, this.comment, this.onChanged})
      : super(key: key);

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  Ads ads;

  @override
  void initState() {
    super.initState();
    ads = new Ads();
    ads.loadInter();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ProfilePic(
          user: widget.comment.user,
          onImageChose: (val) {
            widget.comment.user.photo = val;
            widget.onChanged();
          },
        ),
        SizedBox(width: 8.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Palette.greyLight,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CustomEditableText(
                      title: 'username'.tr().replaceAll("\\n", "\n"),
                      onSubmit: (val) {
                        widget.comment.user.name = val;
                        widget.onChanged();
                      },
                      onVerifiedChange: (val) {
                        widget.comment.user.verified = val;
                        widget.onChanged();
                      },
                      text: widget.comment.user.name,
                      verified: widget.comment.user.verified,
                      textStyle: MyTextStyles.fbTitleBold,
                    ),
                    CustomEditableText(
                      title: 'comment_text'.tr().replaceAll("\\n", "\n"),
                      text: widget.comment.text,
                      multiline: true,
                      textStyle: MyTextStyles.fbText,
                      onSubmit: (text) {
                        widget.comment.text = text;
                        widget.onChanged();
                      },
                    ),
                  ],
                ),
              ),
              widget.comment.image != null
                  ? GestureDetector(
                      onTap: () async {
                        widget.comment.image =
                            await editImage() ?? widget.comment.image;
                        widget.onChanged();
                        setState(() {});
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 2.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Container(
                            height: 180.0,
                            child: Image.file(Tools.getLocalImage(widget.comment.image.path),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommentBottomRow(
                    comment: widget.comment,
                    onChanged: widget.onChanged,
                    addReply: () async {
                      if (widget.comment.replies.length < 3) {
                        addReply().then((reply) {
                          if (reply != null) widget.comment.replies.add(reply);
                          rebuild();
                          widget.onChanged();
                        });
                      } else {
                        Tools.showProDialog(context);
                      }
                    },
                    react: (bool reacted) {
                      setState(
                        () {
                          if (widget
                                  .comment.commentReactions.reactionsCount ==
                              0) {
                            widget.comment.commentReactions.reactionsCount =
                                1;
                          } else {
                            reacted
                                ? widget
                                    .comment.commentReactions.reactionsCount++
                                : widget.comment.commentReactions
                                    .reactionsCount--;
                          }
                        },
                      );
                    },
                  ),
                  widget.comment.commentReactions.reactionsCount != 0
                      ? CommentReactions(
                          comment: widget.comment,
                          onChanged: widget.onChanged,
                        )
                      : SizedBox(),
                ],
              ),
              SizedBox(
                height: widget.comment.replies == null ||
                        widget.comment.replies.length < 0
                    ? 0.0
                    : 5.0,
              ),
              widget.comment.replies == null ||
                      widget.comment.replies.length < 0
                  ? SizedBox()
                  : Column(
                      children: widget.comment.replies
                          .map(
                            (item) => ReplyWidget(
                              reply: item,
                              onChanged: widget.onChanged,
                              notify: () {
                                setState(() {});
                              },
                            ),
                          )
                          .toList()),
            ],
          ),
        ),
      ],
    );
  }

  Future<ReplyModel> addReply() async {
    ReplyModel reply = ReplyModel(
      user: new ProfileModel(
        name: 'User Name',
      ),
      text: 'Click to edit reply ✏.\n',
      elapsedTime: '15 m',
      replyReactions: ReactionsModel(
        reactionsCount: 0,
        reactions: ["like"],
      ),
    );
    File userImage;
    File replyImage;
    bool verified = false;

    TextEditingController textControllerUserName = new TextEditingController();
    TextEditingController textControllerReply = new TextEditingController();
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
            'add_new_reply'.tr().replaceAll("\\n", "\n"),
            style: MyTextStyles.bigTitleBold.apply(color: Palette.accent),
            textAlign: TextAlign.center,
          ),
          scrollable: true,
          contentPadding: EdgeInsets.all(8.0),
          content: StatefulBuilder(builder: (context, setState) {
            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                user: reply.user,
                                onImageChose: (photo) {
                                  userImage = photo;
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
                      'reply_text'.tr().replaceAll("\\n", "\n"),
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
                          controller: textControllerReply,
                          maxLines: 4,
                          keyboardType: TextInputType.multiline,
                          style: MyTextStyles.fbText,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: textControllerReply.text,
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
                                onTap: () => textControllerReply.clear(),
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
                      'reply_image'.tr().replaceAll("\\n", "\n"),
                      style: MyTextStyles.title,
                    ),
                  ),
                  //Image PlaceHolder
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: GestureDetector(
                      onTap: () async {
                        replyImage = await Tools.selectPic(context);
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
                            child: replyImage != null
                                ? Image.file(Tools.getLocalImage(replyImage.path), fit: BoxFit.cover)
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
                            reply = new ReplyModel(
                              user: new ProfileModel(
                                  name: textControllerUserName.text != ''
                                      ? textControllerUserName.text
                                      : 'username'.tr().replaceAll("\\n", "\n"),
                                  photo: userImage,
                                  otherName: 'Other Name',
                                  bio: 'bio_text'.tr().replaceAll("\\n", "\n"),
                                  verified: verified),
                              text: textControllerReply.text != ''
                                  ? textControllerReply.text
                                  : 'click_to_edit_reply'.tr().replaceAll("\\n", "\n"),
                              elapsedTime: textControllerElapsedTime.text != ''
                                  ? textControllerElapsedTime.text
                                  : 'just_now'.tr().replaceAll("\\n", "\n"),
                              replyReactions: ReactionsModel(
                                reactionsCount: int.parse(
                                    textControllerReactsCount.text != ''
                                        ? textControllerReactsCount.text
                                        : '0'),
                                reactions: ["like"],
                              ),
                              image: replyImage,
                            );
                            ads.showInter();
                            Navigator.pop(context, reply);
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

  editImage() async {
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
        widget.comment.image = null;
      } else {
        widget.comment.image =
            await Tools.selectPic(context) ?? widget.comment.image;
      }
    }
  }

  void rebuild() {
    setState(() {});
  }
}
