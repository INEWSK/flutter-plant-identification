class TreeInfo {
  String infoType;
  String title;
  String content;
  String dateCreated;
  List<InfoImages> infoImages;

  TreeInfo(
      {this.infoType,
      this.title,
      this.content,
      this.dateCreated,
      this.infoImages});

  TreeInfo.fromJson(Map<String, dynamic> json) {
    infoType = json['info_type'];
    title = json['title'];
    content = json['content'];
    dateCreated = json['date_created'];
    if (json['info_images'] != null) {
      infoImages = [];
      json['info_images'].forEach((v) {
        infoImages.add(InfoImages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['info_type'] = this.infoType;
    data['title'] = this.title;
    data['content'] = this.content;
    data['date_created'] = this.dateCreated;
    if (this.infoImages != null) {
      data['info_images'] = this.infoImages.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class InfoImages {
  int id;
  String infoImage;
  String dateCreated;
  int info;

  InfoImages({this.id, this.infoImage, this.dateCreated, this.info});

  InfoImages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    infoImage = json['info_image'];
    dateCreated = json['date_created'];
    info = json['info'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['info_image'] = this.infoImage;
    data['date_created'] = this.dateCreated;
    data['info'] = this.info;
    return data;
  }
}
