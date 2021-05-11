import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';
import 'package:flutter_hotelapp/common/utils/toast_utils.dart';
import 'package:flutter_hotelapp/screen/home/provider/home_provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

import 'intro_card.dart';

class InfoApiList extends StatefulWidget {
  @override
  _InfoApiListState createState() => _InfoApiListState();
}

class _InfoApiListState extends State<InfoApiList> {
  final _refreshController = EasyRefreshController();

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (_, home, __) {
        return EasyRefresh(
          controller: _refreshController,
          child: AnimationLimiter(
            child: ListView.builder(
              shrinkWrap: true, // 填充
              physics: NeverScrollableScrollPhysics(), // 禁 listview 自身滾動
              addAutomaticKeepAlives: false, // 本體已包裹在 autoKeepAlive, 禁用
              itemCount: home.list.length,
              itemBuilder: (context, index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: kDefaultDuration,
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: IntroCard(
                        index: index,
                        sort: home.list[index].infoType,
                        title: home.list[index].title,
                        text: home.list[index].content,
                        image: home.list[index].infoImages?.isNotEmpty ?? true
                            ? home.list[index].infoImages?.first?.infoImage ??
                                null
                            : null,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          onRefresh: () async => await home.refresh().then((success) {
            if (!success)
              Toast.error(
                icon: Icons.wifi_lock,
                title: 'Ooops!!',
                subtitle: AppLocalizations.of(context).alienCutNetwork,
              );
            _refreshController.resetLoadState();
          }),
          // 本地數據庫沒有加載更多的 function 提供
          onLoad: home.status == Status.Hive
              ? null
              : () async => await home.loadMore().then((success) {
                    if (!success)
                      Toast.error(
                        icon: Icons.wifi_lock,
                        title: AppLocalizations.of(context).callApiFailed,
                        subtitle: AppLocalizations.of(context).loadDataFailed,
                      );
                    _refreshController.finishLoad();
                  }),
          //之後在此自定義文字
          header: ClassicalHeader(
            refreshText: AppLocalizations.of(context).refreshText,
            refreshReadyText: AppLocalizations.of(context).refreshReadyText,
            refreshingText: AppLocalizations.of(context).refreshingText,
            refreshedText: AppLocalizations.of(context).refreshedText,
          ),
          footer: ClassicalFooter(
            loadText: AppLocalizations.of(context).loadMoreText,
            loadReadyText: AppLocalizations.of(context).loadReadyText,
            loadingText: AppLocalizations.of(context).loadingText,
            loadedText: AppLocalizations.of(context).loadedText,
          ),
        );
      },
    );
  }
}
