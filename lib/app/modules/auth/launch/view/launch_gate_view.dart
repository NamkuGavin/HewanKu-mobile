import 'package:flutter/material.dart';

import '../../../../common/widgets/app_snackbar.dart';
import '../../../../services/auth/auth_service.dart';
import '../../../../services/session/auth_session_service.dart';
import '../../../adopter/navbar/view/navbar_view.dart';
import '../../login/view/login_view.dart';
import '../../onboarding/view/onboarding_view.dart';
import '../../role/view/role_view.dart';

class LaunchGateView extends StatefulWidget {
  const LaunchGateView({super.key});

  @override
  State<LaunchGateView> createState() => _LaunchGateViewState();
}

class _LaunchGateViewState extends State<LaunchGateView> {
  late Future<Widget> _screenFuture;

  @override
  void initState() {
    super.initState();
    _screenFuture = _resolveHome();
  }

  Future<Widget> _resolveHome() async {
    final session = AuthSessionService.instance.currentSession;
    if (session == null) {
      return const OnboardingView();
    }

    if (session.role != 'adopter') {
      await AuthSessionService.instance.clearSession();
      return const RoleView();
    }

    if (session.isExpired) {
      await AuthSessionService.instance.clearSession();
      return const LoginView(
        role: UserRole.adopter,
        initialMessage: 'Sesi kamu sudah berakhir. Silakan login kembali.',
        initialSnackbarType: AppSnackbarType.warning,
      );
    }

    try {
      final valid = await AuthService.instance.validateAdopterSession();
      if (valid) {
        return const NavbarView();
      }
    } catch (_) {
      // Di bawah akan diarahkan ke login dan session dibersihkan.
    }

    await AuthSessionService.instance.clearSession();
    return const LoginView(
      role: UserRole.adopter,
      initialMessage: 'Sesi kamu tidak valid. Silakan login kembali.',
      initialSnackbarType: AppSnackbarType.warning,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _screenFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        return snapshot.data ?? const OnboardingView();
      },
    );
  }
}
