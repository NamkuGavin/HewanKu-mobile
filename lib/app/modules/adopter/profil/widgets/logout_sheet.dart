import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../common/contant/assets.dart';
import '../../../../common/utils/app_navigator.dart';
import '../../../../services/auth/auth_service.dart';
import '../../../../services/order/adopter_payment_session_service.dart';
import '../../../../services/order/adopter_review_state_service.dart';
import '../../favorit/model/favorit_provider.dart';
import '../../../auth/role/view/role_view.dart';

class LogoutSheet extends StatelessWidget {
  final BuildContext parentContext;

  const LogoutSheet({super.key, required this.parentContext});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => LogoutSheet(parentContext: context),
    );
  }

  Future<void> _onConfirmLogout(BuildContext context) async {
    Navigator.pop(context);
    await AuthService.instance.logoutAdopter();
    await AdopterPaymentSessionService.instance.clearAll();
    await AdopterReviewStateService.instance.clearAll();
    if (!parentContext.mounted) {
      return;
    }
    FavoritProvider.clear(parentContext);
    AppNavigator.pushAndRemoveAll(parentContext, const RoleView());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 40.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28.r),
          topRight: Radius.circular(28.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(
                Icons.arrow_back_rounded,
                size: 30.w,
                color: const Color(0xFFF87537),
              ),
            ),
          ),
          SizedBox(height: 24.h),
          Image.asset(
            ImageAsset.imageHewanku,
            width: 180.w,
            height: 180.w,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 28.h),
          Text(
            'Apakah kamu yakin ingin\nLogout dari akunmu?',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A1A),
              height: 1.35,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'Tenang saja, kamu masih bisa masuk kembali ke\nakunmu dengan cara login kembali terlebih dahulu',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 12.sp,
              color: const Color(0xFF999999),
              height: 1.5,
            ),
          ),
          SizedBox(height: 32.h),
          GestureDetector(
            onTap: () => _onConfirmLogout(context),
            child: Container(
              width: double.infinity,
              height: 52.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF87537), Color(0xFFFBA81F)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(50.r),
              ),
              child: Text(
                'Lanjutkan Keluar Akun',
                style: GoogleFonts.poppins(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
