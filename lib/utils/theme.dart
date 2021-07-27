import 'package:flutter/material.dart';

class Palette{
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color scaffold = Color(0xFFF0F2F5);

  static const Color facebookBlue = Color(0xFF4267B2);
  static const Color facebookNewBlue = Color(0xff0884FF);

  static const Color gradient1 = Color(0xff0884FF);
  static const Color gradient2 = Color(0xff9D35FF);
  static const Color gradient3 = Color(0xFFFF6868);

  static const Color secondary = Color(0xff9D35FF);
  static const Color third = Color(0xFFFF6868);

  static const List<Color> gradientColors2 = [gradient1, gradient2, gradient3];
  static const List<Color> gradientColors1 = [rose, move];


  static const Color greyDark = Color(0XFF8A8D92);
  static const Color greyDarken = Color(0XFF231F20);
  static const Color greyLight = Color(0XFFF1F3F4);


  static Color accent = Color(0XFF3D5896);

  static const Color online = Color(0xFF4BCB1F);
  static const Color rose = Color(0xFFCE48B1);
  static const Color move = Color(0xFF496AE1);



  static LinearGradient storyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Colors.black26],
    // colors: [Colors.transparent, Colors.black26],
  );

}

class MyTextStyles{
  static const TextStyle bigTitleBold = TextStyle(
    color: Palette.black,
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    fontFamily: 'San Fransisco'
  );
  static const TextStyle titleBold = TextStyle(
    color: Palette.black,
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle subTitleBold = TextStyle(
    color: Palette.black,
    fontSize: 12.0,
    fontWeight: FontWeight.bold,
  );

  //Normal
  static const TextStyle bigTitle = TextStyle(
    color: Palette.black,
    fontSize: 16.0,
  );
  static const TextStyle title = TextStyle(
    color: Palette.black,
    fontSize: 14.0,
  );
  static const TextStyle subTitle = TextStyle(
    color: Palette.black,
    fontSize: 12.0,
  );

  //Thin
  static const TextStyle bigTitleThin = TextStyle(
    color: Palette.black,
    fontSize: 14.0,
    fontWeight: FontWeight.w100,
  );
  static const TextStyle titleThin = TextStyle(
    color: Palette.black,
    fontSize: 14.0,
    fontWeight: FontWeight.w100,
  );
  static const TextStyle subTitleThin = TextStyle(
    color: Palette.black,
    fontSize: 12.0,
    fontWeight: FontWeight.w100,
  );

  static const TextStyle fbTitleBigBold = TextStyle(
    fontFamily: 'San Fransisco',
    fontWeight: FontWeight.bold,
    fontSize: 16.0,
  );
  static const TextStyle fbTitleBold = TextStyle(
    fontFamily: 'San Fransisco',
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );
  static const TextStyle fbTitle = TextStyle(
    fontFamily: 'San Fransisco',
    fontSize: 14.0,
  );
  static const TextStyle fbSubTitleBold = TextStyle(
    fontFamily: 'San Fransisco',
    fontWeight: FontWeight.w700,
    fontSize: 12.0,
  );
  static const TextStyle fbText = TextStyle(
    fontFamily: 'San Fransisco',
    fontSize: 14.0,
  );
}