import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DetailSampleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    return Scaffold(
      appBar: AppBar(),
      body: _body(context, brightness),
    );
  }

  _body(BuildContext context, Brightness brightness) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hong Kong Orchid Tree',
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
                      'Bauhinia blakeana',
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
                      'Hong Kong orchid tree',
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
                    child: Text('洋紫荊'),
                  ),
                ])
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Bauhinia blakeana was first discovered in Hong Kong at the end of the 19th century by the fathers of the French Mission at Pok Fu Lam and named after Sir Henry Blake, a former Governor of Hong Kong. It was selected to be Hong Kong’s emblem in 1965.With the establishment of the Hong Kong Special Administrative Region on 1st July 1997, the flower was adopted as a logo on the regional flag.',
              style: kBodyTextStyle,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            SectionCell(
              icon: SvgPicture.asset('assets/icons/sp_features.svg'),
              title: 'Special Features',
              desc:
                  'During the flowering period from early November till March, purplish red flowers hanging on the tree, give out a pleasant scent. Each flower made up of 5 free spreading petals, with darker veins on the uppermost petal.',
            ),
            SectionCell(
              icon: SvgPicture.asset('assets/icons/information.svg'),
              title: 'To Learn More',
              desc:
                  'During the flowering period from early November till March, purplish red flowers hanging on the tree, give out a pleasant scent. Each flower made up of 5 free spreading petals, with darker veins on the uppermost petal.',
            ),
            SectionCell(
              icon: SvgPicture.asset('assets/icons/characteristics.svg'),
              title: 'Characteristics',
            ),
            CharacteristicTable(
              family: 'Caesalpiniaceae',
              height: 'Medium-sized, 10 to 20 metres',
              nature: 'Evergreen',
              branch: 'Long and spreading or drooping branches.',
              bark:
                  'Bark greyish white or light brown in colour, with inconspicuous lenticels on the surface.',
            ),
            SectionCell(
              icon: SvgPicture.asset('assets/icons/leaf.svg'),
              title: 'Leaf',
              desc: '•	Simple leaves, alternate, two-lobed, with equal length and width, 8 to 15 cm in length.' +
                  '\n •	Leaf apex deeply notched to 1/4 or 1/3 of the blade length, base heart-shaped, margin entire; surfaces smooth and hairless.' +
                  '\n •	Veins radiating from the leaf base.',
            ),
            SectionCell(
              icon: SvgPicture.asset('assets/icons/flower.svg'),
              title: 'Flower',
              desc: '•	Flowers bisexual, irregular, flowering from early November to March.' +
                  '\n •	Rich magenta purple in colour, fragrant; made up of 5 free spreading petals, with darker veins on the uppermost petal.',
            ),
            SectionCell(
              icon: SvgPicture.asset('assets/icons/fruit.svg'),
              title: 'Fruit',
              desc: '•	This species rarely produces seed. It is propagated by air layering, stem cuttings or grafting.' +
                  '\n •	It is believed that all the Bauhinia Blakeana were propagated from the same tree discovered on Hong Kong Island a hundred years ago.',
            ),
          ],
        ),
      ),
    );
  }
}

class SectionCell extends StatelessWidget {
  final SvgPicture icon;
  final String title;
  final String desc;

  const SectionCell({
    Key key,
    @required this.icon,
    @required this.title,
    this.desc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionDivider(),
        Text.rich(
          TextSpan(
            children: [
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: icon,
                ),
              ),
              TextSpan(
                text: title,
                style: kSubHeadTextStyle,
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        desc != null
            ? Text(
                desc,
                style: kBodyTextStyle,
                // maxLines: 4,
                // overflow: TextOverflow.ellipsis,
              )
            : Container(),
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
