import 'package:faker/models/post_model.dart';
import 'package:faker/utils/theme.dart';
import 'package:faker/utils/tools.dart';
import 'package:faker/widgets/post/post_pictures.dart';
import 'package:flutter/material.dart';

class PostMiniWidget extends StatelessWidget {
  const PostMiniWidget({
    Key key,
    @required this.post,
  }) : super(key: key);

  final PostModel post;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        post.images.isNotEmpty
            ? Opacity(
                opacity: 0.5,
                child: PostPictures(listImages: post.images),
              )
            : Center(
                child: Opacity(
                  opacity: 0.3,
                  child: Image.asset(
                    'assets/icon.png',
                    width: 80.0,
                  ),
                ),
              ),
        Positioned(
          top: 5.0,
          left: 5.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 30.0,
                width: 30.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 2.0,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: Image.file(
                    Tools.getLocalImage(post.user.photo?.path),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                width: 5.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post.user.name,
                      style:
                          MyTextStyles.fbTitleBold.apply(fontSizeFactor: 0.8)),
                  Text(post.elapsedTime,
                      style: MyTextStyles.fbText.apply(fontSizeFactor: 0.8)),
                ],
              )
            ],
          ),
        ),
        Align(
            alignment: Alignment.center,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 40.0, horizontal: 2.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 90.0,
                    child: Center(
                      child: Text(
                        post.text,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.fade,
                        style: MyTextStyles.fbText.apply(fontSizeFactor: 0.8),
                      ),
                    ),
                  ),
                  Text( post.comments.length == 0 ? 'No comment' :
                    '${post.comments.length} Comment${post.comments.length > 1 ? 's':''}',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.fade,
                    style: MyTextStyles.fbTitleBold.apply(fontSizeFactor: 0.8),
                  ),
                ],
              ),
            ))
      ],
    );
  }
}
