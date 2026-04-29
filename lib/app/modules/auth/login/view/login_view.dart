import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/theme/app_theme_data.dart';
import '../../../../common/utils/app_navigator.dart';
import '../../../../widgets/build_background_auth.dart';
import '../../register/view/register_view.dart';
import '../widgets/form_login.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool rememberMe = false;

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
                  Text("Login", style: textTheme.bodySmall),
                ],
              ),
              SizedBox(height: 200.h),
              Text(
                "Selamat Datang Kembali",
                textAlign: TextAlign.center,
                style: textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30.h),
              FormLogin(),
              Theme(
                data: Theme.of(context).copyWith(splashFactory: NoSplash.splashFactory, highlightColor: Colors.transparent),
                child: CheckboxListTile(
                  title: Text("Lorem ipsum dolor sit amet,  adipiscing", style: textTheme.labelLarge),
                  value: rememberMe,
                  onChanged: (bool? value) {
                    setState(() {
                      rememberMe = !rememberMe;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  activeColor: AppThemeData.getTheme().primaryColor,
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                ),
              ),
              SizedBox(height: 50.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    "Masuk",
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
                          AppNavigator.replace(context, const RegisterView());
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
