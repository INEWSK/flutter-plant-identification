// import 'package:flutter/material.dart';
// import 'package:flutter_hotelapp/common/styles/styles.dart';
// import 'package:flutter_hotelapp/common/utils/image_utils.dart';
// import 'package:flutter_hotelapp/common/utils/screen_utils.dart';
// import 'package:flutter_hotelapp/models/tree_data.dart';

// class TreeCard extends StatelessWidget {
//   final String tag;
//   final Result data;
//   final Function press;

//   const TreeCard({
//     Key key,
//     this.tag,
//     @required this.data,
//     @required this.press,
//   }) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: .5,
//       clipBehavior: Clip.antiAlias,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ListTile(
//             title: Text(data.commonName),
//             subtitle: Text(
//               data.scientificName,
//               style: kSecondaryBodyTextStyle,
//             ),
//           ),
//           _image(context),
//           _intro(),
//           // _button(),
//         ],
//       ),
//     );
//   }

//   Widget _intro() {
//     return GestureDetector(
//       onTap: press,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
//         child: data.introduction != null
//             ? Text(
//                 data.introduction,
//                 maxLines: 3,
//                 overflow: TextOverflow.ellipsis,
//                 style: kBodyTextStyle,
//               )
//             : Container(),
//       ),
//     );
//   }

//   Widget _image(context) {
//     // image provider解決 connection closed 問題
//     return FutureBuilder(
//       future: _imageUrl(),
//       builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//         if (snapshot.hasData) {
//           return Container(
//             // clipBehavior: Clip.antiAlias,
//             width: Screen.width(context),
//             height: Screen.height(context) * 0.25, //25% of screen
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: ImageUtils.getImageProvider(snapshot.data),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           );
//         } else {
//           return Center(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: CircularProgressIndicator(),
//             ),
//           );
//         }
//       },
//     );
//   }

//   _imageUrl() async {
//     String imgUrl;

//     if (data.treeImages.isNotEmpty) {
//       imgUrl = data.treeImages.first.treeImage;
//       return imgUrl;
//     } else {
//       imgUrl = 'assets/images/nophoto.jpg';
//       return imgUrl;
//     }
//   }
// }
