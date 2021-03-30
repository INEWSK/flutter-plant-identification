import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';
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
            leading: CircleAvatar(
              backgroundImage: data.treeImages.isNotEmpty
                  ? NetworkImage(data.treeImages[0].treeImage)
                  : AssetImage('assets/images/no-photo.png'),
            ),
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
    return ClipRect(
      child: Align(
        alignment: Alignment.center,
        widthFactor: 1.0,
        heightFactor: 0.6,
        child: data.treeImages.isNotEmpty
            ? Image.network(
                data.treeImages[0].treeImage,
                fit: BoxFit.contain,
              )
            : Image.asset(
                'assets/images/nophoto.jpg',
              ),
      ),
    );
  }
}
