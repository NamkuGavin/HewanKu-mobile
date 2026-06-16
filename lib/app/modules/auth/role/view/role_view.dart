import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/contant/assets.dart';
import '../../../../common/utils/app_navigator.dart';
import '../../../../widgets/build_background_auth.dart';
import '../../login/view/login_view.dart';
import '../../register/view/register_view.dart';

enum UserRole { adopter, shelter }

class RoleView extends StatelessWidget {
  const RoleView({super.key});

  @override
  Widget build(BuildContext context) {
    var textTheme = TextTheme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BuildBackgroundAuth(
        scrollable: true,
        child: SafeArea(
          child: Column(
            spacing: 15.h,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Masuk Sebagai Adopter", style: textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold)),
              Image.asset(ImageAsset.adopterCover),
              Row(
                spacing: 25.w,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => AppNavigator.push(context, RegisterView(role: UserRole.adopter)),
                      child: Text(
                        "Daftar",
                        style: textTheme.labelLarge!.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => AppNavigator.push(context, LoginView(role: UserRole.adopter)),
                      child: Text(
                        "Login",
                        style: textTheme.labelLarge!.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.h),
              // Text(
              //   "Masuk Sebagai Shelter",
              //   style: textTheme.bodyLarge!.copyWith(
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              // Image.asset(ImageAsset.shelterCover),
              // Row(
              //   spacing: 25.w,
              //   children: [
              //     Expanded(
              //       child: ElevatedButton(
              //         onPressed: () => AppNavigator.push(
              //           context,
              //           RegisterView(role: UserRole.shelter),
              //         ),
              //         child: Text(
              //           "Daftar",
              //           style: textTheme.labelLarge!.copyWith(
              //             color: Colors.white,
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //       ),
              //     ),
              //     Expanded(
              //       child: ElevatedButton(
              //         onPressed: () => AppNavigator.push(
              //           context,
              //           LoginView(role: UserRole.shelter),
              //         ),
              //         child: Text(
              //           "Login",
              //           style: textTheme.labelLarge!.copyWith(
              //             color: Colors.white,
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              // SizedBox(height: 8.h),
              // Text(
              //   "Dengan melanjutkan, Anda menyetujui Ketentuan Layanan dan Kebijakan Privasi kami.",
              //   textAlign: TextAlign.center,
              //   style: textTheme.labelLarge,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
