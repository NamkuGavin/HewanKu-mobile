import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/utils/form_validator.dart';
import '../../../../widgets/build_custom_text_field_auth.dart';

class FormLogin extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const FormLogin({super.key, required this.formKey, required this.emailController, required this.passwordController});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        spacing: 20.h,
        children: [
          CustomAuthTextField(
            hintText: 'Email',
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            validator: FormValidator.email,
          ),
          CustomAuthTextField(
            hintText: 'Sandi',
            controller: passwordController,
            obscureText: true,
            validator: FormValidator.password,
          ),
        ],
      ),
    );
  }
}
