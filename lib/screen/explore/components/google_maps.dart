import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hotelapp/common/utils/dio_exceptions.dart';
import 'package:flutter_hotelapp/common/utils/toast_utils.dart';
import 'package:flutter_hotelapp/models/tree_lat_lng.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'google_maps_button.dart';

class GoogleMaps extends StatefulWidget {
  @override
  _GoogleMapsState createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  GoogleMapController _mapController;
  List<Marker> _markers = [];
  List<TreeLatLng> _apiMarkerData = [];
  // marker icon
  BitmapDescriptor _markerIcon;

  final LatLng _center = const LatLng(22.3939351, 114.1561875);

  @override
  void initState() {
    super.initState();
    _fetchLocationFormApi();
  }

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

  void _initMarkerIcon(context) async {
    Uint8List _icon =
        await getBytesFromAsset('assets/images/location_marker.png', 100);

    _markerIcon = BitmapDescriptor.fromBytes(_icon);
  }

  void _addMarker() {
    _apiMarkerData.forEach((element) {
      if (element.treeLocations.isNotEmpty) {
        List<TreeLocations> location = element.treeLocations;
        location.forEach((loc) {
          _markers.add(Marker(
            markerId: MarkerId(
              loc.id.toString(),
            ),
            infoWindow: InfoWindow(
              title: element.scientificName,
              snippet: element.scientificName,
            ),
            position: LatLng(
              loc.treeLat,
              loc.treeLong,
            ),
            icon: _markerIcon,
          ));
        });
      }
    });
  }

  /// 從 server 抓 tree location 資料
  /// TODO: MVC
  _fetchLocationFormApi() async {
    // dio baseoption preset
    Dio dio = Dio(
      BaseOptions(
        connectTimeout: 10000, //10s
        receiveTimeout: 100000,
        headers: {
          HttpHeaders.acceptHeader: "application/json",
          HttpHeaders.userAgentHeader: "",
          HttpHeaders.acceptLanguageHeader: 'en-US',
        },
        contentType: Headers.jsonContentType,
        responseType: ResponseType.plain,
      ),
    );

    // 本地測試請求地址
    final String localUrl = 'http://10.0.2.2:8000/flora/tree/';

    try {
      final response = await dio.get(localUrl);

      List<TreeLatLng> data = List<TreeLatLng>.from(
        json.decode(response.data).map(
              (x) => TreeLatLng.fromJson(x),
            ),
      );

      setState(() {
        _apiMarkerData = data;
      });

      _addMarker();
    } on DioError catch (e) {
      var error = DioExceptions.fromDioError(e);
      print('GOGO Map Marker API: ${error.messge}');
      Toast.show('${error.messge}\nLoad Marker Failed', duration: 5000);
    }
  }

  void _onMapCreated(GoogleMapController controller) async {
    // 必須再重構一次畫面以顯示 marker icon
    setState(() {
      _mapController = controller;
    });
    _locatePosition();
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

  @override
  Widget build(BuildContext context) {
    _initMarkerIcon(context);
    return Stack(
      children: [
        GoogleMap(
          onMapCreated: _onMapCreated,
          // mapToolbarEnabled: false, // android only
          zoomControlsEnabled: false,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          markers: Set.from(_markers),
          initialCameraPosition: CameraPosition(target: _center, zoom: 12.0),
        ),
        // _locateButton(),
        GoogleMapsButton(
          locatePress: _locatePosition,
          arPress: () {},
        ),
      ],
    );
  }
}
