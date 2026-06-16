import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/utils/form_validator.dart';
import '../../../../widgets/build_custom_text_field_auth.dart';

class FormRegister extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const FormRegister({
    super.key,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.phoneController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        spacing: 20.h,
        children: [
          Row(
            children: [
              Expanded(
                child: CustomAuthTextField(
                  hintText: 'Nama Depan',
                  controller: firstNameController,
                  validator: (value) {
                    return FormValidator.name(value, fieldName: 'Nama depan');
                  },
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: CustomAuthTextField(
                  hintText: 'Nama Belakang',
                  controller: lastNameController,
                  validator: (value) {
                    return FormValidator.name(value, fieldName: 'Nama belakang');
                  },
                ),
              ),
            ],
          ),
          CustomAuthTextField(
            hintText: 'Nomor Handphone',
            controller: phoneController,
            keyboardType: TextInputType.phone,
            validator: FormValidator.phone,
          ),
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
          CustomAuthTextField(
            hintText: 'Konfirmasi Sandi',
            controller: confirmPasswordController,
            obscureText: true,
            validator: (value) {
              return FormValidator.confirmPassword(value, password: passwordController.text);
            },
          ),
        ],
      ),
    );
  }
}
