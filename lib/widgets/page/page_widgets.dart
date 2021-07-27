import 'package:faker/utils/strings.dart';
import 'package:faker/utils/theme.dart';
import 'package:faker/widgets/profile/profile_details.dart';
import 'package:flutter/material.dart';

class AboutSection extends StatefulWidget {
  @override
  _AboutSectionState createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('About',
                    style: MyTextStyles.titleBold
                        .apply(color: Colors.black)),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.edit,
                      color: Palette.facebookBlue,
                      size: 15.0,
                    ),
                    Text(
                      'Suggest edits',
                      style: MyTextStyles.fbText
                          .apply(color: Palette.facebookBlue),
                    )
                  ],
                )
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ProfileDetails(
                  details: {
                    Strings.labelIconsDetails[0]: "New York",
                    Strings.labelIconsDetails[1]: "University Oxford",
                    Strings.labelIconsDetails[2]: "Page",
                    Strings.labelIconsDetails[3]: "Facebook",
                    Strings.labelIconsDetails[4]: "Someone",
                    Strings.labelIconsDetails[5]: "Casablanca, Morocco",
                    Strings.labelIconsDetails[6]: "10 000 000 people",
                  },
                  onChanged: (key, val) {
                    /*profile.details[key] = val;
                    setState(() {
                      state = 'unsaved';
                    });*/
                  },
                ),
              ),
            ),
          ),
          Column(
            children: <Widget>[
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'See All',
                    style: MyTextStyles.fbText,
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Palette.greyDark,
                    size: 15.0,
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}