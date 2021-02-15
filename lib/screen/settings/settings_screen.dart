import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/utils/toast_utils.dart';
import 'package:flutter_hotelapp/provider/auth_provider.dart';
import 'package:flutter_hotelapp/provider/theme_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  Future<bool> _confirmSignOutDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Do you want to sign out with this account?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectThemeDialog(BuildContext context) async {
    int i = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text('Select Theme'),
            children: [
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, 1),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Text('Light Mode'),
                ),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, 2),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Text('Dark Mode'),
                ),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, 0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Text('System Mode'),
                ),
              ),
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

  Future<void> _selectLanguageDialog(BuildContext context) async {
    int i = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text('Select Language'),
            children: [
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, 1),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Text('Traditional Chinese'),
                ),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, 2),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Text('English'),
                ),
              )
            ],
          );
        });
    if (i != null) {
      log("language selected: ${i == 1 ? "Chinese" : "English"} ");
    }
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
                title: Text('Rate Us'),
                onTap: () {},
              ),
              ListTile(
                title: Text('Terms & Conditions'),
                onTap: () {
                  Navigator.pushNamed(context, '/agreement');
                },
              ),
              ListTile(
                title: Text('More Info'),
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
                      ? ListTile(
                          title: Text('Sign Out'),
                          onTap: () async {
                            bool signout = await _confirmSignOutDialog(context);
                            if (signout) {
                              final authProvider = Provider.of<AuthProvider>(
                                  context,
                                  listen: false);
                              // call sign out method
                              authProvider.signOut();

                              Navigator.of(context).pop(
                                Toast.show('Sign Out Successful'),
                              );
                            }
                          },
                        )
                      : Container();
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
