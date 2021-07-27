import 'dart:io';

import 'package:faker/models/comment_model.dart';
import 'package:faker/models/reactions_model.dart';
import 'package:faker/models/profile_model.dart';

class PostModel {
  ProfileModel user;
  String text;
  List<File> images;
  int imagesNb;
  String elapsedTime;
  double imagesHeight;

  ReactionsModel postReactions;
  List<CommentModel> comments;

  PostModel(
      {this.user,
      this.text = 'Click to write your own post text',
      this.images,
      this.imagesNb,
      this.elapsedTime = '10m',
      this.comments,
      this.postReactions,
      this.imagesHeight = 300.0});

  Map<String, dynamic> toJson() {
    return {
      "user": this.user.toJson(),
      "text": this.text,
      "images": this.images.map((e) => e?.path).toList(),
      "imagesNb": this.imagesNb,
      "elapsedTime": this.elapsedTime,
      "postReactions": this.postReactions.toJson(),
      "comments": this.comments.map((e) => e?.toJson()).toList(),
      "imagesHeight": this.imagesHeight,
    };
  }

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      user: ProfileModel.fromJson(json["user"]),
      text: json["text"],
      images: List.of(json["images"])
          .map((i) => File(i) /* can't generate it properly yet */)
          .toList(),
      imagesNb: json["imagesNb"],
      elapsedTime: json["elapsedTime"],
      postReactions: ReactionsModel.fromJson(json["postReactions"]),
      comments: List.of(json["comments"])
          .map((i) =>
              CommentModel.fromJson(i) /* can't generate it properly yet */)
          .toList(),
      imagesHeight: json["imagesHeight"] ?? 300,
    );
  }
//
}
