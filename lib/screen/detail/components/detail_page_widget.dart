import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';
import 'package:flutter_hotelapp/common/utils/image_utils.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'section_cell.dart';

class DetailPageWidget extends StatelessWidget {
  final String treeImage;
  final String commonName;
  final String scientificName;
  final String basicIntro;
  final String specialFeatures;
  final String learnMore;
  final String leafIntro;
  final String flowerIntro;
  final String fruitIntro;
  final String cFamily;
  final String cHeight;
  final String cNatureLeaf;
  final String cBranch;
  final String cBark;

  const DetailPageWidget({
    Key key,
    @required this.treeImage,
    @required this.commonName,
    @required this.scientificName,
    @required this.basicIntro,
    @required this.specialFeatures,
    @required this.learnMore,
    @required this.leafIntro,
    @required this.flowerIntro,
    @required this.fruitIntro,
    this.cFamily,
    this.cHeight,
    this.cNatureLeaf,
    this.cBranch,
    this.cBark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String noMoreInfo = AppLocalizations.of(context).noMoreInfo;
    var brightness = Theme.of(context).brightness;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          pinned: false, //固定appbar
          expandedHeight: 160.0, //可視高度
          floating: false, // 下拉顯示
          stretch: true, // overall
          flexibleSpace: FlexibleSpaceBar(
            stretchModes: [
              StretchMode.zoomBackground,
              StretchMode.blurBackground,
              StretchMode.fadeTitle
            ],
            background: Hero(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: treeImage != null
                        ? ImageUtils.getImageProvider(treeImage)
                        : ImageUtils.getAssetImage(
                            'nophoto',
                            format: ImageFormat.jpg,
                          ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              tag: treeImage != null ? treeImage : 'noPhoto',
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.all(kDefaultPadding),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                Text(
                  commonName,
                  style: kH1TextStyle.copyWith(fontSize: 14.0),
                ),
                SizedBox(height: 10),
                Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  columnWidths: {
                    0: FlexColumnWidth(4),
                    1: FlexColumnWidth(6),
                  },
                  border: TableBorder(
                      horizontalInside: BorderSide(
                    width: 1.0,
                    color: Colors.grey[300],
                  )),
                  children: [
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          AppLocalizations.of(context).treeScientificName,
                          style: kSubHeadTextStyle,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          scientificName ?? noMoreInfo,
                          style: kBodyTextStyle.copyWith(color: Colors.teal),
                        ),
                      ),
                    ]),
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          AppLocalizations.of(context).treeCommonName,
                          style: kSubHeadTextStyle,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        decoration: BoxDecoration(color: Colors.lightGreen[50]),
                        child: Text(
                          commonName ?? noMoreInfo,
                          // 解決暗色模式時背景色導致字體看不見問題
                          style: brightness == Brightness.dark
                              ? TextStyle(color: Colors.black)
                              : TextStyle(),
                        ),
                      ),
                    ]),
                  ],
                ),
                SizedBox(height: 10),
                basicIntro != ''
                    ? Text(
                        basicIntro,
                        style: kBodyTextStyle,
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                      )
                    : SizedBox(),
                specialFeatures != ''
                    ? SectionCell(
                        icon: SvgPicture.asset('assets/icons/sp_features.svg'),
                        title: AppLocalizations.of(context).treeSpecialFeatures,
                        content: specialFeatures,
                      )
                    : SizedBox(),
                learnMore != ''
                    ? SectionCell(
                        icon: SvgPicture.asset('assets/icons/information.svg'),
                        title: AppLocalizations.of(context).treeToLearnMore,
                        content: learnMore,
                      )
                    : SizedBox(),
                SectionCell(
                  icon: SvgPicture.asset('assets/icons/characteristics.svg'),
                  title: AppLocalizations.of(context).treeCharacteristics,
                ),
                CharacteristicTable(
                  family: cFamily != '' ? cFamily : noMoreInfo,
                  height: cHeight != '' ? cHeight : noMoreInfo,
                  nature: cNatureLeaf != '' ? cNatureLeaf : noMoreInfo,
                  branch: cBranch != '' ? cBranch : noMoreInfo,
                  bark: cBark != '' ? cBark : noMoreInfo,
                ),
                leafIntro != ''
                    ? SectionCell(
                        icon: SvgPicture.asset('assets/icons/leaf.svg'),
                        title: AppLocalizations.of(context).treeLeaf,
                        content: leafIntro,
                      )
                    : SizedBox(),
                flowerIntro != ''
                    ? SectionCell(
                        icon: SvgPicture.asset('assets/icons/flower.svg'),
                        title: AppLocalizations.of(context).treeFlower,
                        content: flowerIntro,
                      )
                    : SizedBox(),
                fruitIntro != ''
                    ? SectionCell(
                        icon: SvgPicture.asset('assets/icons/fruit.svg'),
                        title: AppLocalizations.of(context).treeFruit,
                        content: fruitIntro,
                      )
                    : SizedBox(),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class CharacteristicTable extends StatelessWidget {
  const CharacteristicTable({
    Key key,
    @required this.family,
    @required this.height,
    @required this.nature,
    @required this.branch,
    @required this.bark,
  }) : super(key: key);

  final String family;
  final String height;
  final String nature;
  final String branch;
  final String bark;

  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: {
        0: FlexColumnWidth(4),
        1: FlexColumnWidth(6),
      },
      border: TableBorder(
          horizontalInside: BorderSide(
        width: 1.0,
        color: Colors.grey[300],
      )),
      children: [
        TableRow(children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              AppLocalizations.of(context).treeTableFamily,
              style: kSubHeadTextStyle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              family,
              style: kSecondaryBodyTextStyle,
            ),
          ),
        ]),
        TableRow(children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              AppLocalizations.of(context).tableHeight,
              style: kSubHeadTextStyle,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            decoration: BoxDecoration(color: Colors.lightGreen[50]),
            child: Text(
              height,
              style: brightness == Brightness.dark
                  ? kSecondaryBodyTextStyle.copyWith(color: Colors.black)
                  : kSecondaryBodyTextStyle,
            ),
          ),
        ]),
        TableRow(children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              AppLocalizations.of(context).tableNatureLeaf,
              style: kSubHeadTextStyle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              nature,
              style: kSecondaryBodyTextStyle,
            ),
          ),
        ]),
        TableRow(children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              AppLocalizations.of(context).tableBranch,
              style: kSubHeadTextStyle,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            decoration: BoxDecoration(color: Colors.lightGreen[50]),
            child: Text(
              branch,
              style: brightness == Brightness.dark
                  ? kSecondaryBodyTextStyle.copyWith(color: Colors.black)
                  : kSecondaryBodyTextStyle,
            ),
          ),
        ]),
        TableRow(children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              AppLocalizations.of(context).tableBark,
              style: kSubHeadTextStyle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              bark,
              style: kSecondaryBodyTextStyle,
            ),
          ),
        ]),
      ],
    );
  }
}

class SectionDivider extends StatelessWidget {
  const SectionDivider({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Divider(),
    );
  }
}
