import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/utils/fluashbar_utils.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'components/error_page.dart';
import 'components/tree_list.dart';
import 'components/shimmer_effect.dart';
import 'provider/search_provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with AutomaticKeepAliveClientMixin<SearchScreen> {
  @override
  bool get wantKeepAlive => true;

  final provider = SearchProvider();

  Widget _loading() {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitWave(color: Colors.teal, size: 50),
            SizedBox(height: 20),
            Text('Loading Tree Data From Server')
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _body(),
    );
  }

  Widget _body() {
    final brightness = Theme.of(context).brightness;
    return ChangeNotifierProvider(
      create: (_) => provider,
      child: Consumer(
        builder: (_, SearchProvider tree, __) {
          switch (tree.status) {
            case Status.Error:
              return ErrorPage(press: () async {
                final response = await tree.fetchData();

                final String result = response['message'];
                final bool success = response['success'];

                if (!success) {
                  Flush.error(context, message: result);
                }
              });
              break;
            case Status.Loaded:
              return TreeList();
              break;
            case Status.Loading:
              return brightness == Brightness.light
                  ? ShimmerEffect()
                  : _loading();
              break;
            default:
              _init(tree);
              return brightness == Brightness.light
                  ? ShimmerEffect()
                  : _loading();
          }
        },
      ),
    );
  }

  void _init(SearchProvider tree) async {
    final response = await tree.fetchData();

    final String result = response['message'];
    final bool success = response['success'];

    if (!success) {
      Flush.error(context, message: result);
    }
  }
}
