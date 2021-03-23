import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/screen/widgets/error_page.dart';
import 'package:flutter_hotelapp/screen/widgets/search_bar.dart';
import 'package:flutter_hotelapp/screen/widgets/shimmer_effect.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    return ChangeNotifierProvider(
      create: (_) => provider,
      child: Consumer<TreeDataProvider>(
        builder: (_, data, __) {
          switch (data.status) {
            case Status.Error:
              return ErrorPage(press: data.fetchTreeData);
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
