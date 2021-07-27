import 'dart:io';

import 'package:faker/models/profile_model.dart';

class PageModel {
  String name;
  File  photo;
  File cover;
  String category;
  String mainButton;
  List<ProfileModel> profilesLike;
  int likesCounts;
  Map<String, String> details;
  bool liked;
}