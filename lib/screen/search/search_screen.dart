import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/screen/widgets/error_page.dart';
import 'package:flutter_hotelapp/screen/widgets/shimmer_effect.dart';
import 'package:provider/provider.dart';

import 'components/leaf_card_list.dart';
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
      appBar: AppBar(),
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
              return LeafCardList(provider: data, context: context);
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
