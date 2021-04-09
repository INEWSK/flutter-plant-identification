import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';
import 'package:flutter_hotelapp/common/utils/image_utils.dart';
import 'package:flutter_hotelapp/common/utils/screen_utils.dart';
import 'package:flutter_hotelapp/models/tree_data.dart';

class TreeItem extends StatelessWidget {
  final TreeData data;
  final Function press;

  const TreeItem({
    Key key,
    this.data,
    this.press,
  }) : super(key: key);

  Widget _image() {
    // image provider解決 connection closed 問題
    return FutureBuilder(
      future: _imageUrl(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return Container(
            // clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: ImageUtils.getImageProvider(snapshot.data),
                fit: BoxFit.cover,
              ),
            ),
          );
        } else {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  _imageUrl() async {
    String imgUrl;

    if (data.treeImages.isNotEmpty) {
      imgUrl = data.treeImages.first.treeImage;
      return imgUrl;
    } else {
      imgUrl = 'assets/images/nophoto.jpg';
      return imgUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(kDefaultPadding / 3),
      child: ListTile(
        leading: CircleAvatar(
          // radius: 25,
          child: _image(),
          backgroundColor: Colors.transparent,
        ),
        title: Text(data.commonName),
        subtitle: Text(data.scientificName),
        trailing: Icon(Icons.chevron_right),
        onTap: press,
      ),
    );
  }
}
