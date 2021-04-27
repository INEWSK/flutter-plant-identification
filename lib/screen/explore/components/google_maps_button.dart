import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hotelapp/common/utils/device_utils.dart';

class GoogleMapsButton extends StatelessWidget {
  final VoidCallback locate;
  final VoidCallback refresh;

  const GoogleMapsButton({
    Key key,
    this.locate,
    this.refresh,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment:
            Device.isAndroid ? Alignment.topRight : Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              FloatingActionButton(
                tooltip: AppLocalizations.of(context).locate,
                heroTag: 'lctbtn',
                onPressed: locate,
                child: Icon(Icons.my_location),
              ),
              SizedBox(height: 16.0),
              // FloatingActionButton(
              //   tooltip: 'Referesh',
              //   heroTag: 'refreshbtn',
              //   onPressed: refresh,
              //   child: Icon(Icons.refresh),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
