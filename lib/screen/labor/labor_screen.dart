import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';
import 'package:flutter_hotelapp/screen/auth/widgets/welcome_text.dart';
import 'package:flutter_hotelapp/screen/labor/components/wave_effect.dart';

class LaborScreen extends StatelessWidget {
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
          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: WelcomeText(
              title: AppLocalizations.of(context).labor,
              text: AppLocalizations.of(context).laborLongText),
        ),
        ListTile(
          title: Text('Realtime Detect (Tensorflow)'),
          onTap: null,
        ),
        ListTile(title: Text('Firebase ML Kit'), onTap: () {}),
        ListTile(
            title: Text('Wave'),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => WaveDemo()))),
      ],
    );
  }
}
