import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/utils/device_utils.dart';
import 'package:flutter_hotelapp/common/utils/toast_utils.dart';
import 'package:flutter_hotelapp/provider/auth_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
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

  final ImagePicker _picker = ImagePicker();
  ImageProvider _imageProvider;

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
        path: 'me@flora.com',
        queryParameters: {'subject': 'This is subject content', 'body': ''});
    String url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  Future<void> _getImage() async {
    final pickedFile =
        await _picker.getImage(source: ImageSource.gallery, maxWidth: 512);
    try {
      if (pickedFile != null) {
        if (Device.isWeb) {
          _imageProvider = NetworkImage(pickedFile.path);
        } else {
          _imageProvider = FileImage(File(pickedFile.path));
        }
      } else {
        // _imageProvider = null;
        // debugPrint('FILE PATH: 無文件被選擇');
      }
      //用於刷新 widget 顯示頭像
      setState(() {});
    } catch (e) {
      Toast.show('沒有權限使用相冊');
    }
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
          Consumer(
            builder: (_, AuthProvider user, __) {
              return ProfileHeader(
                email: '${user.email}',
                image: 'assets/images/no_picture_avatar.png',
                name: '${user.username}',
                press: _getImage,
                imageProvider: _imageProvider,
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
              if (user.token != null && user.admin == true) {
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
    );
  }
}
