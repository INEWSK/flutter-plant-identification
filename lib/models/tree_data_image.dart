class TreeDataImage {
  int id;
  String treeImage;
  int tree;

  TreeDataImage({this.id, this.treeImage, this.tree});

  TreeDataImage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    treeImage = json['tree_image'];
    tree = json['tree'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tree_image'] = this.treeImage;
    data['tree'] = this.tree;
    return data;
  }
}
