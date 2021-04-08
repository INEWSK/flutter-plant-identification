import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/error_page.dart';
import 'components/tree_list_build.dart';
import 'components/shimmer_effect.dart';
import 'provider/tree_data_provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with AutomaticKeepAliveClientMixin<SearchScreen> {
  @override
  bool get wantKeepAlive => true;

  final provider = TreeDataProvider();

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
      child: Consumer<TreeDataProvider>(
        builder: (_, data, __) {
          switch (data.status) {
            case Status.Error:
              return ErrorPage(press: () => provider.fetchTreeData());
              break;
            case Status.Loaded:
              return TreeListBuild(provider: data, context: context);
              break;
            case Status.Loading:
              return ShimmerEffect();
              break;
            default:
              data.fetchTreeData();
              return ShimmerEffect();
          }
        },
      ),
    );
  }
}
