import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/screen/common_widgets/circular_indicator.dart';
import 'package:provider/provider.dart';

import 'components/google_maps.dart';
import 'components/permit_error_page.dart';
import 'provider/google_maps_provider.dart';
import 'provider/permission_provider.dart';

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with AutomaticKeepAliveClientMixin<ExploreScreen> {
  @override
  bool get wantKeepAlive => true;

  final permitProvider =
      ChangeNotifierProvider(create: (_) => PermissionProvider());
  final googleMapProvider =
      ChangeNotifierProvider(create: (_) => GoogleMapsProvider());

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _body(),
    );
  }

  Widget _body() {
    return MultiProvider(
      providers: [
        permitProvider,
        googleMapProvider,
      ],
      child: Consumer2(
        builder: (_, PermissionProvider permit, GoogleMapsProvider maps, __) {
          switch (permit.status) {
            case Status.Forbidden:
              return PermitErrorPage(press: permit.requestPermission);
              break;
            case Status.Permitted:
              maps.initMarkerIcon();
              return GoogleMaps();
              break;
            default:
              permit.detectPermisstion();
              return CircularIndicator();
          }
        },
      ),
    );
  }
}
