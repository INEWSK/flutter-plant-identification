import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/provider/auth_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'components/profile_header.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin<ProfileScreen> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<AuthProvider>(builder: (_, user, __) {
              return ProfileHeader(
                email: '${user.email}',
                image: 'assets/images/avatar.png',
                name: '${user.username}',
              );
            }),
            SizedBox(height: 10),
            ListTile(
              // dense: true,
              leading: SvgPicture.asset('assets/icons/profile/manual.svg'),
              title: Text('Manual'),
              onTap: () {},
            ),
            ListTile(
              // dense: true,
              leading: SvgPicture.asset('assets/icons/profile/favorite.svg'),
              title: Text('Favorite'),
              onTap: () {},
            ),
            ListTile(
              // dense: true,
              leading: SvgPicture.asset('assets/icons/profile/settings.svg'),
              title: Text('Settings'),
              onTap: () => Navigator.pushNamed(context, '/settings'),
            ),
            ListTile(
              // dense: true,
              leading: SvgPicture.asset('assets/icons/profile/fqa.svg'),
              title: Text('FQA'),
              onTap: () => Navigator.pushNamed(context, '/fqa'),
            ),
            ListTile(
              // dense: true,
              leading: SvgPicture.asset('assets/icons/profile/contact.svg'),
              title: Text('Contact Us'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
