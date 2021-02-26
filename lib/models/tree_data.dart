class TreeData {
  final int id;
  final String scientificName;
  final String commonName;
  final String chineseName;
  final String introduction;
  final String specialFeatures;
  final String toLearnMore;
  final String family;
  final String height;
  final String natureOfLeaf;
  final String branch;
  final String bark;
  final String leaf;
  final String flower;
  final String fruit;
  final String dataCreatedData;

  TreeData({
    this.id,
    this.scientificName,
    this.commonName,
    this.chineseName,
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
    this.dataCreatedData,
  });

  factory TreeData.fromJson(Map<String, dynamic> json) {
    return TreeData(
      id: json["id"],
      scientificName: json['scientific_name'],
      commonName: json["common_name"],
      chineseName: json["chinese_name"],
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
      dataCreatedData: json["data_created"],
    );
  }

  @override
  String toString() {
    return 'tree name: $commonName';
  }
}
