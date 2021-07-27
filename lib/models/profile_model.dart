import 'dart:io';
class ProfileModel {
  String name;
  String otherName;
  File photo;
  File cover;
  String bio;
  bool verified;
  String mainButton;
  Map<String, String> details;
  bool viewAs;
  bool hasStory;
  bool showOtherName;
  bool showBio;

  ProfileModel(
      {this.name = 'User Name',
      this.otherName = 'Other Name',
      this.photo,
      this.cover,
      this.bio = 'Bio Text 💭',
      this.verified = true,
      this.mainButton = 'true',
      this.details = const {
        "lives": "New York",
        "went": "University Oxford",
        "manage": "Page",
        "worked": "Facebook",
        "relationship": "Someone",
        "from": "Casablanca, Morocco",
        "followed": "10 000 000 people",
      },
      this.viewAs = true,
      this.hasStory = true,
      this.showOtherName = true,
      this.showBio = true});

  /*ProfileModel(
      {this.name = 'User Name',
      this.otherName = 'Other name',
      this.photo,
      this.cover,
      this.bio = 'Here is the bio',
      this.verified = true});*/

  Map<String, dynamic> toJson() {
    return {
      "name": this.name,
      "otherName": this.otherName,
      "photo": this.photo?.path,
      "cover": this.cover?.path,
      "bio": this.bio,
      "verified": this.verified,
      "mainButton": this.mainButton,
      "details": Map<String, String>.from(this.details),
      "viewAs": this.viewAs,
      "hasStory": this.hasStory,
      "showOtherName": this.showOtherName,
      "showBio": this.showBio,
    };
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      name: json["name"],
      otherName: json["otherName"],
      photo: json["photo"] != null ? File(json["photo"]) : null,
      cover: json["cover"] != null ? File(json["cover"]) : null,
      bio: json["bio"],
      verified: json["verified"],
      mainButton: json["mainButton"],
      // details: Map<String, dynamic>.from(jsonDecode(json['details'])),
      details: Map<String, String>.from(json['details']),
      viewAs: json["viewAs"],
      hasStory: json["hasStory"],
      showOtherName: json["showOtherName"],
      showBio: json["showBio"],
    );
  }
//

/*
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      name: json["name"],
      otherName: json["otherName"],
      photo: json["photo"] != null ? File(json["photo"]) : null,
      cover: json["cover"] != null ? File(json["cover"]) : null,
      bio: json["bio"],
      verified: json["verified"].toString().toLowerCase() == 'true',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": this.name,
      "otherName": this.otherName,
      "photo": this.photo?.path,
      "cover": this.cover?.path,
      "bio": this.bio,
      "verified": this.verified,
    };
  }
*/
//
}
