import 'dart:convert';

List<TreeInfo> treeInfoFromJson(String str) =>
    List<TreeInfo>.from(json.decode(str).map((x) => TreeInfo.fromJson(x)));

String treeInfoToJson(List<TreeInfo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TreeInfo {
  TreeInfo({
    this.infoType,
    this.title,
    this.content,
    this.dateCreated,
    this.infoImages,
  });

  String infoType;
  String title;
  String content;
  DateTime dateCreated;
  List<InfoImage> infoImages;

  factory TreeInfo.fromJson(Map<String, dynamic> json) => TreeInfo(
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

class InfoImage {
  InfoImage({
    this.id,
    this.infoImage,
    this.dateCreated,
    this.info,
  });

  int id;
  String infoImage;
  DateTime dateCreated;
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
