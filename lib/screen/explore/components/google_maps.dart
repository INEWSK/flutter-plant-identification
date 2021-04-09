import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hotelapp/common/constants/rest_api.dart';
import 'package:flutter_hotelapp/common/utils/dio_exceptions.dart';
import 'package:flutter_hotelapp/common/utils/fluashbar_utils.dart';
import 'package:flutter_hotelapp/models/tree_data.dart';
import 'package:flutter_hotelapp/screen/detail/detail_screen.dart';
import 'package:flutter_hotelapp/screen/explore/components/map_bottom_pill.dart';
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
  // marker icon
  BitmapDescriptor _markerIcon;

  final LatLng _hongKong = const LatLng(22.3939351, 114.1561875);

  bool _isVisible = false;
  TreeData _pillData;

  @override
  void dispose() {
    super.dispose();
    _mapController?.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchDataFormApi();
  }

  void _setMarker(List<TreeData> treeData) {
    treeData.forEach((data) {
      if (data.treeLocations.isNotEmpty) {
        List<TreeLocations> locations = data.treeLocations;
        locations.forEach((loc) {
          _markers.add(
            Marker(
              zIndex: loc.id.toDouble(),
              markerId: MarkerId(loc.id.toString()),
              onTap: () {
                setState(() {
                  _isVisible = true;
                  // 將 data 傳進 widget
                  if (_pillData != data) _pillData = data;
                });
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
              icon: _markerIcon,
            ),
          );
        });
      }
    });
  }

  Future<void> _fetchDataFormApi() async {
    // dio baseoption preset
    Dio dio = Dio(
      BaseOptions(
        connectTimeout: 10000, //10s
        receiveTimeout: 5000, //5s
        headers: {
          HttpHeaders.acceptLanguageHeader: 'en-US',
        },
        contentType: Headers.jsonContentType,
        responseType: ResponseType.plain,
      ),
    );

    // 本地測試請求地址
    final String url = RestApi.localUrl + '/flora/tree/';

    try {
      final response = await dio.get(url);

      List<TreeData> data = List<TreeData>.from(
        json.decode(response.data).map(
              (x) => TreeData.fromJson(x),
            ),
      );
      // 通知 widget data 拿到了進行刷新以設置 marker
      setState(() {
        _setMarker(data);
      });
    } on DioError catch (e) {
      var error = DioExceptions.fromDioError(e);
      Flush.error(context, message: error.messge);
    }
  }

  // convert image method  for google map marker
  Future<Uint8List> _getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  void _initMarkerIcon(context) async {
    Uint8List _icon =
        await _getBytesFromAsset('assets/images/location_marker.png', 100);

    _markerIcon = BitmapDescriptor.fromBytes(_icon);
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

  void _onMapCreated(GoogleMapController controller) async {
    setState(() {
      _mapController = controller;
    });

    // 定向用戶位置
    _locatePosition();
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
          initialCameraPosition: CameraPosition(target: _hongKong, zoom: 12.0),
          onTap: (LatLng loc) {
            setState(() {
              _isVisible = false;
            });
          },
        ),
        // _locateButton(),
        GoogleMapsButton(
          locate: _locatePosition,
          refresh: _fetchDataFormApi,
        ),
        MapBottomPill(
          isVisible: _isVisible,
          data: _pillData,
        ),
      ],
    );
  }
}
