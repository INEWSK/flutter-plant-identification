import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hotelapp/common/utils/toast_utils.dart';
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

  /// shimmer effect 在 darkmode 不友好, 改用 loading icon widget
  Widget _loading() {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitWave(color: Colors.teal, size: 50),
            SizedBox(height: 40),
            Text(AppLocalizations.of(context).dataLoading)
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
    return Consumer<SearchProvider>(builder: (_, tree, __) {
      switch (tree.status) {
        case Status.Error:
          return ErrorPage(
            press: () async {
              final success = await tree.fetchApiData();
              if (!success) {
                Toast.error(
                  title: AppLocalizations.of(context).callApiFailed,
                  subtitle: AppLocalizations.of(context).stillBuyCoffee,
                );
              }
            },
          );
          break;
        case Status.Loaded:
          return TreeList();
          break;
        case Status.Hive:
          return TreeList();
          break;
        case Status.Loading:
          return brightness == Brightness.light ? ShimmerEffect() : _loading();
          break;
        default:
          tree.fetchApiData().then((success) {
            if (!success) {
              if (tree.status == Status.Hive) {
                Toast.error(
                  title: AppLocalizations.of(context).callApiFailed,
                  subtitle: AppLocalizations.of(context).loadLocalData,
                );
              } else {
                Toast.error(
                  title: AppLocalizations.of(context).noApiAndNoLocalData,
                  subtitle: AppLocalizations.of(context).buyCoffee,
                );
              }
            }
          });
          return brightness == Brightness.light ? ShimmerEffect() : _loading();
      }
    });
  }
}
