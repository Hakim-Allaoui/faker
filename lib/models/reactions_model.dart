class ReactionsModel{
  List<String> reactions = [
    "like",
  ];

  int reactionsCount;
  int commentsCount;
  int sharesCount;

  ReactionsModel({this.reactions, this.reactionsCount, this.commentsCount, this.sharesCount});

  Map<String, dynamic> toJson() {
    return {
      "reactions": this.reactions.toList(),
      "reactionsCount": this.reactionsCount,
      "commentsCount": this.commentsCount,
      "sharesCount": this.sharesCount,
    };
  }

  factory ReactionsModel.fromJson(Map<String, dynamic> json) {
    return ReactionsModel(
      reactions:
          List.of(json["reactions"]).map((i) => i.toString()).toList(),
      reactionsCount: int.parse(json["reactionsCount"] != null ? json["reactionsCount"].toString() : '0'),
      commentsCount: int.parse(json["commentsCount"] != null ? json["commentsCount"].toString() : '0'),
      sharesCount: int.parse(json["sharesCount"] != null ? json["sharesCount"].toString() : '0'),
    );
  }
//
}