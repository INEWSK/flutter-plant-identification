class TreeData {
  int id;
  String scientificName;
  String commonName;
  String chineseName;
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
  String dateCreated;

  TreeData(
      {this.id,
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
      this.dateCreated});

  TreeData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    scientificName = json['scientific_name'];
    commonName = json['common_name'];
    chineseName = json['chinese_name'];
    introduction = json['introduction'];
    specialFeatures = json['special_features'];
    toLearnMore = json['to_learn_more'];
    family = json['family'];
    height = json['height'];
    natureOfLeaf = json['nature_of_leaf'];
    branch = json['branch'];
    bark = json['bark'];
    leaf = json['leaf'];
    flower = json['flower'];
    fruit = json['fruit'];
    dateCreated = json['date_created'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['scientific_name'] = this.scientificName;
    data['common_name'] = this.commonName;
    data['chinese_name'] = this.chineseName;
    data['introduction'] = this.introduction;
    data['special_features'] = this.specialFeatures;
    data['to_learn_more'] = this.toLearnMore;
    data['family'] = this.family;
    data['height'] = this.height;
    data['nature_of_leaf'] = this.natureOfLeaf;
    data['branch'] = this.branch;
    data['bark'] = this.bark;
    data['leaf'] = this.leaf;
    data['flower'] = this.flower;
    data['fruit'] = this.fruit;
    data['date_created'] = this.dateCreated;
    return data;
  }
}
