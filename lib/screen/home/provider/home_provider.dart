import 'package:flutter/cupertino.dart';
import 'package:flutter_hotelapp/models/tree_info.dart';

class HomeProvider extends ChangeNotifier {
  List<TreeInfo> _list = [];

  List<TreeInfo> get list => _list;
}
