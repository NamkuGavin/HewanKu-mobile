import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/widgets/app_snackbar.dart';
import '../../../../common/utils/app_navigator.dart';
import '../../../../common/utils/form_validator.dart';
import '../../../../models/auth/auth_change_password_request_model.dart';
import '../../../../models/auth/auth_forgot_password_request_model.dart';
import '../../../../models/auth/auth_verify_otp_request_model.dart';
import '../../../../services/api/api_exception.dart';
import '../../../../services/auth/auth_service.dart';
import '../../../../widgets/build_background_auth.dart';
import '../../../../widgets/build_custom_text_field_auth.dart';
import '../../login/view/login_view.dart';
import '../../role/view/role_view.dart';

class CodeVerifView extends StatefulWidget {
  final UserRole role;
  final String email;
  final String? initialMessage;
  final AppSnackbarType initialSnackbarType;

  const CodeVerifView({
    super.key,
    required this.email,
    this.role = UserRole.adopter,
    this.initialMessage,
    this.initialSnackbarType = AppSnackbarType.success,
  });

  @override
  State<CodeVerifView> createState() => _CodeVerifViewState();
}

class _CodeVerifViewState extends State<CodeVerifView> {
  final _formKey = GlobalKey<FormState>();
  final codeController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool hasValidCode = false;
  bool _isSubmitting = false;
  bool _isResending = false;

  @override
  void dispose() {
    codeController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialMessage != null && widget.initialMessage!.trim().isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        AppSnackbar.show(context, message: widget.initialMessage!, type: widget.initialSnackbarType);
      });
    }
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
    return 'Terjadi kesalahan saat memproses permintaan.';
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

  Future<void> _handleVerifyOtp() async {
    if (widget.role != UserRole.adopter) {
      AppSnackbar.show(
        context,
        message: 'Verifikasi OTP shelter belum diintegrasikan di aplikasi.',
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
      final response = await AuthService.instance.verifyOtpAdopter(
        AuthVerifyOtpRequestModel(email: widget.email, otp: codeController.text.trim()),
      );

      if (!mounted) {
        return;
      }

      setState(() => hasValidCode = true);
      AppSnackbar.show(
        context,
        message: response.message ?? 'Kode OTP berhasil diverifikasi.',
        type: AppSnackbarType.success,
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

  Future<void> _handleChangePassword() async {
    if (widget.role != UserRole.adopter) {
      AppSnackbar.show(
        context,
        message: 'Ubah password shelter belum diintegrasikan di aplikasi.',
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
      final response = await AuthService.instance.changePasswordAdopter(
        AuthChangePasswordRequestModel(
          email: widget.email,
          password: passwordController.text,
          repassword: confirmPasswordController.text,
        ),
      );

      if (!mounted) {
        return;
      }

      AppNavigator.pushAndRemoveAll(
        context,
        LoginView(
          role: UserRole.adopter,
          initialEmail: widget.email,
          initialMessage: response.message ?? 'Password berhasil diubah. Silakan login kembali.',
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

  Future<void> _handleResendOtp() async {
    if (widget.role != UserRole.adopter) {
      AppSnackbar.show(
        context,
        message: 'Kirim ulang OTP shelter belum diintegrasikan di aplikasi.',
        type: AppSnackbarType.warning,
      );
      return;
    }

    setState(() => _isResending = true);
    try {
      final response = await AuthService.instance.forgotPasswordAdopter(AuthForgotPasswordRequestModel(email: widget.email));

      if (!mounted) {
        return;
      }

      AppSnackbar.show(
        context,
        message: response.message ?? 'Kode OTP berhasil dikirim ulang.',
        type: AppSnackbarType.success,
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      AppSnackbar.show(context, message: _extractErrorMessage(error), type: _extractErrorType(error));
    } finally {
      if (mounted) {
        setState(() => _isResending = false);
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
                    onPressed: () {
                      if (hasValidCode) {
                        setState(() {
                          hasValidCode = false;
                        });
                      } else {
                        AppNavigator.pop(context);
                      }
                    },
                  ),
                  Text("Kode Verifikasi", style: textTheme.bodySmall),
                ],
              ),
              SizedBox(height: 200.h),
              Text(
                "Kode Verifikasi",
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
                child: Column(
                  children: [
                    if (hasValidCode) ...[
                      CustomAuthTextField(
                        hintText: 'Sandi Baru',
                        controller: passwordController,
                        obscureText: true,
                        validator: FormValidator.password,
                      ),
                      SizedBox(height: 15.h),
                      CustomAuthTextField(
                        hintText: 'Konfirmasi Sandi Baru',
                        controller: confirmPasswordController,
                        obscureText: true,
                        validator: (value) {
                          return FormValidator.confirmPassword(value, password: passwordController.text);
                        },
                      ),
                    ] else ...[
                      CustomAuthTextField(
                        hintText: 'Masukkan Kode OTP',
                        controller: codeController,
                        keyboardType: TextInputType.number,
                        validator: (String? value) {
                          final input = value?.trim().replaceAll(' ', '') ?? '';
                          if (input.isEmpty) {
                            return 'Kode OTP wajib diisi';
                          }
                          if (input.length != 6 || int.tryParse(input) == null) {
                            return 'Format kode OTP tidak valid';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15.h),
                      RichText(
                        text: TextSpan(
                          text: 'Tidak menerima kode? ',
                          style: textTheme.labelLarge?.copyWith(color: Colors.black),
                          children: [
                            TextSpan(
                              text: _isResending ? 'mengirim...' : 'kirim ulang',
                              style: textTheme.labelLarge?.copyWith(color: Colors.blue, fontWeight: FontWeight.w500),
                              recognizer: TapGestureRecognizer()..onTap = _isResending ? null : _handleResendOtp,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: 30.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting
                      ? null
                      : hasValidCode
                      ? _handleChangePassword
                      : _handleVerifyOtp,
                  child: Text(
                    _isSubmitting
                        ? "Memproses..."
                        : hasValidCode
                        ? "Set Sandi Baru"
                        : "Verifikasi Kode",
                    style: textTheme.labelLarge!.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
