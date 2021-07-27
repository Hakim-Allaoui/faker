import 'package:faker/models/comment_model.dart';
import 'package:faker/utils/theme.dart';
import 'package:faker/utils/tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';

class CommentReactions extends StatefulWidget {
  final CommentModel comment;
  final VoidCallback onChanged;

  const CommentReactions({Key key, this.comment, this.onChanged})
      : super(key: key);

  @override
  _CommentReactionsState createState() => _CommentReactionsState();
}

class _CommentReactionsState extends State<CommentReactions> {
  List<String> reactionsList = [
    "like",
    "love",
    "care",
    "haha",
    "wow",
    "sad",
    "angry"
  ];

  List<bool> reactState = [];

  TextEditingController textControllerReactNb = new TextEditingController();

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 7; i++) {
      if (!widget.comment.commentReactions.reactions.contains(reactionsList[i]))
        reactState.add(false);
      else
        reactState.add(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                contentPadding: EdgeInsets.all(4.0),
                title: Column(
                  children: [
                    Text(
                      'reactions'.tr().replaceAll("\\n", "\n"),
                      style: MyTextStyles.bigTitleBold
                          .apply(color: Palette.accent),
                      textAlign: TextAlign.center,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '*',
                            style: MyTextStyles.subTitleBold
                                .apply(color: Colors.red),
                          ),
                          Text(
                            'hold_and_drag_to_sort_reacts'.tr().replaceAll("\\n", "\n"),
                            style: MyTextStyles.subTitle
                                .apply(color: Palette.accent),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '*',
                            style: MyTextStyles.subTitleBold
                                .apply(color: Colors.red),
                          ),
                          Text(
                            'reacts_max_selection_is'.tr().replaceAll("\\n", "\n"),
                            style: MyTextStyles.subTitle
                                .apply(color: Palette.accent),
                          ),
                          Text(
                            '3',
                            style: MyTextStyles.subTitleBold
                                .apply(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                content: StatefulBuilder(builder: (context, dialogSetState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        height: 50.0,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100.0),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black54,
                                  offset: Offset(0.0, 2.0),
                                  blurRadius: 2.0)
                            ]),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100.0),
                          child: ReorderableListView(
                            scrollDirection: Axis.horizontal,
                            onReorder: (int start, int current) {
                              dialogSetState(() {
                                _updateItems(start, current);
                                _updateReactions();
                                widget.onChanged();
                              });
                            },
                            children: reactionsList
                                .map(
                                  (item) => InkWell(
                                    key: Key('$item'),
                                    onTap: () {
                                      if (!reactState[
                                              reactionsList.indexOf(item)] ||
                                          widget.comment.commentReactions
                                                  .reactions.length >
                                              0) {
                                        if ((widget.comment.commentReactions
                                                    .reactions.length <
                                                3 ||
                                            reactState[
                                                reactionsList.indexOf(item)])) {
                                          dialogSetState(() {
                                            reactState[reactionsList
                                                    .indexOf(item)] =
                                                !reactState[reactionsList
                                                    .indexOf(item)];
                                            if (reactState[
                                                reactionsList.indexOf(item)])
                                              widget.comment.commentReactions
                                                  .reactionsCount++;
                                            else if (widget
                                                    .comment
                                                    .commentReactions
                                                    .reactionsCount >
                                                0)
                                              widget.comment.commentReactions
                                                  .reactionsCount--;
                                          });
                                          widget.onChanged();
                                        }
                                      }
                                      _updateReactions();
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.all(4.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                          ),
                                          child: Opacity(
                                            opacity: reactState[
                                                    reactionsList.indexOf(item)]
                                                ? 1.0
                                                : 0.6,
                                            child: SvgPicture.asset(
                                                'assets/icons/reactions/$item.svg',
                                                height: 40),
                                          ),
                                        ),
                                        reactState[reactionsList.indexOf(item)]
                                            ? Container(
                                                height: 2.0,
                                                width: 40.0,
                                                color: Palette.facebookBlue,
                                              )
                                            : SizedBox(),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Text(
                         'reactions_count'.tr().replaceAll("\\n", "\n"),
                        style: MyTextStyles.title,
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
                              controller: textControllerReactNb,
                              maxLines: 1,
                              keyboardType: TextInputType.number,
                              style: MyTextStyles.fbText,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: widget
                                    .comment.commentReactions.reactionsCount
                                    .toString(),
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
                                    onTap: () => textControllerReactNb.clear(),
                                  ),
                                ),
                              ),
                              onChanged: (count) {
                                widget.comment.commentReactions.reactionsCount =
                                    int.parse(count);
                                rebuild();
                                widget.onChanged();
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
                actions: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: SizedBox(),
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
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                'ok'.tr().replaceAll("\\n", "\n"),
                                style: MyTextStyles.titleBold
                                    .apply(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            });
      },
      child: widget.comment.commentReactions.reactionsCount == 0
          ? SizedBox()
          : Container(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 6.0),
                    child: Text(
                      NumberFormat.compactCurrency(decimalDigits: 0, symbol: '')
                          .format(
                              widget.comment.commentReactions.reactionsCount)
                          .toString(),
                      style: MyTextStyles.fbText.apply(color: Palette.greyDark),
                    ),
                  ),
                  widget.comment.commentReactions.reactions.isEmpty
                      ? SizedBox()
                      : Container(
                          child: Stack(
                            alignment: !Tools.isDirectionRTL(context)
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                            children: widget
                                .comment.commentReactions.reactions.reversed
                                .map((item) {
                              return Container(
                                margin: EdgeInsets.only(
                                    left: !Tools.isDirectionRTL(context) ? widget.comment.commentReactions.reactions
                                        .indexOf(item)
                                        .toDouble() *
                                        14.0 : 0,
                                  right: Tools.isDirectionRTL(context) ? widget.comment.commentReactions.reactions
                                      .indexOf(item)
                                      .toDouble() *
                                      14.0 : 0,
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(100.0),
                                    border: Border.all(
                                        color: Colors.white, width: 2.0)),
                                child: SvgPicture.asset(
                                    'assets/icons/reactions/$item.svg',
                                    height: 15),
                              );
                            }).toList(),
                          ),
                        ),
                ],
              ),
            ),
    );
  }

  void _updateItems(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final item = reactionsList.removeAt(oldIndex);
    reactionsList.insert(newIndex, item);
    final checkItem = reactState.removeAt(oldIndex);
    reactState.insert(newIndex, checkItem);
  }

  void _updateReactions() {
    setState(() {
      widget.comment.commentReactions.reactions.clear();
      for (int i = 0; i < reactionsList.length; i++) {
        if (reactState[i])
          widget.comment.commentReactions.reactions.add(reactionsList[i]);
      }
    });
    print('======> ${widget.comment.commentReactions.reactions}');
  }

  void rebuild() {
    setState(() {});
  }
}
