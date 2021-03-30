class TreeLatLng {
  String scientificName;
  String dateCreated;
  List<TreeLocations> treeLocations;

  TreeLatLng({this.scientificName, this.dateCreated, this.treeLocations});

  TreeLatLng.fromJson(Map<String, dynamic> json) {
    scientificName = json['scientific_name'];
    dateCreated = json['date_created'];
    if (json['tree_locations'] != null) {
      treeLocations = [];
      json['tree_locations'].forEach((v) {
        treeLocations.add(new TreeLocations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['scientific_name'] = this.scientificName;
    data['date_created'] = this.dateCreated;
    if (this.treeLocations != null) {
      data['tree_locations'] =
          this.treeLocations.map((v) => v.toJson()).toList();
    }
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tree_lat'] = this.treeLat;
    data['tree_long'] = this.treeLong;
    data['date_created'] = this.dateCreated;
    data['tree'] = this.tree;
    return data;
  }
}
