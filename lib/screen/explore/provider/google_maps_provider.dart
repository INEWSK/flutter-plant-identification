import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hotelapp/common/constants/dio_options.dart';
import 'package:flutter_hotelapp/common/utils/dio_exceptions.dart';
import 'package:flutter_hotelapp/common/utils/locale_utils.dart';
import 'package:flutter_hotelapp/models/tree_locations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsProvider extends ChangeNotifier {
  GoogleMapController _mapController;
  List<TreeLocation> _data = [];
  List<Marker> _markers = [];
  // marker icon
  BitmapDescriptor _markerIcon;
  bool _isPillVisible = false;
  // data for bottom pill widget and detail page
  TreeLocation _pillData;

  get mapController => _mapController;
  get markers => _markers;
  get pillData => _pillData;
  get visible => _isPillVisible;
  get data => _data;
  get icon => _markerIcon;

  // dio baseoption preset
  Dio dio = Dio(stringOptions);

  Future<Map> fetchMarkerData() async {
    // for UI result
    Map<String, dynamic> result = {'success': false, 'data': List};

    final String url = '/flora/tree-location/';

    try {
      final response = await dio.get(url,
          options: Options(headers: {
            HttpHeaders.acceptLanguageHeader: LocaleUtils.getLocale
          }));

      final data = treeLocationFromJson(response.data);

      result['success'] = true;
      result['data'] = data;

      // 通知 widget 拿到了 data 進行刷新以設置 marker
      _data = data;
      notifyListeners();

      return result;
    } on DioError catch (e) {
      var error = DioExceptions.fromDioError(e);
      print(error.messge);

      result['data'] = null;

      return result;
    }
  }

  // convert image method  for google map marker
  Future<Uint8List> _getBytesFromAsset(String path, {int width = 100}) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  Future<void> initMarkerIcon() async {
    Uint8List _icon =
        await _getBytesFromAsset('assets/images/location_marker.png');

    _markerIcon = BitmapDescriptor.fromBytes(_icon);
  }

  void locatePosition() async {
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

  void onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    notifyListeners();
    // 定向用戶位置
    locatePosition();
  }

  void getPillData(TreeLocation data) {
    if (_pillData != data) _pillData = data;
    notifyListeners();
  }

  void isShowPill(bool show) {
    if (show) {
      _isPillVisible = true;
    } else {
      _isPillVisible = false;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _mapController?.dispose();
  }
}
