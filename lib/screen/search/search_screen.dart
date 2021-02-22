import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/screen/detail/detail_sample_screen.dart';
import 'package:flutter_hotelapp/screen/detail/detail_screen.dart';
import 'package:flutter_hotelapp/screen/detail/detail_test.dart';
import 'package:flutter_hotelapp/screen/widgets/search_bar.dart';
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
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailSampleScreen(),
                  ),
                ),
                child: Text('Detail Page Template'),
              ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailTest(),
                  ),
                ),
                child: Text('Detail Page Widget Test'),
              ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(),
                  ),
                ),
                child: Text('Fetch Tree Data from Backend'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
