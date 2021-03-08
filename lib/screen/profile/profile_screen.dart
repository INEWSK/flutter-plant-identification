import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';
import 'package:flutter_hotelapp/provider/auth_provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Consumer<AuthProvider>(builder: (_, user, __) {
            return ProfileHeader(
              email: '${user.email}',
              image: 'assets/images/no_picture_avatar.png',
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
            onTap: () async => _confirmToEmailDialog(context),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmToEmailDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Contact Us'),
          content: Text('This will lead you to the email application'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(
                context,
                _launcherUrl(),
              ),
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _launcherUrl() async {
    final Uri params = Uri(
        scheme: 'mailto',
        path: 'me@flora.com',
        queryParameters: {'subject': 'This is subject content', 'body': ''});
    String url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }
}
