import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:faker/utils/theme.dart';


class CameraButton extends StatelessWidget {
  final String icon;
  final double roundedCorners;

  const CameraButton({Key key, this.icon, this.roundedCorners})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      padding: EdgeInsets.all(this.roundedCorners == 6.0 ? 8.0 : 12.0),
      height: this.roundedCorners == 6.0 ? 30.0 : 40.0,
      width: this.roundedCorners == 6.0 ? 35.0 : 40.0,
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(this.roundedCorners)),
      child: SvgPicture.asset(
        this.icon,
        width: 20.0,
        color: Colors.black,
      ),
    );
  }
}

class MainButton extends StatelessWidget {
  final String title;
  final String svgIcon;
  final Function() onClicked;

  const MainButton({Key key, this.title, this.svgIcon, this.onClicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Palette.facebookBlue,
          borderRadius: BorderRadius.circular(14.0),
          boxShadow: [
            BoxShadow(
                color: Palette.facebookBlue,
                blurRadius: 2.0,
                offset: Offset(0.0, 1.0))
          ]),
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: EdgeInsets.all(20.0),
        onPressed: this.onClicked,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              this.title,
              style: MyTextStyles.title,
            ),
            SvgPicture.asset(
              this.svgIcon,
              width: 30.0,
            )
          ],
        ),
      ),
    );
  }
}

class BlueButton extends StatelessWidget {
  final String title;
  final String svgIcon;

  const BlueButton({Key key, this.title, this.svgIcon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35.0,
      decoration: BoxDecoration(
        color: Palette.facebookNewBlue,
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: SvgPicture.asset(
              this.svgIcon,
              height: 16.0,
              color: Colors.white,
            ),
          ),
          Text(
            this.title,
            style: MyTextStyles.fbSubTitleBold
                .apply(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class GreyButton extends StatelessWidget {
  final String svgIcon;

  const GreyButton({Key key, this.svgIcon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35.0,
      width: 50.0,
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: Palette.greyLight,
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: SvgPicture.asset(
        this.svgIcon,
        color: Colors.black,
      ),
    );
  }
}
