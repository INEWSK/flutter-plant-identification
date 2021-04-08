import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';
import 'package:flutter_hotelapp/models/tree_data.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MapBottomPill extends StatelessWidget {
  final bool isVisible;
  final TreeData data;

  const MapBottomPill({Key key, this.isVisible, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      left: 0,
      right: 0,
      bottom: isVisible ? 55 : -220,
      duration: kDefaultDuration,
      // curves 動畫演示詳見 https://api.flutter.dev/flutter/animation/Curves-class.html
      curve: Curves.easeInExpo,
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: EdgeInsets.all(kDefaultPadding / 1.5),
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(5.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 5,
                offset: Offset.zero,
              ),
            ]),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/images/no_picture_avatar.png',
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            SizedBox(width: 20),
            // 此 widget 儘可能佔用所有橫向空間 (擠壓 Icon 至右側)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data == null ? 'Title' : data.commonName,
                      style: kSubHeadTextStyle),
                  Text(data == null ? 'Subtitle' : data.scientificName,
                      style: kBodyTextStyle),
                  Text(
                    data == null
                        ? 'LatLng'
                        : 'Location: ${data.treeLocations[0].treeLat.toString()}, ${data.treeLocations[0].treeLong.toString()}',
                    style: kSecondaryBodyTextStyle.copyWith(height: 1.5),
                  )
                ],
              ),
            ),
            Image.asset(
              'assets/images/location_marker.png',
              width: 36,
            ),
          ],
        ),
      ),
    );
  }
}
