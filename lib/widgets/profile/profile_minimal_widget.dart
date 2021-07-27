import 'package:faker/models/profile_model.dart';
import 'package:faker/utils/theme.dart';
import 'package:faker/utils/tools.dart';
import 'package:faker/widgets/profile/profile_pic.dart';
import 'package:flutter/material.dart';

class ProfileMiniWidget extends StatelessWidget {
  const ProfileMiniWidget({
    Key key,
    @required this.profile,
  }) : super(key: key);

  final ProfileModel profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Stack(
              fit: StackFit.expand,
              overflow: Overflow.visible,
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  child: Image.file(
                    Tools.getCoverLocalImage(profile.cover?.path),
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: -40.0,
                  child: Container(
                    margin: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.circular(100.0),
                    ),
                    child: Container(
                      margin:
                      EdgeInsets.all(profile.hasStory ? 2.0 : 0.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(100.0),
                        border: Border.all(
                            color: profile.hasStory
                                ? Palette.facebookNewBlue
                                : Colors.transparent,
                            width: profile.hasStory ? 1.5 : 0.0),
                      ),
                      child: Container(
                        margin: EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius:
                          BorderRadius.circular(100.0),
                        ),
                        child: ClipRRect(
                          borderRadius:
                          BorderRadius.circular(100.0),
                          child: ProfilePic(
                            user: profile,
                            size: 60,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Text(profile.name, style: MyTextStyles.fbTitle,),
            ),
          )
        ],
      ),
    );
  }
}
