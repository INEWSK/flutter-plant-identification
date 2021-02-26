import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SectionCell extends StatelessWidget {
  final SvgPicture icon;
  final String title;
  final String content;

  const SectionCell({
    Key key,
    @required this.icon,
    @required this.title,
    this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionDivider(),
        Text.rich(
          TextSpan(
            children: [
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: icon,
                ),
              ),
              TextSpan(
                text: title,
                style: kSubHeadTextStyle,
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        content != null
            ? Text(
                content,
                style: kBodyTextStyle,
                // maxLines: 4,
                // overflow: TextOverflow.ellipsis,
              )
            : Container(),
      ],
    );
  }
}

class SectionDivider extends StatelessWidget {
  const SectionDivider({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Divider(),
    );
  }
}
