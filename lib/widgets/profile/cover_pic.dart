import 'dart:io';

import 'package:faker/models/profile_model.dart';
import 'package:faker/utils/tools.dart';
import 'package:flutter/material.dart';

class CoverPic extends StatefulWidget {
  final ProfileModel user;
  final VoidCallback onClicked;

  final Function(File) onImageChose;

  const CoverPic({Key key, this.user, this.onClicked, this.onImageChose}) : super(key: key);

  @override
  _CoverPicState createState() => _CoverPicState();
}

class _CoverPicState extends State<CoverPic> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        onTap: () async {
          widget.user.cover = await Tools.selectPic(context) ??
              widget.user.cover ?? await Tools.getImageFileFromAssets('assets/images/blank.png');
          setState(() {});
          if (widget.onImageChose != null) widget.onImageChose(widget.user.cover);
        },
        child: widget.user != null && widget.user.cover != null
            ? Image.file(Tools.getLocalImage(widget.user.cover.path),
          fit: BoxFit.cover,
        )
            : Image.asset(
          'assets/images/blank.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}