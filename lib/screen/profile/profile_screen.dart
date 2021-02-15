import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';
import 'package:flutter_hotelapp/common/utils/toast_utils.dart';
import 'package:flutter_hotelapp/provider/auth_provider.dart';
import 'package:flutter_hotelapp/screen/auth/widgets/primary_button.dart';
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
            onTap: () async {
              contactBottomSheet(context);
            },
          ),
        ],
      ),
    );
  }

  contactBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          // percentage layout
          // 85% height of mediaQuery size
          heightFactor: 0.85,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contact us'.toUpperCase(),
                    style: kH2TextStyle,
                  ),
                  TextField(
                    controller: TextEditingController(text: 'contact@flora.me'),
                    enabled: false,
                    decoration: (InputDecoration(
                        labelText: 'Recipient:'.toUpperCase())),
                  ),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: (InputDecoration(
                        labelText: 'Your email:'.toUpperCase())),
                  ),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: (InputDecoration(
                      labelText: 'Topic:'.toUpperCase(),
                    )),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 9,
                    decoration:
                        InputDecoration(hintText: 'Content here'.toUpperCase()),
                  ),
                  SizedBox(height: 20),
                  PrimaryButton(
                      text: 'send', press: () => Navigator.pop(context)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
