import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BottomTabBar extends StatelessWidget {
  final Function onTap;
  final int index;

  const BottomTabBar({Key key, @required this.onTap, @required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // list of bottom navbar items
    List<Map<String, dynamic>> items = [
      {
        "icon": "assets/icons/navbar/home.svg",
        "title": AppLocalizations.of(context).homePage
      },
      {
        "icon": "assets/icons/navbar/explore.svg",
        "title": AppLocalizations.of(context).explorePage
      },
      {"icon": "assets/icons/navbar/transparent.svg", "title": ""},
      {
        "icon": "assets/icons/navbar/search.svg",
        "title": AppLocalizations.of(context).searchPage
      },
      {
        "icon": "assets/icons/navbar/profile.svg",
        "title": AppLocalizations.of(context).profilePage
      }
    ];

    /// 忽略 navbar 第三個按鈕的 event
    return CupertinoTabBar(
      onTap: onTap,
      currentIndex: index >= 2 ? index + 1 : index,
      activeColor: Color(0xFF27A09E),
      inactiveColor: Color(0xFF868686),
      iconSize: 24.0,
      items: List.generate(
        items.length,
        (i) => BottomNavigationBarItem(
          icon: _buildNavbarIcon(
              src: items[i]['icon'],
              isActive: (index >= 2 ? index + 1 : index) == i),
          label: items[i]['title'],
        ),
      ),
    );
  }

  Widget _buildNavbarIcon({@required String src, bool isActive = false}) {
    return SvgPicture.asset(
      src,
      height: 24.0,
      width: 24.0,
      color: isActive ? Color(0xFF27A09E) : Color(0xFF868686),
    );
  }
}
