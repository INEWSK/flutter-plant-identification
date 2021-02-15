import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hotelapp/common/demo/demo_data.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'locate_button.dart';

class GoogleMaps extends StatefulWidget {
  @override
  _GoogleMapsState createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  GoogleMapController _mapController;
  List<Marker> _markers = [];
  // marker icon
  BitmapDescriptor _markerIcon;

  final LatLng _center = const LatLng(22.3939351, 114.1561875);

  @override
  void dispose() {
    super.dispose();
    _mapController?.dispose();
  }

  void _locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    if (position != null) {
      LatLng latLng = LatLng(position.latitude, position.longitude);

      CameraPosition cameraPosition =
          CameraPosition(bearing: 0.0, target: latLng, zoom: 16);
      _mapController
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    }
  }

  _initMarkerIcon(context) async {
    Uint8List _icon =
        await getBytesFromAsset('assets/images/location_marker.png', 100);

    _markerIcon = BitmapDescriptor.fromBytes(_icon);
  }

  void _addMarker() {
    demoMarkersData.forEach((element) {
      _markers.add(
        Marker(
          markerId: MarkerId(
            element['id'],
          ),
          infoWindow: InfoWindow(
            title: element['title'],
            snippet: element['desc'],
          ),
          position: element['position'],
          icon: _markerIcon,
        ),
      );
    });
  }

  void _onMapCreated(GoogleMapController controller) async {
    // 必須再重構一次畫面以顯示 marker icon
    setState(() {
      _mapController = controller;
    });

    _addMarker();
    _locatePosition();
  }

  @override
  Widget build(BuildContext context) {
    _initMarkerIcon(context);
    return Stack(
      children: [
        GoogleMap(
          onMapCreated: _onMapCreated,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          markers: Set.from(_markers),
          initialCameraPosition: CameraPosition(target: _center, zoom: 11.0),
        ),
        // _locateButton(),
        LocateButton(
          press: _locatePosition,
        )
      ],
    );
  }

  // convert image method  for google map marker
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }
}
