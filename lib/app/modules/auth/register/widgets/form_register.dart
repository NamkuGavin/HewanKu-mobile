import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/utils/form_validator.dart';
import '../../../../widgets/build_custom_text_field_auth.dart';

class FormRegister extends StatefulWidget {
  const FormRegister({super.key});

  @override
  State<FormRegister> createState() => _FormRegisterState();
}

class _FormRegisterState extends State<FormRegister> {
  final formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

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
            obscureText: !isPasswordVisible,
            validator: FormValidator.password,
          ),
          CustomAuthTextField(
            hintText: 'Konfirmasi Sandi',
            controller: confirmPasswordController,
            obscureText: !isConfirmPasswordVisible,
            validator: (value) {
              return FormValidator.confirmPassword(value, password: passwordController.text);
            },
          ),
        ],
      ),
    );
  }
}
