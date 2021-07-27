import 'dart:io';

import 'package:faker/models/profile_model.dart';
import 'package:faker/utils/theme.dart';
import 'package:faker/utils/tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfilePic extends StatefulWidget {
  final ProfileModel user;
  final double size;
  final Function(File) onImageChose;

  const ProfilePic({Key key, this.user, this.size = 40.0, this.onImageChose})
      : super(key: key);

  @override
  _ProfilePicState createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.size,
      width: widget.size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Palette.greyLight,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100.0),
        child: GestureDetector(
          onTap: () async {
            widget.user.photo = await Tools.selectPic(context) ??
                widget.user.photo ??
                await Tools.getImageFileFromAssets('assets/images/profile.png');
            setState(() {});
            if (widget.onImageChose != null)
              widget.onImageChose(widget.user.photo);
          },
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              widget.user != null && widget.user.photo != null
                  ? Image.file(
                      Tools.getLocalImage(widget.user.photo.path),
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/images/profile.png',
                      fit: BoxFit.cover,
                    ),
              widget.user.verified && widget.size == Tools.width / 2
                  ? Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: widget.size * 0.15,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.black54, Colors.transparent],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter),
                        ),
                      ),
                    )
                  : SizedBox(),
              widget.user.verified && widget.size == Tools.width / 2
                  ? Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: SvgPicture.asset(
                          'assets/icons/profile/guard.svg',
                          width: widget.size * 0.1,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
