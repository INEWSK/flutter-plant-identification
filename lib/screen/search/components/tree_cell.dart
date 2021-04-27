import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';
import 'package:flutter_hotelapp/common/utils/image_utils.dart';
import 'package:flutter_hotelapp/models/tree_data.dart';

class TreeCell extends StatelessWidget {
  final Result data;
  final Function press;

  const TreeCell({
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
          final ImageType imageType = snapshot.data['imageType'];
          final String image = snapshot.data['image'];

          return Hero(
              child: Container(
                // clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageType == ImageType.network
                        ? ImageUtils.getImageProvider(image)
                        : ImageUtils.getAssetImage(image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              tag: imageType == ImageType.network
                  ? data.treeImages.first.treeImage
                  : 'noPhoto');
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

  Future<Map> _imageUrl() async {
    String imgUrl;

    Map<String, dynamic> response = {
      'imageType': ImageType.local,
      'image': imgUrl,
    };

    if (data.treeImages.isNotEmpty) {
      imgUrl = data.treeImages.first.treeImage;

      response['imageType'] = ImageType.network;
      response['image'] = imgUrl;

      return response;
    } else {
      imgUrl = 'no-photo';
      response['image'] = imgUrl;

      return response;
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
