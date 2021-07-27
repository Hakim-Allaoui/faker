import 'dart:io';

import 'package:faker/models/reactions_model.dart';
import 'package:faker/models/reply_model.dart';
import 'package:faker/models/profile_model.dart';

class CommentModel {
  ProfileModel user;
  String text;
  File image;
  String elapsedTime;
  ReactionsModel commentReactions;
  List<ReplyModel> replies;

  CommentModel({this.user, this.text = 'Click to add reply text here 📝.', this.image,
    this.elapsedTime = '10m', this.commentReactions, this.replies});

  Map<String, dynamic> toJson() {
    return {
      "user": this.user.toJson(),
      "text": this.text,
      "image": this.image?.path,
      "elapsedTime": this.elapsedTime,
      "commentReactions": this.commentReactions.toJson(),
      "replies": this.replies.map((e) => e?.toJson()).toList(),
    };
  }

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      user: ProfileModel.fromJson(json["user"]),
      text: json["text"],
      image: json["image"] != null ? File(json["image"]) : null,
      elapsedTime: json["elapsedTime"],
      commentReactions: ReactionsModel.fromJson(json["commentReactions"]),
      replies: List.of(json["replies"])
          .map((i) => ReplyModel.fromJson(i) /* can't generate it properly yet */)
          .toList(),
    );
  }
//
}
