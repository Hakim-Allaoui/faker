import 'package:faker/models/post_model.dart';
import 'package:faker/utils/theme.dart';
import 'package:faker/utils/tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:faker/utils/ads_helper.dart';
import 'package:easy_localization/easy_localization.dart';

class PostReactionsWidget extends StatefulWidget {
  final PostModel post;
  final VoidCallback onChanged;

  const PostReactionsWidget({Key key, this.post, this.onChanged})
      : super(key: key);

  @override
  _PostReactionsWidgetState createState() => _PostReactionsWidgetState();
}

class _PostReactionsWidgetState extends State<PostReactionsWidget> {
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
  TextEditingController textControllerComNb = new TextEditingController();
  TextEditingController textControllerShrNb = new TextEditingController();

  Ads ads;

  @override
  void initState() {
    super.initState();
    ads = new Ads();
    ads.loadInter();

    for (int i = 0; i < 7; i++) {
      if (!widget.post.postReactions.reactions.contains(reactionsList[i]))
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
            return WillPopScope(
              onWillPop: () {
                return Future.value(false);
              },
              child: AlertDialog(
                contentPadding: EdgeInsets.all(4.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                title: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
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
                ),
                content: StatefulBuilder(
                  builder: (context, dialogSetState) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            height: 50.0,
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
                                  });
                                  widget.onChanged();
                                },
                                children: reactionsList
                                    .map(
                                      (item) => InkWell(
                                        key: Key('$item'),
                                        onTap: () {
                                          if (!reactState[reactionsList
                                                  .indexOf(item)] ||
                                              widget.post.postReactions
                                                      .reactions.length >
                                                  0) {
                                            if ((widget.post.postReactions
                                                        .reactions.length <
                                                    3 ||
                                                reactState[reactionsList
                                                    .indexOf(item)])) {
                                              dialogSetState(() {
                                                reactState[reactionsList
                                                        .indexOf(item)] =
                                                    !reactState[reactionsList
                                                        .indexOf(item)];
                                                if (reactState[reactionsList
                                                    .indexOf(item)]) {
                                                  widget.post.postReactions
                                                      .reactionsCount++;
                                                } else {
                                                  if (widget.post.postReactions
                                                          .reactionsCount >
                                                      0) {
                                                    widget.post.postReactions
                                                        .reactionsCount--;
                                                  }
                                                }
                                                _updateReactions();
                                                widget.onChanged();
                                              });
                                            }
                                          }
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              padding: EdgeInsets.all(4.0),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        100.0),
                                              ),
                                              child: reactState[reactionsList
                                                      .indexOf(item)]
                                                  ? SvgPicture.asset(
                                                      'assets/icons/reactions/$item.svg',
                                                      height: 40)
                                                  : Opacity(
                                                      opacity: 0.6,
                                                      child: SvgPicture.asset(
                                                          'assets/icons/reactions/$item.svg',
                                                          height: 40),
                                                    ),
                                            ),
                                            if (reactState[
                                                reactionsList.indexOf(item)])
                                              Container(
                                                height: 2.0,
                                                width: 40.0,
                                                color: Palette.facebookBlue,
                                              ),
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
                                  controller: textControllerReactNb,
                                  maxLines: 1,
                                  keyboardType: TextInputType.number,
                                  style: MyTextStyles.fbText,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: widget
                                        .post.postReactions.reactionsCount
                                        .toString(),
                                    hintStyle: TextStyle(color: Colors.grey),
                                    suffix: InkWell(
                                      onTap: () =>
                                          textControllerReactNb.clear(),
                                      child: Container(
                                        padding: EdgeInsets.all(5.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                          color: Colors.black,
                                        ),
                                        child: Icon(
                                          Icons.clear,
                                          color: Colors.white,
                                          size: 10.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  onChanged: (val) {
                                    dialogSetState(() {
                                      widget.post.postReactions.reactionsCount =
                                          int.parse((val));
                                    });
                                    rebuild();
                                    widget.onChanged();
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 4.0,
                          ),
                          Text(
                            'comments_count'.tr().replaceAll("\\n", "\n"),
                            style: MyTextStyles.title,
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
                                  controller: textControllerComNb,
                                  maxLines: 1,
                                  keyboardType: TextInputType.number,
                                  style: MyTextStyles.fbText,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: widget
                                        .post.postReactions.commentsCount
                                        .toString(),
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
                                            textControllerComNb.clear(),
                                      ),
                                    ),
                                  ),
                                  onChanged: (val) {
                                    dialogSetState(() {
                                      widget.post.postReactions.commentsCount =
                                          int.parse((val));
                                    });
                                    rebuild();
                                    widget.onChanged();
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 4.0,
                          ),
                          Text(
                            'share_count'.tr().replaceAll("\\n", "\n"),
                            style: MyTextStyles.title,
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
                                  controller: textControllerShrNb,
                                  maxLines: 1,
                                  keyboardType: TextInputType.number,
                                  style: MyTextStyles.fbText,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: widget
                                        .post.postReactions.sharesCount
                                        .toString(),
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
                                            textControllerShrNb.clear(),
                                      ),
                                    ),
                                  ),
                                  onChanged: (val) {
                                    dialogSetState(() {
                                      widget.post.postReactions.sharesCount =
                                          int.parse((val));
                                    });
                                    rebuild();
                                    widget.onChanged();
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                actions: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
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
                              onPressed: () {
                                // ads.showInter(); //Interstitial
                                Navigator.pop(context);
                              },
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
              ),
            );
          },
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          widget.post.postReactions.reactionsCount == 0
              ? SizedBox(
                  height: 10.0,
                )
              : widget.post.postReactions.reactions.isEmpty
                  ? SizedBox()
                  : Row(
                      children: <Widget>[
                        Container(
                          child: Stack(
                            alignment: !Tools.isDirectionRTL(context)
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                            children: widget
                                .post.postReactions.reactions.reversed
                                .map((item) {
                              return Container(
                                margin: EdgeInsets.only(
                                  left: !Tools.isDirectionRTL(context) ? widget.post.postReactions.reactions
                                          .indexOf(item)
                                          .toDouble() *
                                      16.0 : 0,
                                  right: Tools.isDirectionRTL(context) ? widget.post.postReactions.reactions
                                          .indexOf(item)
                                          .toDouble() *
                                      16.0 : 0,
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(100.0),
                                    border: Border.all(
                                        color: Colors.white, width: 2.0)),
                                child: SvgPicture.asset(
                                    'assets/icons/reactions/$item.svg',
                                    height: 18),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(
                          width: 4.0,
                        ),
                        Text(
                          NumberFormat.compactCurrency(
                                  decimalDigits: 0, symbol: '')
                              .format(widget.post.postReactions.reactionsCount)
                              .toString(),
                          style: MyTextStyles.fbText
                              .apply(color: Palette.greyDark),
                        ),
                      ],
                    ),
          Row(
            children: <Widget>[
              Row(
                children: <Widget>[
                  widget.post.postReactions.commentsCount == 0
                      ? SizedBox()
                      : Text(
                          (widget.post.postReactions.commentsCount == 1 ||
                                      widget.post.postReactions.commentsCount ==
                                              2 &&
                                          Tools.isDirectionRTL(context)
                                  ? ''
                                  : NumberFormat.compactCurrency(
                                          decimalDigits: 0, symbol: '')
                                      .format(widget
                                          .post.postReactions.commentsCount)
                                      .toString()) +
                              (' '+'comment'.plural(
                                  widget.post.postReactions.commentsCount)),
                          style: MyTextStyles.fbText
                              .apply(color: Palette.greyDark),
                        ),
                  widget.post.postReactions.sharesCount == 0
                      ? SizedBox()
                      : Text(
                          (widget.post.postReactions.commentsCount == 0
                                  ? ''
                                  : ' • ') +
                              (widget.post.postReactions.sharesCount == 1 ||
                                      widget.post.postReactions.sharesCount ==
                                              2 &&
                                          Tools.isDirectionRTL(context)
                                  ? ''
                                  : NumberFormat.compactCurrency(
                                          decimalDigits: 0, symbol: '')
                                      .format(
                                          widget.post.postReactions.sharesCount)
                                      .toString()) +
                              (' '+'share'.plural(
                                  widget.post.postReactions.sharesCount)),
                          style: MyTextStyles.fbText
                              .apply(color: Palette.greyDark),
                        ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  void _updateItems(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = reactionsList.removeAt(oldIndex);
      reactionsList.insert(newIndex, item);
      final checkItem = reactState.removeAt(oldIndex);
      reactState.insert(newIndex, checkItem);
    });
  }

  void _updateReactions() {
    setState(() {
      widget.post.postReactions.reactions.clear();
      for (int i = 0; i < reactionsList.length; i++) {
        if (reactState[i])
          widget.post.postReactions.reactions.add(reactionsList[i]);
      }
    });
    print('==============> ${widget.post.postReactions.reactions}');
  }

  void rebuild() {
    setState(() {});
  }
}
