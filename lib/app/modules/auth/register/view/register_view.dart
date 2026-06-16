import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/widgets/app_snackbar.dart';
import '../../../../common/utils/app_navigator.dart';
import '../../../../models/auth/auth_register_request_model.dart';
import '../../../../services/auth/auth_service.dart';
import '../../../../services/api/api_exception.dart';
import '../../../../widgets/build_background_auth.dart';
import '../../login/view/login_view.dart';
import '../../role/view/role_view.dart';
import '../widgets/form_register.dart';

class RegisterView extends StatefulWidget {
  final UserRole role;
  const RegisterView({super.key, this.role = UserRole.adopter});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
    return 'Terjadi kesalahan saat register.';
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

  Future<void> _handleRegister() async {
    if (widget.role == UserRole.shelter) {
      AppSnackbar.show(
        context,
        message: 'Register shelter belum diintegrasikan di aplikasi.',
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
      final response = await AuthService.instance.registerAdopter(
        AuthRegisterRequestModel(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          namaDepan: _firstNameController.text.trim(),
          namaBelakang: _lastNameController.text.trim(),
          noTelepon: _phoneController.text.trim(),
          confirmPassword: _confirmPasswordController.text,
          keyRole: 'adopter',
        ),
      );

      if (!mounted) {
        return;
      }

      AppNavigator.replace(
        context,
        LoginView(
          role: UserRole.adopter,
          initialMessage: response.message ?? 'Akun telah terbuat. Silakan login.',
          initialEmail: _emailController.text.trim(),
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
                  Text('Daftar', style: textTheme.bodySmall),
                ],
              ),
              SizedBox(height: 50.h),
              Text(
                widget.role == UserRole.shelter ? 'Daftar Sebagai Shelter' : 'Buat Akun Anda',
                textAlign: TextAlign.center,
                style: textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30.h),
              FormRegister(
                formKey: _formKey,
                firstNameController: _firstNameController,
                lastNameController: _lastNameController,
                phoneController: _phoneController,
                emailController: _emailController,
                passwordController: _passwordController,
                confirmPasswordController: _confirmPasswordController,
              ),
              SizedBox(height: 30.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _handleRegister,
                  child: Text(
                    _isSubmitting ? 'Memproses...' : 'Daftar',
                    style: textTheme.labelLarge!.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 50.h),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Sudah Punya Akun ? ',
                  style: textTheme.bodySmall?.copyWith(color: Colors.black),
                  children: [
                    TextSpan(
                      text: 'Masuk',
                      style: textTheme.bodySmall?.copyWith(color: Colors.blue, fontWeight: FontWeight.w500),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => AppNavigator.replace(context, LoginView(role: widget.role)),
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
