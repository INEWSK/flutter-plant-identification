import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IntroCard extends StatelessWidget {
  final String sort, title, text, image;
  final Function press;

  const IntroCard({
    Key key,
    @required this.sort,
    @required this.title,
    @required this.text,
    @required this.image,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: kDefaultPadding / 1.5, // 13.4
        vertical: kDefaultPadding / 4, // 5
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: brightness == Brightness.dark ? Colors.black54 : Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0.0, .8), // 阴影 x y 轴位置偏移量
            blurRadius: 1.0, // 陰影模糊範圍
            spreadRadius: 0.0, // 模糊大小
            color: Color(0xFF203647).withOpacity(0.2),
          )
        ],
      ),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          /// image
          _image(context),
          _text(context),
        ],
      ),
      height: 152, // 卡片大小
    );
  }

  Widget _image(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Positioned(
      right: 15.0,
      child: SvgPicture.asset(
        image,
        // restricted width
        width: size.width * 0.3, // 30%
      ),
    );
  }

  Widget _text(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 16.0,
      ),
      // height: 152, // 該數值決定容器最終大小
      width: size.width * 0.65, // 65% of the container
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child: Text(
                sort,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 10.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: kH1TextStyle.copyWith(fontSize: 16.0),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              text,
              maxLines: 4,
              overflow: TextOverflow.ellipsis, // 省略號
              style: kBodyTextStyle.copyWith(fontSize: 12.0),
            ),
          ),
        ],
      ),
    );
  }
}
