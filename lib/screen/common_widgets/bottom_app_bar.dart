import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavBar extends StatelessWidget {
  final Function onTap;
  final int currentIndex;

  const BottomNavBar({Key key, this.onTap, this.currentIndex})
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
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          items.length,
          (index) => bottomAppBarItem(
            icon: _buildNavbarIcon(
                src: items[index]['icon'],
                isActive:
                    (currentIndex >= 2 ? currentIndex + 1 : currentIndex) ==
                        index),
            // onPressed: () {},
            title: items[index]['title'],
          ),
        ),
      ),
    );
  }

  Widget _buildNavbarIcon({@required String src, bool isActive = false}) {
    return SvgPicture.asset(
      src,
      height: 24.0,
      width: 24.0,
      color: isActive ? Colors.teal : Color(0xFF868686),
    );
  }

  Widget bottomAppBarItem({@required Widget icon, String title}) {
    //构造返回的Widget
    Widget item = Container(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            Text(
              title,
            )
          ],
        ),
        onTap: () => onTap,
      ),
    );
    return item;
  }
}
