// import 'package:flutter/material.dart';
// import 'package:flutter_hotelapp/common/styles/styles.dart';
// import 'package:flutter_icons/flutter_icons.dart';
// import 'package:provider/provider.dart';

// import 'providers/ml_kit_provider.dart';

// class MLKitScreen extends StatefulWidget {
//   @override
//   _MLKitScreenState createState() => _MLKitScreenState();
// }

// class _MLKitScreenState extends State<MLKitScreen>
//     with AutomaticKeepAliveClientMixin<MLKitScreen> {
//   @override
//   bool get wantKeepAlive => true;

//   Widget _readyScreen() {
//     return Consumer<MLKitProvider>(builder: (_, mlkit, __) {
//       return Scaffold(
//         appBar: AppBar(),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               mlkit.image != null
//                   ? Image.file(mlkit.image)
//                   : Text('Please select image to analyze.'),
//               Column(
//                 children: mlkit.labels != null
//                     ? mlkit.labels.map((label) {
//                         return Padding(
//                           padding: EdgeInsets.symmetric(
//                             vertical: kDefaultPadding,
//                           ),
//                           child: Text("${label["label"]}"),
//                         );
//                       }).toList()
//                     : [],
//               ),
//             ],
//           ),
//         ),
//         floatingActionButton: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               FloatingActionButton(
//                 heroTag: 'mlkitCameraBtn',
//                 tooltip: 'Camera',
//                 onPressed: () => mlkit.getImageLabels('camera'),
//                 child: Icon(Icons.camera),
//               ),
//               SizedBox(
//                 height: 16.0,
//               ),
//               FloatingActionButton(
//                 heroTag: 'mlkitAlbumBtn',
//                 tooltip: 'Album',
//                 onPressed: () => mlkit.getImageLabels('gallery'),
//                 child: Icon(
//                   FontAwesome.photo,
//                   size: 18.0,
//                 ),
//               )
//             ],
//           ),
//         ),
//       );
//     });
//   }

//   Widget _errorScreen() {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Center(
//         child: Text("Error loading model. Please check the logs."),
//       ),
//     );
//   }

//   Widget _loadingScreen() {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             Padding(
//               padding: const EdgeInsets.only(bottom: 20.0),
//               child: CircularProgressIndicator(),
//             ),
//             Text("It won't take long."),
//             Text("Please make sure that you are using wifi.")
//           ],
//         ),
//       ),
//     );
//   }

//   // @override
//   // void dispose() {
//   //   super.dispose();
//   //   context.read<MLKitProvider>().dispose();
//   // }

//   /// shows different screens based on the state of the custom model.
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return DefaultTextStyle(
//       style: Theme.of(context).textTheme.headline2,
//       textAlign: TextAlign.center,
//       child: screenBuild(),
//     );
//   }

//   Widget screenBuild() {
//     return FutureBuilder(
//       // a previously-obtained Future<String> or null
//       future: context.read<MLKitProvider>().loadModel(),
//       builder: (BuildContext context, AsyncSnapshot snapshot) {
//         if (snapshot.hasData) {
//           return _readyScreen();
//         } else if (snapshot.hasError) {
//           return _errorScreen();
//         } else {
//           return _loadingScreen();
//         }
//       },
//     );
//   }
// }
