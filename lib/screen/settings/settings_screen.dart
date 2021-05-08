import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hotelapp/common/constants/constants.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';
import 'package:flutter_hotelapp/common/utils/toast_utils.dart';
import 'package:flutter_hotelapp/provider/auth_provider.dart';
import 'package:flutter_hotelapp/provider/intl_provider.dart';
import 'package:flutter_hotelapp/provider/theme_provider.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  _confirmSignOutDialog(BuildContext context) async {
    bool signout = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context).logout),
            content: Text('Do you want to sign out with this account?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(AppLocalizations.of(context).no),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(AppLocalizations.of(context).yes),
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
            title: Text(AppLocalizations.of(context).selectTheme),
            children: [
              _themeModeOption(
                  context, 1, AppLocalizations.of(context).lightMode),
              _themeModeOption(
                  context, 2, AppLocalizations.of(context).darkMode),
              _themeModeOption(
                  context, 0, AppLocalizations.of(context).followSystem),
            ],
          );
        });
    if (i != null) {
      final ThemeMode themeMode = i == 0
          ? ThemeMode.system
          : (i == 1 ? ThemeMode.light : ThemeMode.dark);
      // 等價於 provider.of(context, listen: false)
      context.read<ThemeProvider>().setTheme(themeMode);
    }
  }

  _selectLanguageDialog(BuildContext context) async {
    int i = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(AppLocalizations.of(context).selectLanguage),
            children: [
              _languageSelect(
                  context, 1, AppLocalizations.of(context).tchinese),
              _languageSelect(context, 2, AppLocalizations.of(context).english),
              _languageSelect(
                  context, 0, AppLocalizations.of(context).followSystem)
            ],
          );
        });
    if (i != null) {
      final String locale = i == 0 ? '' : (i == 1 ? 'zh' : 'en');
      context.read<IntlProvider>().setLocale(locale);
      // 重建所有 flutter widget 以變更語言
      Phoenix.rebirth(context);
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
          child: Text(AppLocalizations.of(context).logout,
              style: kButtonTextStyle),
        ),
      ),
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
                title: Text(AppLocalizations.of(context).themeOption),
                subtitle: Text(_getCurrentTheme(context)),
                onTap: () {
                  _selectThemeDialog(context);
                },
              ),
              ListTile(
                title: Text(AppLocalizations.of(context).languageOption),
                subtitle: Text(_getCurrentLocale(context)),
                onTap: () {
                  _selectLanguageDialog(context);
                },
              ),
              Divider(height: 20),
              ListTile(
                title: Text(AppLocalizations.of(context).terms),
                onTap: () {
                  Navigator.pushNamed(context, '/agreement');
                },
              ),
              ListTile(
                title: Text(AppLocalizations.of(context).about),
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationIcon: _appIcon(),
                    applicationName: 'Tree Doctor',
                    applicationVersion: '1.0a',
                    applicationLegalese:
                        'Copyright(c) 2020 by st.vtc AIMAD stu',
                  );
                },
              ),
              ListTile(
                title: Text(AppLocalizations.of(context).labor),
                onTap: () => Navigator.pushNamed(context, '/labor'),
              ),
              Divider(height: 20),
              ListTile(
                title: user.status == Status.Authenticated
                    ? Text(AppLocalizations.of(context).switchAccount)
                    : Text(AppLocalizations.of(context).login),
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

  String _getCurrentTheme(BuildContext context) {
    var box = Hive.box(Constant.box);
    final String theme = box.get(Constant.theme);
    String themeMode;
    switch (theme) {
      case 'Dark':
        themeMode = AppLocalizations.of(context).darkMode;
        break;
      case 'Light':
        themeMode = AppLocalizations.of(context).lightMode;
        break;
      default:
        themeMode = AppLocalizations.of(context).followSystem;
        break;
    }
    return themeMode;
  }

  String _getCurrentLocale(BuildContext context) {
    var box = Hive.box(Constant.box);
    final String locale = box.get(Constant.locale);
    String localeMode;
    switch (locale) {
      case 'zh':
        localeMode = '中文';
        break;
      case 'en':
        localeMode = 'English';
        break;
      default:
        localeMode = AppLocalizations.of(context).followSystem;
    }
    return localeMode;
  }
}
