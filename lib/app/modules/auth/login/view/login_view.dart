import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/widgets/app_snackbar.dart';
import '../../../../common/theme/app_theme_data.dart';
import '../../../../common/utils/app_navigator.dart';
import '../../../../models/auth/auth_login_request_model.dart';
import '../../../../services/auth/auth_service.dart';
import '../../../../services/api/api_exception.dart';
import '../../../../widgets/build_background_auth.dart';
import '../../forgot_pass/view/forgot_pass_view.dart';
import '../../register/view/register_view.dart';
import '../../role/view/role_view.dart';
import '../widgets/form_login.dart';
import 'package:hewanku_mobile/app/modules/adopter/navbar/view/navbar_view.dart';
import 'package:hewanku_mobile/app/modules/shelter/navbar/view/navbar_view.dart';

class LoginView extends StatefulWidget {
  final UserRole role;
  final String? initialMessage;
  final String? initialEmail;
  final AppSnackbarType initialSnackbarType;

  const LoginView({
    super.key,
    this.role = UserRole.adopter,
    this.initialMessage,
    this.initialEmail,
    this.initialSnackbarType = AppSnackbarType.error,
  });

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool rememberMe = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialEmail != null && widget.initialEmail!.trim().isNotEmpty) {
      _emailController.text = widget.initialEmail!.trim();
    }
    if (widget.initialMessage != null && widget.initialMessage!.trim().isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        AppSnackbar.show(context, message: widget.initialMessage!, type: widget.initialSnackbarType);
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String _extractErrorMessage(Object error) {
    if (error is ApiException) {
      return error.message;
    }
    if (error is FormatException) {
      return error.message;
    }
    if (error is Exception) {
      return error.toString().replaceFirst('Exception: ', '');
    }
    return 'Terjadi kesalahan saat login.';
  }

  AppSnackbarType _extractErrorType(Object error) {
    if (error is ApiException) {
      if (error.isUnauthorized || error.statusCode == 400 || error.statusCode == 401 || error.statusCode == 403) {
        return AppSnackbarType.warning;
      }
      if (error.apiCode == 400 || error.apiCode == 401 || error.apiCode == 403) {
        return AppSnackbarType.warning;
      }
    }
    if (error is FormatException) {
      return AppSnackbarType.warning;
    }
    return AppSnackbarType.error;
  }

  Future<void> _handleLogin() async {
    if (widget.role == UserRole.shelter) {
      AppNavigator.pushAndRemoveAll(context, const NavbarShelterView());
      return;
    }

    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      await AuthService.instance.loginAdopter(
        request: AuthLoginRequestModel(email: _emailController.text.trim(), password: _passwordController.text),
        rememberMe: rememberMe,
      );

      if (!mounted) {
        return;
      }

      AppNavigator.pushAndRemoveAll(context, const NavbarView());
    } catch (error) {
      if (!mounted) {
        return;
      }

      AppSnackbar.show(context, message: _extractErrorMessage(error), type: _extractErrorType(error));
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BuildBackgroundAuth(
        scrollable: true,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                    onPressed: () => AppNavigator.pop(context),
                  ),
                  Text('Login', style: textTheme.bodySmall),
                ],
              ),
              SizedBox(height: 200.h),
              Text(
                'Selamat Datang Kembali',
                textAlign: TextAlign.center,
                style: textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30.h),
              FormLogin(formKey: _formKey, emailController: _emailController, passwordController: _passwordController),
              SizedBox(height: 15.h),
              GestureDetector(
                onTap: () => AppNavigator.push(context, ForgotPassView(role: widget.role)),
                child: Text(
                  'Forget Password?',
                  style: textTheme.labelLarge!.copyWith(color: const Color(0xFF4285F4), fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 15.h),
              Theme(
                data: Theme.of(context).copyWith(splashFactory: NoSplash.splashFactory, highlightColor: Colors.transparent),
                child: CheckboxListTile(
                  title: Text('Remember me', style: textTheme.labelLarge),
                  value: rememberMe,
                  onChanged: _isSubmitting ? null : (v) => setState(() => rememberMe = v ?? false),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  activeColor: AppThemeData.getTheme().primaryColor,
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _handleLogin,
                  child: Text(
                    _isSubmitting ? 'Memproses...' : 'Masuk',
                    style: textTheme.labelLarge!.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 50.h),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Belum Punya Akun ? ',
                  style: textTheme.bodySmall?.copyWith(color: Colors.black),
                  children: [
                    TextSpan(
                      text: 'Daftar',
                      style: textTheme.bodySmall?.copyWith(color: Colors.blue, fontWeight: FontWeight.w500),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => AppNavigator.replace(context, RegisterView(role: widget.role)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
