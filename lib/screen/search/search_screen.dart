import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'components/search_box.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with AutomaticKeepAliveClientMixin<SearchScreen> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: 'Filter',
            icon: SvgPicture.asset('assets/icons/filter.svg'),
            onPressed: () {},
          )
        ],
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SearchBox(),
          ],
        ),
      ),
    );
  }
}
