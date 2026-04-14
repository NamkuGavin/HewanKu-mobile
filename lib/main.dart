import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app/common/theme/app_theme_data.dart';
import 'app/modules/home/view/home_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await deviceOrientation();
  runApp(const MyApp());
}

Future<void> deviceOrientation() async {
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(415, 960),
      minTextAdapt: true,
      builder: (_, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: AppThemeData.getTheme(),
          home: const MyHomePage(title: 'Flutter Demo Home Page'),
        );
      },
    );
  }
}
