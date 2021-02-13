import 'package:flutter/material.dart';

// ------------------ LIGHT THEME DATA ------------------ //

final lightTheme = ThemeData(
  appBarTheme: appBarTheme.copyWith(
    color: Colors.transparent,
    iconTheme: IconThemeData(color: Colors.black54),
  ),
  brightness: Brightness.light,

  primaryColor: Colors.green,
  accentColor: Color(0xFF27A09E),

  fontFamily: "Poppins",
  // 自適應各平台的視覺密度
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

// ------------------ DARK THEME DATA ------------------ //

final darkTheme = ThemeData(
  appBarTheme: appBarTheme,
  brightness: Brightness.dark,
  fontFamily: "Poppins",
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

/// ------------------------------------------------------ ///

AppBarTheme appBarTheme = AppBarTheme(
  elevation: 0, // no shadow
  // centerTitle: true,
);
