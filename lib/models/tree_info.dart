import 'dart:convert';

import 'package:hive/hive.dart';

part 'tree_info.g.dart';

TreeInfo treeInfoFromJson(String str) => TreeInfo.fromJson(json.decode(str));

String treeInfoToJson(TreeInfo data) => json.encode(data.toJson());

@HiveType(typeId: 4)
class TreeInfo extends HiveObject {
  TreeInfo({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  @HiveField(0)
  int count;
  @HiveField(1)
  dynamic next;
  @HiveField(2)
  dynamic previous;
  @HiveField(3)
  List<Result> results;

  factory TreeInfo.fromJson(Map<String, dynamic> json) => TreeInfo(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}

@HiveType(typeId: 5)
class Result extends HiveObject {
  Result({
    this.infoType,
    this.title,
    this.content,
    this.dateCreated,
    this.infoImages,
  });

  @HiveField(0)
  String infoType;
  @HiveField(1)
  String title;
  @HiveField(2)
  String content;
  @HiveField(3)
  DateTime dateCreated;
  @HiveField(4)
  List<InfoImage> infoImages;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        infoType: json["info_type"],
        title: json["title"],
        content: json["content"],
        dateCreated: DateTime.parse(json["date_created"]),
        infoImages: List<InfoImage>.from(
            json["info_images"].map((x) => InfoImage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "info_type": infoType,
        "title": title,
        "content": content,
        "date_created": dateCreated.toIso8601String(),
        "info_images": List<dynamic>.from(infoImages.map((x) => x.toJson())),
      };
}

@HiveType(typeId: 6)
class InfoImage extends HiveObject {
  InfoImage({
    this.id,
    this.infoImage,
    this.dateCreated,
    this.info,
  });
  @HiveField(0)
  int id;
  @HiveField(1)
  String infoImage;
  @HiveField(2)
  DateTime dateCreated;
  @HiveField(3)
  int info;

  factory InfoImage.fromJson(Map<String, dynamic> json) => InfoImage(
        id: json["id"],
        infoImage: json["info_image"],
        dateCreated: DateTime.parse(json["date_created"]),
        info: json["info"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "info_image": infoImage,
        "date_created": dateCreated.toIso8601String(),
        "info": info,
      };
}
