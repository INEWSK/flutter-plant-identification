import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';
import 'package:flutter_hotelapp/provider/auth_provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
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

  Future<void> _retrainingRequest(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('AI Retraining Request'),
          content: Text('Send a request to server to train new model'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(
                context,
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
      child: AnimationLimiter(
        child: Column(
          children: AnimationConfiguration.toStaggeredList(
            childAnimationBuilder: (widget) => SlideAnimation(
                child: ScaleAnimation(
              duration: (kDefaultDuration * 0.5),
              child: widget,
            )),
            children: [
              Consumer<AuthProvider>(
                builder: (_, user, __) {
                  // user.initProfilePicture();
                  return ProfileHeader(
                    email: '${user.email}',
                    name: '${user.username}',
                    image: user.image,
                    press: () {
                      if (user.status == Status.Authenticated) user.getImage();
                    },
                  );
                },
              ),
              SizedBox(height: 10),
              ListTile(
                // dense: true,
                leading: SvgPicture.asset('assets/icons/profile/manual.svg'),
                title: Text('Manual'),
                onTap: null,
              ),
              ListTile(
                // dense: true,
                leading: SvgPicture.asset('assets/icons/profile/favorite.svg'),
                title: Text('Favorite'),
                onTap: null,
              ),
              Consumer<AuthProvider>(
                builder: (BuildContext context, user, Widget child) {
                  if (user.admin == true) {
                    return ListTile(
                      leading: SvgPicture.asset(
                          'assets/icons/profile/ai_retraining.svg'),
                      title: Text('AI Retraining'),
                      onTap: () async => _retrainingRequest(context),
                    );
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
        ),
      ),
    );
  }
}
