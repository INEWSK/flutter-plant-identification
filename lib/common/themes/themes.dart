import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ------------------ LIGHT THEME DATA ------------------ //

ThemeData lightTheme(BuildContext context) {
  return ThemeData.light().copyWith(
    appBarTheme: appBarTheme.copyWith(
      color: Colors.transparent, // transparent appbar
      iconTheme: IconThemeData(color: Colors.black54),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      // accentIconTheme.color To be removed.
      foregroundColor: Colors.white,
    ),
    primaryColor: Color(0xFF00BF6D),
    brightness: Brightness.light,
    iconTheme: IconThemeData(color: Color(0xFF1D1D35)),
    textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme).apply(
      bodyColor: Color(0xFF1D1D35),
    ),
    colorScheme: ColorScheme.light(
      primary: Color(0xFF00BF6D),
      secondary: Color(0xFF27A09E),
      error: Color(0xFFF03738),
    ),
    // 自適應各平台的視覺密度
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

// ------------------ DARK THEME DATA ------------------ //

ThemeData darkTheme(BuildContext context) {
  return ThemeData.dark().copyWith(
    appBarTheme: appBarTheme.copyWith(
        // color: Colors.transparent, // transparent appbar
        // iconTheme: IconThemeData(color: Colors.black54),
        ),
    brightness: Brightness.dark,
    iconTheme: IconThemeData(color: Color(0xFFF5FCF9)),
    textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme).apply(
      bodyColor: Color(0xFFF5FCF9),
    ),
    colorScheme: ColorScheme.dark(
      primary: Color(0xFF00BF6D),
      secondary: Color(0xFF27A09E),
      error: Color(0xFFF03738),
    ),
    // 自適應各平台的視覺密度
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

/// ------------------------------------------------------ ///

AppBarTheme appBarTheme = AppBarTheme(
  elevation: 0, // no shadow
  centerTitle: false,
);
