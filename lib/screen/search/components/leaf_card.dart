import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';
import 'package:flutter_hotelapp/common/utils/image_utils.dart';
import 'package:flutter_hotelapp/models/tree_data.dart';

class LeafCard extends StatelessWidget {
  final TreeData data;
  final Function press;

  const LeafCard({
    Key key,
    this.data,
    this.press,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(data.commonName),
            subtitle: Text(
              data.scientificName,
              style: kSecondaryBodyTextStyle,
            ),
          ),
          _image(context),
          _intro(),
          _button(),
        ],
      ),
    );
  }

  Widget _button() {
    return ButtonBar(
      alignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: press,
          child: const Text(
            'VIEW MORE',
            style: TextStyle(
              color: Colors.green,
            ),
          ),
        ),
      ],
    );
  }

  Widget _intro() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: data.introduction != null
          ? Text(data.introduction,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: kBodyTextStyle)
          : Container(),
    );
  }

  Widget _image(context) {
    // image provider解決 connection closed 問題
    var size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: _imageUrl(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return Container(
            width: size.width,
            height: size.height * 0.25,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: ImageUtils.getImageProvider(snapshot.data),
                  fit: BoxFit.cover),
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
      imgUrl = data.treeImages[0].treeImage;

      return imgUrl;
    } else {
      imgUrl = 'assets/images/nophoto.jpg';
      return imgUrl;
    }
  }
}
