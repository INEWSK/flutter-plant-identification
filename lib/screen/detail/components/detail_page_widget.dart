import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'section_cell.dart';

class DetailPageWidget extends StatelessWidget {
  final String imageUrl;
  final String commonName;
  final String scientificName;
  final String chineseName;
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

  const DetailPageWidget(
      {Key key,
      @required this.imageUrl,
      @required this.commonName,
      @required this.scientificName,
      @required this.chineseName,
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
      this.cBark})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
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
            background: Image.asset(
              // header image
              imageUrl,
              fit: BoxFit.fitHeight,
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
                          'Scientific Name:',
                          style: kSubHeadTextStyle,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          scientificName ?? '',
                          style: kBodyTextStyle.copyWith(color: Colors.green),
                        ),
                      ),
                    ]),
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          'Common Name:',
                          style: kSubHeadTextStyle,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        decoration: BoxDecoration(color: Colors.lightGreen[50]),
                        child: Text(
                          commonName,
                          // 解決暗色模式時背景色導致字體看不見問題
                          style: brightness == Brightness.dark
                              ? TextStyle(color: Colors.black)
                              : TextStyle(),
                        ),
                      ),
                    ]),
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          'Name in Chinese:',
                          style: kSubHeadTextStyle,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          chineseName ?? '',
                          style: kBodyTextStyle,
                        ),
                      ),
                    ])
                  ],
                ),
                SizedBox(height: 20),
                basicIntro != null
                    ? Text(
                        basicIntro,
                        style: kBodyTextStyle,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      )
                    : SizedBox(),
                specialFeatures != null
                    ? SectionCell(
                        icon: SvgPicture.asset('assets/icons/sp_features.svg'),
                        title: 'Special Features',
                        content: specialFeatures,
                      )
                    : SizedBox(),
                learnMore != null
                    ? SectionCell(
                        icon: SvgPicture.asset('assets/icons/information.svg'),
                        title: 'To Learn More',
                        content: learnMore,
                      )
                    : SizedBox(),
                SectionCell(
                  icon: SvgPicture.asset('assets/icons/characteristics.svg'),
                  title: 'Characteristics',
                ),
                CharacteristicTable(
                  family: cFamily ?? '',
                  height: cHeight ?? '',
                  nature: cNatureLeaf ?? '',
                  branch: cBranch ?? '',
                  bark: cBark ?? '',
                ),
                leafIntro != null
                    ? SectionCell(
                        icon: SvgPicture.asset('assets/icons/leaf.svg'),
                        title: 'Leaf',
                        content: leafIntro,
                      )
                    : SizedBox(),
                flowerIntro != null
                    ? SectionCell(
                        icon: SvgPicture.asset('assets/icons/flower.svg'),
                        title: 'Flower',
                        content: flowerIntro,
                      )
                    : SizedBox(),
                fruitIntro != null
                    ? SectionCell(
                        icon: SvgPicture.asset('assets/icons/fruit.svg'),
                        title: 'Fruit',
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
    var brightness = MediaQuery.of(context).platformBrightness;
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
              'Family:',
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
              'Height:',
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
              'Nature of Leaf:',
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
              'Branch:',
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
              'Bark:',
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
