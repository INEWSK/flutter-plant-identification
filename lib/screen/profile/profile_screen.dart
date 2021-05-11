import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hotelapp/common/utils/logger_utils.dart';
import 'package:flutter_hotelapp/common/utils/toast_utils.dart';
import 'package:flutter_hotelapp/provider/api_provider.dart';
import 'package:flutter_hotelapp/provider/auth_provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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

  Future<void> _toEmailDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).contactUs),
          content: Text(AppLocalizations.of(context).contactUsText),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context).no),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, _launcherUrl()),
              child: Text(AppLocalizations.of(context).yes),
            ),
          ],
        );
      },
    );
  }

  Future<void> _retrainingDialog(BuildContext context, ApiProvider api) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning_amber_outlined),
              SizedBox(width: 10),
              Text(AppLocalizations.of(context).warning),
            ],
          ),
          content: Text(AppLocalizations.of(context).modelRetrainWarningText),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context).cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(
                  context,
                  api.requestRetrain(choice: Choice.Local).then((success) {
                    if (!success) Toast.error(title: '呼叫 API 失敗');
                  })),
              child: Text(AppLocalizations.of(context).confirm),
            ),
          ],
        );
      },
    );
  }

  Widget _imageSourceOption(
      BuildContext context, String title, ImageSource source) {
    return SimpleDialogOption(
      onPressed: () {
        Navigator.pop(context, source);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Text(title),
      ),
    );
  }

  Future _selectImageSource(AuthProvider user) async {
    ImageSource source = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          // contentPadding: EdgeInsets.all(kDefaultPadding),
          title: Text(AppLocalizations.of(context).changeAvatar),
          children: [
            _imageSourceOption(
              context,
              AppLocalizations.of(context).gallery,
              ImageSource.gallery,
            ),
            _imageSourceOption(
              context,
              AppLocalizations.of(context).camera,
              ImageSource.camera,
            ),
          ],
        );
      },
    );
    if (source != null) user.getImage(source);
  }

  Future<void> _launcherUrl() async {
    final Uri params = Uri(
        scheme: 'mailto',
        path: 'me@treedoctor.com',
        queryParameters: {'subject': 'This is subject content', 'body': ''});
    String url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      LoggerUtils.show(
          messageType: Type.Error, message: 'Cloud not Launch $url');
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
          Consumer<AuthProvider>(
            builder: (_, user, __) {
              return ProfileHeader(
                logged: user.token != null ? true : false,
                email: user.email,
                name: user.username,
                image: user.image,
                press: () {
                  if (user.status == Status.Authenticated) {
                    _selectImageSource(user);
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
            title: Text(AppLocalizations.of(context).manual),
            onTap: () {},
          ),
          ListTile(
            // dense: true,
            leading: SvgPicture.asset('assets/icons/profile/favorite.svg'),
            title: Text(AppLocalizations.of(context).favorite),
            onTap: () {},
          ),
          Consumer2(
            builder: (_, AuthProvider user, ApiProvider api, __) {
              if (user.admin == true) {
                return ListTile(
                  leading: api.training
                      ? Container(
                          width: 36,
                          child: SpinKitFadingGrid(
                            color: Colors.teal,
                            size: 32,
                          ),
                        )
                      : SvgPicture.asset(
                          'assets/icons/profile/ai_retraining.svg'),
                  title: Text(
                    api.training
                        ? AppLocalizations.of(context).retrainingModel
                        : AppLocalizations.of(context).modelRetraining,
                  ),
                  onTap: api.training
                      ? null
                      : () => _retrainingDialog(context, api),
                );
              } else {
                return Container();
              }
            },
          ),
          ListTile(
            // dense: true,
            leading: SvgPicture.asset('assets/icons/profile/settings.svg'),
            title: Text(AppLocalizations.of(context).settings),
            onTap: () => Navigator.pushNamed(context, '/settings'),
          ),
          ListTile(
            // dense: true,
            leading: SvgPicture.asset('assets/icons/profile/fqa.svg'),
            title: Text(AppLocalizations.of(context).fqa),
            onTap: () => Navigator.pushNamed(context, '/fqa'),
          ),
          ListTile(
            // dense: true,
            leading: SvgPicture.asset('assets/icons/profile/contact.svg'),
            title: Text(AppLocalizations.of(context).contactUs),
            onTap: () async => _toEmailDialog(context),
          ),
        ],
      ),
    );
  }
}
