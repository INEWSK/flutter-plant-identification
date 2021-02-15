import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _body(),
    );
  }

  _body() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hong Kong Orchid Tree',
              style: kH1TextStyle.copyWith(
                fontSize: 16.0,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Scientific Name: ',
                  ),
                  TextSpan(
                      text: 'Bauhinia blakeana',
                      style: kSubHeadTextStyle.copyWith(fontSize: 16.0))
                ],
              ),
            ),
            Divider(),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: 'Common Name: '),
                  TextSpan(
                    text: 'Hong Kong orchid tree',
                    style: kSubHeadTextStyle.copyWith(
                      fontSize: 16.0,
                    ),
                  )
                ],
              ),
            ),
            Divider(),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: 'Name in Chinese: '),
                  TextSpan(
                    text: '洋紫荊',
                    style: kSubHeadTextStyle.copyWith(
                      fontSize: 16.0,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Bauhinia blakeana was first discovered in Hong Kong at the end of the 19th century by the fathers of the French Mission at Pok Fu Lam and named after Sir Henry Blake, a former Governor of Hong Kong. It was selected to be Hong Kong’s emblem in 1965.With the establishment of the Hong Kong Special Administrative Region on 1st July 1997, the flower was adopted as a logo on the regional flag.',
              style: kBodyTextStyle.copyWith(fontWeight: FontWeight.w500),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Divider(),
            ),
            SectionTitle(
              icon: SvgPicture.asset('assets/icons/sp_features.svg'),
              title: 'Special Features',
            ),
            SizedBox(height: 10),
            Text(
              'During the flowering period from early November till March, purplish red flowers hanging on the tree, give out a pleasant scent. Each flower made up of 5 free spreading petals, with darker veins on the uppermost petal.',
              style: kBodyTextStyle.copyWith(fontWeight: FontWeight.w500),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Divider(),
            ),
            SectionTitle(
              icon: SvgPicture.asset('assets/icons/information.svg'),
              title: 'To Learn More',
            ),
            SizedBox(height: 10),
            Text(
              'During the flowering period from early November till March, purplish red flowers hanging on the tree, give out a pleasant scent. Each flower made up of 5 free spreading petals, with darker veins on the uppermost petal.',
              style: kBodyTextStyle.copyWith(fontWeight: FontWeight.w500),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Divider(),
            ),
            SectionTitle(
              icon: SvgPicture.asset('assets/icons/characteristics.svg'),
              title: 'Characteristics',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Divider(),
            ),
            SectionTitle(
              icon: SvgPicture.asset('assets/icons/leaf.svg'),
              title: 'Leaf',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Divider(),
            ),
            SectionTitle(
              icon: SvgPicture.asset('assets/icons/flower.svg'),
              title: 'Flower',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Divider(),
            ),
            SectionTitle(
              icon: SvgPicture.asset('assets/icons/fruit.svg'),
              title: 'Fruit',
            ),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final SvgPicture icon;
  final String title;

  const SectionTitle({Key key, @required this.icon, @required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text.rich(
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
            style: kH1TextStyle.copyWith(
              fontSize: 14.0,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }
}
