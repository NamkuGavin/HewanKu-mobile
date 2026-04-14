import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemeData {
  static ThemeData getTheme() {
    const Color primaryColor = Color(0xFFF87537);
    final Map<int, Color> primaryColorMap = {
      50: primaryColor,
      100: primaryColor,
      200: primaryColor,
      300: primaryColor,
      400: primaryColor,
      500: primaryColor,
      600: primaryColor,
      700: primaryColor,
      800: primaryColor,
      900: primaryColor,
    };
    final MaterialColor primaryMaterialColor = MaterialColor(primaryColor.value, primaryColorMap);

    return ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      useMaterial3: true,
      primaryColor: primaryColor,
      primarySwatch: primaryMaterialColor,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      appBarTheme: AppBarTheme(elevation: 0, titleTextStyle: GoogleFonts.poppins()),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Color(0xFFFBA81F),
          disabledBackgroundColor: Color(0xFFFEFEFE),
          minimumSize: Size(double.infinity, 45.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.poppins(),
        displayMedium: GoogleFonts.poppins(),
        displaySmall: GoogleFonts.poppins(),
        titleLarge: GoogleFonts.poppins(),
        titleMedium: GoogleFonts.poppins(),
        titleSmall: GoogleFonts.poppins(),
        bodyLarge: GoogleFonts.poppins(),
        bodyMedium: GoogleFonts.poppins(),
        bodySmall: GoogleFonts.poppins(),
        labelLarge: GoogleFonts.poppins(),
        labelMedium: GoogleFonts.poppins(),
        labelSmall: GoogleFonts.poppins(),
      ),
    );
  }
}
