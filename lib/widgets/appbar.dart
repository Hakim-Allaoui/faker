import 'package:faker/utils/theme.dart';
import 'package:faker/utils/tools.dart';
import 'package:faker/widgets/pro_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

class CustomAppBar extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Widget title;
  final Widget leading;
  final Widget trailing;
  final Widget bannerAd;
  final VoidCallback showInterCallBack;

  const CustomAppBar(
      {Key key,
      this.scaffoldKey,
      this.bannerAd,
      this.title,
      this.showInterCallBack,
      this.leading,
      this.trailing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            this.bannerAd != null
                ? this.bannerAd
                : SizedBox(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(Tools.isDirectionRTL(context) ? math.pi : 0),
                    child: leading ??
                        IconButton(
                          icon: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: SvgPicture.asset(
                              'assets/icons/burger_menu.svg',
                              color: Palette.black,
                            ),
                          ),
                          onPressed: () =>
                              scaffoldKey.currentState.openDrawer(),
                        ),
                  ),
                  Expanded(
                    child: this.title,
                  ),
                  trailing ?? ProButton(background: false,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
