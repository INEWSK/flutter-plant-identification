///需不需要JSON轉模型?
///在原生iOS和Android開發中，絕大部分開發者都會將請求接口返回的數據轉成模型/實體類去使用。
///但是在Flutter中，如果接口返回的數據非常簡單，並且只需要獲取返回數據中的個別分區的數據，可以直接獲取。
///否則建議先把返回的數據轉換成模型/實體類再去使用 。

import 'dart:convert';

TreeData treeDataFromJson(String str) => TreeData.fromJson(json.decode(str));

String treeDataToJson(TreeData data) => json.encode(data.toJson());

class TreeData {
  TreeData({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  int count;
  dynamic next;
  dynamic previous;
  List<Result> results;

  factory TreeData.fromJson(Map<String, dynamic> json) => TreeData(
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

class Result {
  Result({
    this.id,
    this.folderName,
    this.scientificName,
    this.commonName,
    this.introduction,
    this.specialFeatures,
    this.toLearnMore,
    this.family,
    this.height,
    this.natureOfLeaf,
    this.branch,
    this.bark,
    this.leaf,
    this.flower,
    this.fruit,
    this.dateCreated,
    this.treeImages,
    this.treeLocations,
  });

  int id;
  String folderName;
  String scientificName;
  String commonName;
  String introduction;
  String specialFeatures;
  String toLearnMore;
  String family;
  String height;
  String natureOfLeaf;
  String branch;
  String bark;
  String leaf;
  String flower;
  String fruit;
  DateTime dateCreated;
  List<TreeImage> treeImages;
  List<TreeLocation> treeLocations;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        folderName: json["folder_name"],
        scientificName: json["scientific_name"],
        commonName: json["common_name"],
        introduction: json["introduction"],
        specialFeatures: json["special_features"],
        toLearnMore: json["to_learn_more"],
        family: json["family"],
        height: json["height"],
        natureOfLeaf: json["nature_of_leaf"],
        branch: json["branch"],
        bark: json["bark"],
        leaf: json["leaf"],
        flower: json["flower"],
        fruit: json["fruit"],
        dateCreated: DateTime.parse(json["date_created"]),
        treeImages: List<TreeImage>.from(
            json["tree_images"].map((x) => TreeImage.fromJson(x))),
        treeLocations: List<TreeLocation>.from(
            json["tree_locations"].map((x) => TreeLocation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "folder_name": folderName,
        "scientific_name": scientificName,
        "common_name": commonName,
        "introduction": introduction,
        "special_features": specialFeatures,
        "to_learn_more": toLearnMore,
        "family": family,
        "height": height,
        "nature_of_leaf": natureOfLeaf,
        "branch": branch,
        "bark": bark,
        "leaf": leaf,
        "flower": flower,
        "fruit": fruit,
        "date_created": dateCreated.toIso8601String(),
        "tree_images": List<dynamic>.from(treeImages.map((x) => x.toJson())),
        "tree_locations":
            List<dynamic>.from(treeLocations.map((x) => x.toJson())),
      };
}

class TreeImage {
  TreeImage({
    this.id,
    this.treeImage,
    this.dateCreated,
    this.tree,
  });

  int id;
  String treeImage;
  DateTime dateCreated;
  int tree;

  factory TreeImage.fromJson(Map<String, dynamic> json) => TreeImage(
        id: json["id"],
        treeImage: json["tree_image"],
        dateCreated: DateTime.parse(json["date_created"]),
        tree: json["tree"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tree_image": treeImage,
        "date_created": dateCreated.toIso8601String(),
        "tree": tree,
      };
}

class TreeLocation {
  TreeLocation({
    this.id,
    this.treeImage,
    this.treeLat,
    this.treeLong,
    this.dateCreated,
    this.tree,
  });

  int id;
  String treeImage;
  double treeLat;
  double treeLong;
  DateTime dateCreated;
  int tree;

  factory TreeLocation.fromJson(Map<String, dynamic> json) => TreeLocation(
        id: json["id"],
        treeImage: json["tree_image"],
        treeLat: json["tree_lat"].toDouble(),
        treeLong: json["tree_long"].toDouble(),
        dateCreated: DateTime.parse(json["date_created"]),
        tree: json["tree"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tree_image": treeImage,
        "tree_lat": treeLat,
        "tree_long": treeLong,
        "date_created": dateCreated.toIso8601String(),
        "tree": tree,
      };
}
