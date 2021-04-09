import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/utils/fluashbar_utils.dart';
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _body(),
    );
  }

  Widget _body() {
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
              return ShimmerEffect();
              break;
            default:
              _init(tree);
              return ShimmerEffect();
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
