import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/widgets/app_snackbar.dart';
import '../../../../common/utils/app_navigator.dart';
import '../../../../common/utils/form_validator.dart';
import '../../../../models/auth/auth_forgot_password_request_model.dart';
import '../../../../services/api/api_exception.dart';
import '../../../../services/auth/auth_service.dart';
import '../../../../widgets/build_background_auth.dart';
import '../../../../widgets/build_custom_text_field_auth.dart';
import '../../code_verif/view/code_verif_view.dart';
import '../../register/view/register_view.dart';
import '../../role/view/role_view.dart';

class ForgotPassView extends StatefulWidget {
  final UserRole role;

  const ForgotPassView({super.key, this.role = UserRole.adopter});

  @override
  State<ForgotPassView> createState() => _ForgotPassViewState();
}

class _ForgotPassViewState extends State<ForgotPassView> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    emailController.dispose();
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
    return 'Terjadi kesalahan saat mengirim kode OTP.';
  }

  AppSnackbarType _extractErrorType(Object error) {
    if (error is ApiException) {
      if (error.statusCode == 400 || error.statusCode == 401 || error.statusCode == 403) {
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

  Future<void> _handleSendOtp() async {
    if (widget.role != UserRole.adopter) {
      AppSnackbar.show(
        context,
        message: 'Lupa password shelter belum diintegrasikan di aplikasi.',
        type: AppSnackbarType.warning,
      );
      return;
    }

    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final email = emailController.text.trim();
      final response = await AuthService.instance.forgotPasswordAdopter(AuthForgotPasswordRequestModel(email: email));

      if (!mounted) {
        return;
      }

      AppNavigator.push(
        context,
        CodeVerifView(
          role: UserRole.adopter,
          email: email,
          initialMessage: response.message ?? 'Kode OTP berhasil dikirim.',
          initialSnackbarType: AppSnackbarType.success,
        ),
      );
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
                  Text("Lupa sandi password", style: textTheme.bodySmall),
                ],
              ),
              SizedBox(height: 200.h),
              Text(
                "Lupa Sandi Password?",
                textAlign: TextAlign.center,
                style: textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 50.h),
              Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscingelit, sed doeiusmod tempor incididunt ut labore et doloremagna aliqua.",
                textAlign: TextAlign.center,
                style: textTheme.bodySmall,
              ),
              SizedBox(height: 30.h),
              Form(
                key: _formKey,
                child: CustomAuthTextField(
                  hintText: 'Email',
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: FormValidator.email,
                ),
              ),
              SizedBox(height: 30.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _handleSendOtp,
                  child: Text(
                    _isSubmitting ? "Memproses..." : "Kirim",
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
                        ..onTap = () {
                          AppNavigator.replace(context, RegisterView(role: widget.role));
                        },
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
