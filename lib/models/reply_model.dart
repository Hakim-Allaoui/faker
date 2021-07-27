import 'dart:io';

import 'package:faker/models/reactions_model.dart';
import 'package:faker/models/profile_model.dart';
class ReplyModel {
  ProfileModel user;
  String text;
  File image;
  String elapsedTime;
  ReactionsModel replyReactions;

  ReplyModel(
      {this.user,
      this.text = 'Click to add reply text here ✍.',
      this.image,
      this.elapsedTime = '10m',
      this.replyReactions});

  Map<String, dynamic> toJson() {
    return {
      "user": this.user.toJson(),
      "text": this.text,
      "image": this.image?.path,
      "elapsedTime": this.elapsedTime,
      "replyReactions": this.replyReactions.toJson(),
    };
  }

  factory ReplyModel.fromJson(Map<String, dynamic> json) {
    return ReplyModel(
      user: ProfileModel.fromJson(json["user"]),
      text: json["text"],
      image: json["image"] != null ? File(json["image"]) : null,
      elapsedTime: json["elapsedTime"],
      replyReactions: ReactionsModel.fromJson(json["replyReactions"]),
    );
  }
//
}
