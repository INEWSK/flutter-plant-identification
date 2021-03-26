import 'package:flutter/material.dart';
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
              backgroundImage:
                  AssetImage('assets/images/bauhinia_blakeana.jpg'),
            ),
            title: Text(data.commonName),
            subtitle: Text(
              data.scientificName,
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
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
          ? Text(
              data.introduction,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black.withOpacity(0.6),
              ),
            )
          : Container(),
    );
  }

  Widget _image() {
    return ClipRect(
      child: Align(
        alignment: Alignment.center,
        widthFactor: 1.0,
        heightFactor: 0.6,
        child: Image.asset('assets/images/bauhinia_blakeana.jpg'),
      ),
    );
  }
}
