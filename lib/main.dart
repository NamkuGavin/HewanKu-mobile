import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app/common/theme/app_theme_data.dart';
import 'app/modules/auth/onboarding/view/onboarding_view.dart';
import 'app/modules/adopter/favorit/model/favorit_item.dart';
import 'app/modules/adopter/favorit/model/favorit_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await deviceOrientation();
  runApp(const MyApp());
}

Future<void> deviceOrientation() async {
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FavoritProvider(
      notifier: ValueNotifier<List<FavoritItem>>([]),
      child: ScreenUtilInit(
        designSize: const Size(415, 960),
        minTextAdapt: true,
        builder: (_, child) {
          return MaterialApp(title: 'Flutter Demo', theme: AppThemeData.getTheme(), home: OnboardingView());
        },
      ),
    );
  }
}