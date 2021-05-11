// To parse this JSON data, do
//
//     final treeLocation = treeLocationFromJson(jsonString);

import 'dart:convert';

List<TreeLocation> treeLocationFromJson(String str) => List<TreeLocation>.from(
    json.decode(str).map((x) => TreeLocation.fromJson(x)));

String treeLocationToJson(List<TreeLocation> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TreeLocation {
  TreeLocation({
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
    this.treeLocations,
  });

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
  List<TreeLocationElement> treeLocations;

  factory TreeLocation.fromJson(Map<String, dynamic> json) => TreeLocation(
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
        treeLocations: List<TreeLocationElement>.from(
            json["tree_locations"].map((x) => TreeLocationElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
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
        "tree_locations":
            List<dynamic>.from(treeLocations.map((x) => x.toJson())),
      };
}

class TreeLocationElement {
  TreeLocationElement({
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

  factory TreeLocationElement.fromJson(Map<String, dynamic> json) =>
      TreeLocationElement(
        id: json["id"],
        treeImage: json["tree_image"],
        treeLat: json["tree_lat"],
        treeLong: json["tree_long"],
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
