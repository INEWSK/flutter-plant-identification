import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';

class FQAScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: kDefaultPadding,
            vertical: kDefaultPadding / 2,
          ),
          child: Text(
            AppLocalizations.of(context).faqText,
          ),
        ),
        QuestionCell(
          title: 'How exactly does the app work?',
          press: () {},
        ),
        QuestionCell(
          title: 'Do you guarantee protection of my personal data?',
          press: () {},
        ),
        QuestionCell(
          title:
              'What to do if my camera is stuck while identifying the plant and no result is found?',
          press: () {},
        ),
        QuestionCell(
          title:
              'Is it obligatory to give Tree Doctor aaccess permission to my gallery and camera?',
          press: () {},
        ),
        QuestionCell(
          title:
              'Can I use snaps from my phone gallery? Or only new pictures will accepted?',
          press: () {},
        ),
        QuestionCell(
          title:
              'Should my device have access to the Internet while using Tree Doctor?',
          press: () {},
        ),
      ],
    );
  }
}

/// 遇見一個問題, Row 不支持長文本自動換行
/// 02/02/2021 解決: 使用 flexible 包裹 text 組件
/// 08/02/2021 轉用原生 ListTile Widget

class QuestionCell extends StatelessWidget {
  final String title;
  final Function press;

  const QuestionCell({
    Key key,
    @required this.title,
    @required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: kBodyTextStyle,
      ),
      leading: Icon(Icons.search),
      onTap: press,
    );
  }
}
