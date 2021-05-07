// import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_hotelapp/common/utils/device_utils.dart';
// import 'package:flutter_hotelapp/common/utils/local_notification.dart';

// class ProfileProvider extends ChangeNotifier {
//   bool _training = false;

//   get train => _training;

//   Future<String> requestRetrain() async {
//     if (_training) {
//       return 'Processing';
//     }

//     _backgroundService(true);

//     _training = true;
//     notifyListeners();

//     final result =
//         await Future.delayed(const Duration(seconds: 10), () => 'AI訓練完畢');
//     debugPrint(result);

//     _backgroundService(false);

//     _training = false;
//     notifyListeners();
//     return result;
//   }

//   //A機8.0以上軟件進入後台1分鐘後就會進入閒置狀態, 限制取用
//   //有機會被系統殺死APP釋放內存
//   //自求平安
//   Future<void> _backgroundService(bool on) async {
//     if (Device.isAndroid) {
//       var methodChannel = MethodChannel("com.example.flutter_hotelapp");
//       if (on) {
//         String data = await methodChannel.invokeMethod("startService");
//         debugPrint("Service Status: $data");
//       } else {
//         String data = await methodChannel.invokeMethod("stopService");

//         LocalNotification.show(
//           id: 0,
//           title: '伺服器 AI 模型訓練',
//           body: '伺服器已完成圖形訓練',
//         );

//         debugPrint("Service Status: $data");
//       }
//     }
//     // ios 只返回 notification
//     if (Device.isIOS) {
//       if (!on) {
//         LocalNotification.show(
//           id: 0,
//           title: '伺服器 AI 模型訓練',
//           body: '伺服器已完成圖形訓練',
//         );
//       }
//     }
//   }
// }
