import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app/common/theme/app_theme_data.dart';
import 'app/modules/adopter/favorit/model/favorit_provider.dart';
import 'app/modules/adopter/pesanan/model/pesanan_item.dart';
import 'app/modules/adopter/pesanan/model/pesanan_provider.dart';
import 'app/modules/auth/launch/view/launch_gate_view.dart';
import 'app/modules/auth/login/view/login_view.dart';
import 'app/modules/auth/role/view/role_view.dart';
import 'app/services/navigation/app_router_service.dart';
import 'app/services/session/auth_session_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await deviceOrientation();
  await AuthSessionService.instance.restorePersistedSession();
  AppRouterService.configure(
    adopterLoginRouteBuilder: (message, type) => MaterialPageRoute<void>(
      builder: (_) => LoginView(role: UserRole.adopter, initialMessage: message, initialSnackbarType: type),
    ),
  );
  runApp(const MyApp());
}

Future<void> deviceOrientation() async {
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FavoritProvider(
      notifier: FavoritController(),
      child: PesananProvider(
        notifier: ValueNotifier<List<PesananItem>>([]),
        child: ScreenUtilInit(
          designSize: const Size(415, 960),
          minTextAdapt: true,
          builder: (_, child) {
            return MaterialApp(
              navigatorKey: AppRouterService.navigatorKey,
              scaffoldMessengerKey: AppRouterService.scaffoldMessengerKey,
              title: 'Flutter Demo',
              theme: AppThemeData.getTheme(),
              home: const LaunchGateView(),
            );
          },
        ),
      ),
    );
  }
}
