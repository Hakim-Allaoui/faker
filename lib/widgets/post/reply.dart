import 'package:faker/models/reply_model.dart';
import 'package:faker/utils/theme.dart';
import 'package:faker/utils/tools.dart';
import 'package:faker/widgets/post/custom_editable_text.dart';
import 'package:faker/widgets/profile/profile_pic.dart';
import 'package:faker/widgets/post/reply_bottom_row.dart';
import 'package:faker/widgets/post/reply_reactions.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ReplyWidget extends StatefulWidget {
  final ReplyModel reply;
  final VoidCallback notify;
  final VoidCallback onChanged;

  const ReplyWidget({Key key, this.reply, this.notify, this.onChanged}) : super(key: key);
  @override
  _ReplyWidgetState createState() => _ReplyWidgetState();
}

class _ReplyWidgetState extends State<ReplyWidget> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: <Widget>[
            ProfilePic(
              user: widget.reply.user,
              onImageChose: (val) {
                widget.reply.user.photo = val;
                widget.onChanged();
              },
              size: 30.0,
            ),
            SizedBox(width: 8.0),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Palette.greyLight,
                        borderRadius:
                        BorderRadius.circular(
                            15.0),
                      ),
                      child: Container(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                          children: <Widget>[
                            CustomEditableText(
                              title: 'username'.tr().replaceAll("\\n", "\n"),
                              onSubmit: (val) {
                                widget.reply.user.name = val;
                                widget.onChanged();
                              },
                              onVerifiedChange: (val) {
                                widget.reply.user.verified = val;
                                widget.onChanged();
                              },
                              text: widget.reply.user.name,
                              verified: widget.reply.user.verified,
                              textStyle: MyTextStyles.fbTitleBold,
                            ),
                            CustomEditableText(
                              title: 'reply_text'.tr().replaceAll("\\n", "\n"),
                              onSubmit: (v) {
                                widget.reply.text = v;
                                widget.onChanged();
                              },
                              text: widget.reply.text,
                              multiline: true,
                              textStyle: MyTextStyles.fbText,
                            ),
                          ],
                        ),
                      ),
                    ),
                    widget.reply.image != null
                        ? GestureDetector(
                      onTap: () async {
                        widget.reply.image = await editImage() ?? widget.reply.image;
                        setState(() {});
                        widget.onChanged();
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 2.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Container(
                            height: 150.0,
                            child: Image.file(
                              Tools.getLocalImage(widget.reply.image.path),
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
                        ReplyBottomRow(
                          reply: widget.reply,
                          onChanged: widget.onChanged,
                          react: (bool reacted) {
                            setState(() {
                              if (widget.reply.replyReactions.reactionsCount == 0) {
                                widget.reply.replyReactions.reactionsCount = 1;
                              } else {
                                reacted
                                    ? widget.reply.replyReactions.reactionsCount++
                                    : widget.reply.replyReactions.reactionsCount--;
                              }
                            });
                          },
                        ),
                        ReplyReactions(
                          reply: widget.reply,
                          onChanged: widget.onChanged,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ],
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

    if(edit != null) {
      if(edit == false) {
        widget.reply.image = null;
      } else {
        widget.reply.image = await Tools.selectPic(context) ?? widget.reply.image;
      }
    }
  }

}
