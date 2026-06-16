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
      appBarTheme: AppBarTheme(elevation: 0, titleTextStyle: GoogleFonts.poppins(color: Colors.black)),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Color(0xFFFBA81F),
          minimumSize: Size(0.w, 45.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.poppins(fontSize: 40.sp),
        displayMedium: GoogleFonts.poppins(fontSize: 35.sp),
        displaySmall: GoogleFonts.poppins(fontSize: 33.sp),
        titleLarge: GoogleFonts.poppins(fontSize: 30.sp),
        titleMedium: GoogleFonts.poppins(fontSize: 25.sp),
        titleSmall: GoogleFonts.poppins(fontSize: 23.sp),
        bodyLarge: GoogleFonts.poppins(fontSize: 20.sp),
        bodyMedium: GoogleFonts.poppins(fontSize: 17.sp),
        bodySmall: GoogleFonts.poppins(fontSize: 15.sp),
        labelLarge: GoogleFonts.poppins(fontSize: 12.sp),
        labelMedium: GoogleFonts.poppins(fontSize: 10.sp),
        labelSmall: GoogleFonts.poppins(fontSize: 8.sp),
      ),
    );
  }
}
