import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/utils/app_navigator.dart';
import '../../../../common/utils/form_validator.dart';
import '../../../../widgets/build_background_auth.dart';
import '../../../../widgets/build_custom_text_field_auth.dart';

class CodeVerifView extends StatefulWidget {
  const CodeVerifView({super.key});

  @override
  State<CodeVerifView> createState() => _CodeVerifViewState();
}

class _CodeVerifViewState extends State<CodeVerifView> {
  final codeController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  bool hasValidCode = false;

  @override
  void dispose() {
    codeController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
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
              if (hasValidCode) ...[
                CustomAuthTextField(
                  hintText: 'Sandi',
                  controller: passwordController,
                  obscureText: !isPasswordVisible,
                  validator: FormValidator.password,
                ),
                SizedBox(height: 15.h),
                CustomAuthTextField(
                  hintText: 'Konfirmasi Sandi',
                  controller: confirmPasswordController,
                  obscureText: !isConfirmPasswordVisible,
                  validator: (value) {
                    return FormValidator.confirmPassword(value, password: passwordController.text);
                  },
                ),
              ] else ...[
                CustomAuthTextField(
                  hintText: 'Masukkan Kode',
                  controller: codeController,
                  keyboardType: TextInputType.number,
                  validator: (String? value) {
                    final input = value?.trim().replaceAll(' ', '').replaceAll('-', '') ?? '';
                    if (input.isEmpty) {
                      return 'Kode wajib diisi';
                    }
                    final phoneRegex = RegExp(r'^(?:\+62|62|0)8[1-9][0-9]{7,11}$');

                    if (!phoneRegex.hasMatch(input)) {
                      return 'Format kode tidak valid';
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
                        text: 'kirim ulang',
                        style: textTheme.labelLarge?.copyWith(color: Colors.blue, fontWeight: FontWeight.w500),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                    ],
                  ),
                ),
              ],
              SizedBox(height: 30.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => setState(() {
                    hasValidCode = true;
                  }),
                  child: Text(
                    hasValidCode ? "Set Sandi Baru" : "Kirim",
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
