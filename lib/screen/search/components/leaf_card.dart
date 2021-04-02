import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';
import 'package:flutter_hotelapp/models/tree_data.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
          _image(),
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

  Widget _image() {
    // 使用 async 解決 Connection closed while receiving data 問題
    return FutureBuilder(
      future: _treeImage(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return ClipRect(
            child: Align(
              alignment: Alignment.center,
              // widthFactor: ,
              heightFactor: 0.6,
              child: snapshot.data,
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

  _treeImage() async {
    Image image;
    if (data.treeImages.isNotEmpty) {
      image = Image.network(data.treeImages[0].treeImage);
      return image;
    } else {
      image = Image.asset('assets/images/nophoto.jpg');
      return image;
    }
  }
}
