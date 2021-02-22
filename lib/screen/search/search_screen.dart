import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/screen/detail/detail_screen.dart';
import 'package:flutter_hotelapp/screen/widgets/search_bar.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: 'Filter',
            icon: SvgPicture.asset('assets/icons/filter.svg'),
            onPressed: () {
              showSearch(context: context, delegate: SearchBar());
            },
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(),
                  ),
                ),
                child: Text('Go to Detail Page'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
