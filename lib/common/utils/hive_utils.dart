import 'package:flutter_hotelapp/models/tree_data.dart' as treeData;

import 'package:flutter_hotelapp/models/tree_info.dart' as treeInfo;
import 'package:hive/hive.dart';

class HiveUtils {
  isExists({String boxName}) async {
    final openBox = await Hive.openBox(boxName);
    int length = openBox.length;
    return length != 0;
  }

  /// add list item into the box
  addBoxes<T>(List<T> items, String boxName) async {
    print("adding boxes");
    final openBox = await Hive.openBox(boxName);

    for (var item in items) {
      openBox.add(item);
    }
  }

  // get item from box
  getBoxes<T>(String boxName) async {
    List<T> boxList = [];

    final openBox = await Hive.openBox(boxName);

    int length = openBox.length;

    for (int i = 0; i < length; i++) {
      boxList.add(openBox.getAt(i));
    }

    return boxList;
  }

  closeBoxes<T>(String boxName) async {
    final openBox = await Hive.openBox(boxName);

    await openBox.compact();
    await openBox.close();
  }

  /// register hive custom model adapter
  static registerAdapter() async {
    // home page
    Hive.registerAdapter(treeInfo.TreeInfoAdapter());
    Hive.registerAdapter(treeInfo.ResultAdapter());
    Hive.registerAdapter(treeInfo.InfoImageAdapter());
    // search & ai
    Hive.registerAdapter(treeData.TreeDataAdapter());
    Hive.registerAdapter(treeData.ResultAdapter());
    Hive.registerAdapter(treeData.TreeImageAdapter());
  }
}
