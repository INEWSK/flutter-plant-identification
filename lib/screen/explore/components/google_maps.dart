import 'package:flutter/material.dart';

import 'package:flutter_hotelapp/common/utils/toast_utils.dart';
import 'package:flutter_hotelapp/models/tree_data.dart';
import 'package:flutter_hotelapp/screen/detail/detail_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'google_maps_button.dart';
import 'map_bottom_pill.dart';
import '../provider/google_maps_provider.dart';

class GoogleMaps extends StatefulWidget {
  @override
  _GoogleMapsState createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  final LatLng _hongKong = const LatLng(22.3939351, 114.1561875);

  @override
  void dispose() {
    super.dispose();
    context.read<GoogleMapsProvider>().dispose();
  }

  @override
  void initState() {
    super.initState();
    initGoogleMapsMarker();
  }

  void _setMarker(List<Result> treeData) {
    var map = context.read<GoogleMapsProvider>();
    treeData.forEach((data) {
      if (data.treeLocations.isNotEmpty) {
        List<TreeLocation> locations = data.treeLocations;
        locations.forEach((loc) {
          map.markers.add(
            Marker(
              zIndex: loc.id.toDouble(),
              markerId: MarkerId(loc.id.toString()),
              onTap: () {
                map.isShowPill(true);
                map.getPillData(data);
              },
              infoWindow: InfoWindow(
                title: data.commonName,
                snippet: data.scientificName,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(
                      // 傳進當前 leafcard 的 treedata[index] 給 detail page
                      data: data,
                    ),
                  ),
                ),
              ),
              position: LatLng(loc.treeLat, loc.treeLong),
              icon: map.icon,
            ),
          );
        });
      }
    });
  }

  void initGoogleMapsMarker() async {
    final result = await context.read<GoogleMapsProvider>().fetchMarkerData();

    final String message = result['message'];
    final bool success = result['success'];
    final List<Result> data = result['data'];

    if (!success) {
      Toast.error(
          icon: Icons.wrong_location, title: '加載座標失敗', subtitle: message);
    } else {
      _setMarker(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GoogleMapsProvider>(
      builder: (_, map, __) {
        return Stack(
          children: [
            GoogleMap(
              onMapCreated: map.onMapCreated,
              // mapToolbarEnabled: false,
              zoomControlsEnabled: false,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              markers: Set.from(map.markers),
              initialCameraPosition:
                  CameraPosition(target: _hongKong, zoom: 12.0),
              onTap: (LatLng loc) {
                map.isShowPill(false);
              },
            ),
            // _locateButton(),
            GoogleMapsButton(
              locate: map.locatePosition,
              refresh: map.fetchMarkerData,
            ),
            MapBottomPill(isVisible: map.visible, data: map.pillData),
          ],
        );
      },
    );
  }
}
