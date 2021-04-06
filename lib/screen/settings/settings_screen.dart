import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';
import 'package:flutter_hotelapp/common/utils/toast_utils.dart';
import 'package:flutter_hotelapp/provider/auth_provider.dart';
import 'package:flutter_hotelapp/provider/theme_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  _confirmSignOutDialog(BuildContext context) async {
    bool signout = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Logout'),
            content: Text('Do you want to sign out with this account?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Yes'),
              ),
            ],
          );
        });
    if (signout) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      // call sign out method
      authProvider.signOut();

      Navigator.of(context).pop(
        Toast.show('Sign Out Successful'),
      );
    }
  }

  _selectThemeDialog(BuildContext context) async {
    int i = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text('Select Theme'),
            children: [
              _themeModeOption(context, 1, 'Light Mode'),
              _themeModeOption(context, 2, 'Dark Mode'),
              _themeModeOption(context, 0, 'System Mode'),
            ],
          );
        });
    if (i != null) {
      final ThemeMode themeMode = i == 0
          ? ThemeMode.system
          : (i == 1 ? ThemeMode.light : ThemeMode.dark);
      // 等價於 provider.of(context)
      context.read<ThemeProvider>().setTheme(themeMode);
    }
  }

  _selectLanguageDialog(BuildContext context) async {
    int i = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text('Select Language'),
            children: [
              _languageSelect(context, 1, 'Traditional Chinese'),
              _languageSelect(context, 2, 'English'),
            ],
          );
        });
    if (i != null) {
      log("language selected: ${i == 1 ? "Chinese" : "English"} ");
    }
  }

  Widget _themeModeOption(BuildContext context, int i, String title) {
    return SimpleDialogOption(
      onPressed: () => Navigator.pop(context, i),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Text(title),
      ),
    );
  }

  Widget _languageSelect(BuildContext context, int i, String title) {
    return SimpleDialogOption(
      onPressed: () => Navigator.pop(context, i),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Text(title),
      ),
    );
  }

  SvgPicture _appIcon() {
    return SvgPicture.asset(
      'assets/icons/logo.svg',
      height: 100.0,
      width: 100.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return SingleChildScrollView(
      child: Consumer<AuthProvider>(
        builder: (_, user, __) {
          return Column(
            children: [
              ListTile(
                title: Text('Dark Mode'),
                onTap: () {
                  _selectThemeDialog(context);
                },
              ),
              ListTile(
                title: Text('Language'),
                onTap: () {
                  _selectLanguageDialog(context);
                },
              ),
              Divider(height: 20),
              ListTile(
                title: Text('Terms & Conditions'),
                onTap: () {
                  Navigator.pushNamed(context, '/agreement');
                },
              ),
              ListTile(
                title: Text('About'),
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationIcon: _appIcon(),
                    applicationName: 'Flora',
                    applicationVersion: '1.0a',
                    applicationLegalese:
                        'Copyright(c) 2020 by st.vtc AIMAD stu',
                  );
                },
              ),
              ListTile(
                title: Text('Laboratories'),
                onTap: () => Navigator.pushNamed(context, '/labor'),
              ),
              Divider(height: 20),
              ListTile(
                title: user.status == Status.Authenticated
                    ? Text('Switch Account')
                    : Text('Sign In'),
                onTap: () {
                  Navigator.pushNamed(context, '/signIn');
                },
              ),
              Builder(
                builder: (context) {
                  return user.status == Status.Authenticated
                      ? _signoutButton(context)
                      : Container();
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _signoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.red,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
          ),
          // padding: EdgeInsets.symmetric(vertical: 15.0),
          // color: Colors.red,
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.all(Radius.circular(5.0)),
          // ),
          onPressed: () => _confirmSignOutDialog(context),
          child: Text('Sign Out', style: kButtonTextStyle),
        ),
      ),
    );
  }
}
