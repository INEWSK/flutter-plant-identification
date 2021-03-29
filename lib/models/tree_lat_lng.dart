class TreeLatLng {
  int id;
  double treeLat;
  double treeLong;
  String dateCreated;
  int tree;

  TreeLatLng(
      {this.id, this.treeLat, this.treeLong, this.dateCreated, this.tree});

  TreeLatLng.fromJson(Map<String, dynamic> json) {
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
