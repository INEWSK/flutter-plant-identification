import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/screen/common_widgets/circular_indicator.dart';
import 'package:provider/provider.dart';

import 'components/google_maps.dart';
import 'components/location_error_page.dart';
import 'provider/permission_provider.dart';

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with AutomaticKeepAliveClientMixin<ExploreScreen> {
  @override
  bool get wantKeepAlive => true;

  final provider = PermissionProvider();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _body(),
    );
  }

  Widget _body() {
    return ChangeNotifierProvider(
      create: (_) => provider,
      child: Consumer<PermissionProvider>(
        builder: (_, permit, __) {
          switch (permit.status) {
            case Status.Forbidden:
              return LocationErrorPage(press: permit.requestPermission);
              break;
            case Status.Permitted:
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
