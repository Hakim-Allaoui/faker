import 'package:faker/utils/strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:faker/utils/theme.dart';
import 'package:faker/utils/tools.dart';
import 'package:flutter/material.dart';


class RatingDialog extends StatefulWidget {
  @override
  _RatingDialogState createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  int _stars = 0;

  Widget _buildStar(int starCount) {
    return InkWell(
      child: Icon(
        _stars >= starCount ? Icons.star : Icons.star_border,
        size: 30.0,
        color: _stars >= starCount ? Colors.orange : Colors.grey,
      ),
      onTap: () {
        print(starCount);
        if (starCount >= 4) {
          Navigator.pop(context);
          var url =
              'https://play.google.com/store/apps/details?id=' +
                  Strings.packageName;
          Tools.launchURL(url);
        }
        setState(() {
          _stars = starCount;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  height: 80,
                  width: 80,
                  child: Image.asset('assets/icon.png'),
                ),
                SizedBox(width: 10.0,),
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Tools.packageInfo.appName,
                          style: MyTextStyles.titleBold.apply(color: Palette.facebookBlue),
                        ),
                        Text(
                          'version'.tr() + ' ${Tools.packageInfo.version}(${Tools.packageInfo.buildNumber})',
                          style: MyTextStyles.subTitle,
                        ),
                      ],
                    ))
              ],
            ),
            SizedBox(height: 20.0,),
            Text('rating_dialog'.tr().replaceAll("\\n", "\n"), textAlign: TextAlign.center, style: MyTextStyles.subTitle,),
          ],
        ),
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildStar(1),
          _buildStar(2),
          _buildStar(3),
          _buildStar(4),
          _buildStar(5),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('cancel'.tr().replaceAll("\\n", "\n"), style: MyTextStyles.titleBold.apply(color: Palette.gradient1),),
          onPressed: () {
            Navigator.pop(context, 0);
          },
        ),
        FlatButton(
          child: Text('ok'.tr().replaceAll("\\n", "\n"), style: MyTextStyles.titleBold.apply(color: Palette.gradient3),),
          onPressed: () {
            Navigator.of(context).pop(_stars);
          },
        )
      ],
    );
  }
}