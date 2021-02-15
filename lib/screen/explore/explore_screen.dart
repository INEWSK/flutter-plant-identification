import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/google_maps.dart';
import 'components/location_error_page.dart';
import 'provider/google_maps_provider.dart';

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with AutomaticKeepAliveClientMixin<ExploreScreen> {
  @override
  bool get wantKeepAlive => true;

  final provider = GoogleMapsProvider();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: _body(),
    );
  }

  Widget _body() {
    return ChangeNotifierProvider(
      create: (_) => provider,
      child: Consumer<GoogleMapsProvider>(
        builder: (_, location, __) {
          switch (location.status) {
            case Status.Unauthorized:
              return LocationErrorPage(press: location.requestPermission);
              break;
            case Status.Authorization:
              return GoogleMaps();
            default:
              return Loading();
          }
        },
      ),
    );
  }
}

class Loading extends StatelessWidget {
  determindPermission(context) async =>
      Provider.of<GoogleMapsProvider>(context).determindPermission();

  @override
  Widget build(BuildContext context) {
    determindPermission(context);
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
