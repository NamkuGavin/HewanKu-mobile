import 'package:flutter/material.dart';

import '../../common/widgets/app_snackbar.dart';

class AppRouterService {
  AppRouterService._();

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  static Route<void> Function(String? message, AppSnackbarType type)? _adopterLoginRouteBuilder;

  static void configure({required Route<void> Function(String? message, AppSnackbarType type) adopterLoginRouteBuilder}) {
    _adopterLoginRouteBuilder = adopterLoginRouteBuilder;
  }

  static void showSnackBar(String message, {AppSnackbarType type = AppSnackbarType.error}) {
    final context = navigatorKey.currentContext;
    if (context == null) {
      return;
    }

    AppSnackbar.show(context, message: message, type: type);
  }

  static Future<void> goToAdopterLogin({String? message, AppSnackbarType type = AppSnackbarType.warning}) async {
    final navigator = navigatorKey.currentState;
    final builder = _adopterLoginRouteBuilder;
    if (navigator == null || builder == null) {
      return;
    }

    navigator.pushAndRemoveUntil(builder(message, type), (route) => false);
  }
}
