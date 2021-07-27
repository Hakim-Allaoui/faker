import 'package:auto_direction/auto_direction.dart';
import 'package:faker/utils/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';

class CustomEditableText extends StatefulWidget {
  final TextStyle textStyle;
  final String title;
  final String text;
  final bool multiline;
  final TextAlign textAlign;
  final bool verified;
  final Function(String) onSubmit;
  final Function(bool) onVerifiedChange;

  const CustomEditableText(
      {Key key,
      this.textStyle,
      this.text = '',
      this.title = 'Edit',
      this.multiline = false,
      this.textAlign = TextAlign.start,
      this.onSubmit,
      this.verified,
      this.onVerifiedChange})
      : super(key: key);

  @override
  _CustomEditableTextState createState() => _CustomEditableTextState();
}

class _CustomEditableTextState extends State<CustomEditableText> {
  String text;
  bool verified;
  TextEditingController textController = new TextEditingController();

  void editText() async {
    final result = await showDialog<String>(
        barrierDismissible: false,
        context: context,
        builder: (context) => WillPopScope(
              onWillPop: () {
                // ads.showInter(); //Interstitial
                return Future.value(true);
              },
              child: StatefulBuilder(builder: (context, dialogSetState) {
                return Scaffold(
                  resizeToAvoidBottomPadding: true,
                  backgroundColor: Colors.transparent,
                  // shadowColor: Colors.transparent,
                  body: Container(
                    height: MediaQuery.of(context).size.height,
                    color: Colors.transparent,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.all(8.0),
                              padding: EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                              ),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Icon(
                                        Icons.clear,
                                        color: Colors.transparent,
                                      ),
                                      Text(
                                        widget.title,
                                        style: MyTextStyles.titleBold
                                            .apply(color: Colors.black),
                                      ),
                                      InkWell(
                                        child: InkWell(
                                          child: Icon(
                                            Icons.clear,
                                            color: Colors.black,
                                          ),
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          decoration: BoxDecoration(
                                            color: Palette.greyLight,
                                            borderRadius: BorderRadius.circular(
                                                widget.multiline
                                                    ? 20.0
                                                    : 100.0),
                                          ),
                                          child: Center(
                                            child: AutoDirection(
                                              text: textController.text,
                                              child: TextField(
                                                controller: textController,
                                                onChanged: (str){
                                                  dialogSetState(() {});
                                                },
                                                maxLines:
                                                    widget.multiline ? 5 : 1,
                                                keyboardType: widget.multiline
                                                    ? TextInputType.multiline
                                                    : TextInputType.text,
                                                style: MyTextStyles.fbText,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: text,
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
                                                      onTap: () =>
                                                          textController
                                                              .clear(),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      widget.verified != null
                                          ? Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0,
                                                          right: 8.0,
                                                          left: 8.0,
                                                          bottom: 2.0),
                                                  child: Text(
                                                    'verified'.tr().replaceAll("\\n", "\n"),
                                                    style: TextStyle(
                                                        color: Palette.accent),
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: SvgPicture.asset(
                                                    'assets/icons/verified_badge.svg',
                                                    width: 30.0,
                                                    color: verified
                                                        ? Palette.accent
                                                        : Palette.greyLight,
                                                  ),
                                                  onPressed: () {
                                                    verified = !verified;
                                                    setState(() {});
                                                    dialogSetState(() {});
                                                  },
                                                ),
                                              ],
                                            )
                                          : SizedBox(),
                                    ],
                                  ),
                                  InkWell(
                                    onTap: () {
                                      if (widget.onSubmit != null) {
                                        setState(() {
                                          if (textController.text.isNotEmpty)
                                            widget
                                                .onSubmit(textController.text);
                                        });
                                      }
                                      if (widget.onVerifiedChange != null) {
                                        setState(() {
                                          widget.onVerifiedChange(verified);
                                        });
                                      }
                                      // ads.showInter(); //Interstitial
                                      Navigator.pop(
                                          context, textController.text);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(5.0),
                                      margin: EdgeInsets.only(top: 15.0),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                        color: Colors.black,
                                      ),
                                      child: Icon(
                                        Icons.done,
                                        color: Colors.white,
                                        size: 20.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ));

    if (result != null && result != '') {
//      if (mounted) {
      if (!mounted) return;
      setState(() => text = result);
//      } else {
//        print('Not mounted yet');
//      }
    }
  }

  @override
  void initState() {
    super.initState();
    text = widget.text;
    verified = widget.verified ?? false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        editText();
      },
      child: widget.verified == null
          ? AutoDirection(
              text: text,
              child: Text(
                text,
                style: widget.textStyle,
                textAlign: widget.textAlign,
                overflow: TextOverflow.ellipsis,
                maxLines: 7,
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AutoDirection(
                  text: text,
                  child: Text(
                    text,
                    style: widget.textStyle,
                    textAlign: widget.textAlign,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 7,
                  ),
                ),
                SizedBox(
                  width: 4.0,
                ),
                verified
                    ? SvgPicture.asset(
                        'assets/icons/verified_badge.svg',
                        width: 12.0,
                      )
                    : SizedBox(),
              ],
            ),
    );
  }
}
