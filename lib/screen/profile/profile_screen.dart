import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/provider/api_provider.dart';
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

  Future<void> _toEmailDialog(BuildContext context) {
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
              onPressed: () => Navigator.pop(context, _launcherUrl()),
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _retrainingRequest(BuildContext context, ApiProvider api) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Warning'),
          content: Text('該行爲會傳送命令至伺服器要求進行圖片機器模型訓練, 過程不可逆且會消耗伺服器算力'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, api.requestRetrain()),
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
        path: 'me@treedoctor.com',
        queryParameters: {'subject': 'This is subject content', 'body': ''});
    String url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  @override
  void initState() {
    super.initState();
  }

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
          Consumer<AuthProvider>(
            builder: (_, user, __) {
              // user.initProfilePicture();
              return ProfileHeader(
                logged: user.token != null ? true : false,
                email: user.email,
                name: user.username,
                image: user.image,
                press: () {
                  if (user.status == Status.Authenticated) {
                    user.getImage();
                  } else {
                    Navigator.pushNamed(context, '/signIn');
                  }
                },
              );
            },
          ),
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
          Consumer2(
            builder: (_, AuthProvider user, ApiProvider api, __) {
              if (user.admin == true) {
                return ListTile(
                    leading: api.train
                        ? Container(
                            width: 36,
                            child: SpinKitFadingGrid(
                              color: Colors.teal,
                              size: 32,
                            ),
                          )
                        : SvgPicture.asset(
                            'assets/icons/profile/ai_retraining.svg'),
                    title: Text(api.train
                        ? 'Model is Retraining...'
                        : 'Model Retraining'),
                    onTap: api.train
                        ? null
                        : () => _retrainingRequest(context, api));
              } else {
                return Container();
              }
            },
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
            onTap: () async => _toEmailDialog(context),
          ),
        ],
      ),
    );
  }
}
