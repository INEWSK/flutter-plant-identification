///需不需要JSON轉模型?
///在原生iOS和Android開發中，絕大部分開發者都會將請求接口返回的數據轉成模型/實體類去使用。
///但是在Flutter中，如果接口返回的數據非常簡單，並且只需要獲取返回數據中的個別分區的數據，可以直接獲取。
///否則建議先把返回的數據轉換成模型/實體類再去使用 。

class TreeData {
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
  String dateCreated;
  List<TreeImages> treeImages;
  List<TreeLocations> treeLocations;

  TreeData({
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

  TreeData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    folderName = json['folder_name'];
    scientificName = json['scientific_name'];
    commonName = json['common_name'];
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
    if (json['tree_images'] != null) {
      treeImages = [];
      json['tree_images'].forEach((v) {
        treeImages.add(TreeImages.fromJson(v));
      });
    }
    if (json['tree_locations'] != null) {
      treeLocations = [];
      json['tree_locations'].forEach((v) {
        treeLocations.add(TreeLocations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['folder_name'] = this.folderName;
    data['scientific_name'] = this.scientificName;
    data['common_name'] = this.commonName;
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
    if (this.treeImages != null) {
      data['tree_images'] = this.treeImages.map((v) => v.toJson()).toList();
    }
    if (this.treeLocations != null) {
      data['tree_locations'] =
          this.treeLocations.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TreeImages {
  int id;
  String treeImage;
  String dateCreated;
  int tree;

  TreeImages({this.id, this.treeImage, this.dateCreated, this.tree});

  TreeImages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    treeImage = json['tree_image'];
    dateCreated = json['date_created'];
    tree = json['tree'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['tree_image'] = this.treeImage;
    data['date_created'] = this.dateCreated;
    data['tree'] = this.tree;
    return data;
  }
}

class TreeLocations {
  int id;
  double treeLat;
  double treeLong;
  String dateCreated;
  int tree;

  TreeLocations(
      {this.id, this.treeLat, this.treeLong, this.dateCreated, this.tree});

  TreeLocations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    treeLat = json['tree_lat'];
    treeLong = json['tree_long'];
    dateCreated = json['date_created'];
    tree = json['tree'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['tree_lat'] = this.treeLat;
    data['tree_long'] = this.treeLong;
    data['date_created'] = this.dateCreated;
    data['tree'] = this.tree;
    return data;
  }
}
