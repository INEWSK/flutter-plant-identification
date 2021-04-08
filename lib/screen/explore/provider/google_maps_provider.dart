// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';
// import 'dart:ui' as ui;

// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_hotelapp/common/constants/rest_api.dart';
// import 'package:flutter_hotelapp/common/utils/dio_exceptions.dart';
// import 'package:flutter_hotelapp/models/tree_lat_lng.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class GoogleMapsProvider extends ChangeNotifier {
//   GoogleMapController _mapController;
//   List<Marker> _markers = [];
//   BitmapDescriptor _markerIcon;

//   get mapController => _mapController;
//   get markers => _markers;

//   // dio baseoption preset
//   Dio dio = Dio(
//     BaseOptions(
//       connectTimeout: 10000, //10s
//       receiveTimeout: 5000,
//       headers: {
//         HttpHeaders.acceptHeader: "application/json",
//         HttpHeaders.userAgentHeader: "",
//         HttpHeaders.acceptLanguageHeader: 'en-US',
//       },
//       contentType: Headers.jsonContentType,
//       responseType: ResponseType.plain,
//     ),
//   );

//   Future<Map> fetchMarkerFormApi() async {
//     /// 用於返回結果給 UI 層
//     Map<String, dynamic> result = {
//       'success': false,
//       'message': 'Unknow error.'
//     };

//     // 本地測試請求地址
//     final String url = RestApi.localUrl + '/flora/tree/';

//     try {
//       debugPrint('API 呼叫成功');
//       final response = await dio.get(url);

//       result['success'] = true;
//       result['message'] = '植物座標加載成功';

//       List<TreeLatLng> data = List<TreeLatLng>.from(
//         json.decode(response.data).map(
//               (x) => TreeLatLng.fromJson(x),
//             ),
//       );

//       await _addMarker(data);

//       return result;
//     } on DioError catch (e) {
//       var error = DioExceptions.fromDioError(e);
//       print('Google Map Marker API Error: ${error.messge}');

//       result['message'] = '獲取植物座標失敗, 請檢查伺服器狀態';

//       return result;
//     }
//   }

//   Future<void> initMarkerIcon(context) async {
//     Uint8List _icon =
//         await _getBytesFromAsset('assets/images/location_marker.png', 100);

//     _markerIcon = BitmapDescriptor.fromBytes(_icon);
//     debugPrint('初始化座標圖片成功');
//   }

//   Future<void> locatePosition() async {
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);

//     if (position != null) {
//       LatLng latLng = LatLng(position.latitude, position.longitude);

//       CameraPosition cameraPosition =
//           CameraPosition(bearing: 0.0, target: latLng, zoom: 16);
//       _mapController
//           .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
//     }
//   }

//   Future<void> onMapCreated(GoogleMapController controller) async {
//     _mapController = controller;
//     // 移动画面至用戶位置
//     locatePosition();
//   }

//   Future<void> _addMarker(List<TreeLatLng> markerData) async {
//     markerData.forEach((element) {
//       if (element.treeLocations.isNotEmpty) {
//         List<TreeLocations> location = element.treeLocations;
//         location.forEach((locate) {
//           _markers.add(Marker(
//             markerId: MarkerId(
//               locate.id.toString(),
//             ),
//             infoWindow: InfoWindow(
//               title: element.scientificName,
//               snippet: element.scientificName,
//             ),
//             position: LatLng(
//               locate.treeLat,
//               locate.treeLong,
//             ),
//             icon: _markerIcon,
//           ));
//         });
//       }
//     });
//   }

//   // convert image method  for google map marker
//   Future<Uint8List> _getBytesFromAsset(String path, int width) async {
//     ByteData data = await rootBundle.load(path);
//     ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
//         targetWidth: width);
//     ui.FrameInfo fi = await codec.getNextFrame();
//     return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
//         .buffer
//         .asUint8List();
//   }
// }
