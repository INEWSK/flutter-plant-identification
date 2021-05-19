import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';
import 'package:flutter_hotelapp/common/utils/image_utils.dart';
import 'package:flutter_hotelapp/models/tree_locations.dart';
import 'package:flutter_hotelapp/screen/detail/detail_screen.dart';

class MapBottomPill extends StatelessWidget {
  final bool isVisible;
  final TreeLocation data;

  const MapBottomPill({
    Key key,
    this.isVisible,
    this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      left: 0,
      right: 0,
      bottom: isVisible ? 55 : -220,
      duration: kDefaultDuration,
      curve: Curves.easeInExpo,
      child: Card(
        child: ListTile(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  DetailScreen(data: data, type: DataType.GoogleMap),
            ),
          ),
          leading: CircleAvatar(
            child: _image(),
            backgroundColor: Colors.transparent,
          ),
          title: Text(
            data == null ? 'Title' : data.commonName,
          ),
          subtitle: Text(
            data == null ? 'Subtitle' : data.scientificName,
          ),
          trailing: Image.asset(
            'assets/images/location_marker.png',
            width: 32,
          ),
        ),
      ),
    );
  }

  _image() {
    // image provider解決 connection closed 問題
    return FutureBuilder(
      future: _getImage(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          final response = snapshot.data;

          final ImageType imageType = response['imageType'];
          final String imageUrl = response['imageUrl'];

          if (imageType == ImageType.network) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
                image: DecorationImage(
                  image: ImageUtils.getImageProvider(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            );
          } else {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
                image: DecorationImage(
                  image: ImageUtils.getAssetImage(imageUrl,
                      format: ImageFormat.png),
                  fit: BoxFit.cover,
                ),
              ),
            );
          }
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

  Future<Map> _getImage() async {
    Map<String, dynamic> result = {
      'imageType': ImageType.local,
      'imageUrl': 'no-photo',
    };

    if (data != null) {
      if (data.treeLocations.first.treeImage.isNotEmpty) {
        result['imageType'] = ImageType.network;
        result['imageUrl'] = data.treeLocations.first.treeImage;
        return result;
      } else {
        return result;
      }
    } else {
      return result;
    }
  }
}
