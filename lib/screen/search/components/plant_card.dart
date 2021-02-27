import 'package:flutter/material.dart';

class PlantCard extends StatelessWidget {
  final String title, sname, intro;
  final String imgSrc;
  final Function press;

  const PlantCard({
    Key key,
    this.title,
    this.sname,
    this.intro,
    this.imgSrc,
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
              backgroundImage: AssetImage(imgSrc),
            ),
            title: Text(title),
            subtitle: Text(
              sname,
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
        FlatButton(
          textColor: Colors.green,
          onPressed: () {
            // Perform some action
          },
          child: const Text('VIEW MORE'),
        ),
      ],
    );
  }

  Widget _intro() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: intro != null
          ? Text(
              intro,
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
      // 溢出部分裁切
      child: Align(
        alignment: Alignment.center,
        widthFactor: 1.0,
        heightFactor: 0.6,
        child: Image.asset(imgSrc),
      ),
    );
  }
}
