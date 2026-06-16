import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/utils/app_navigator.dart';
import '../../navbar/view/navbar_controller.dart';
import 'pesanan_tab_controller.dart';

class PesananPaymentResultView extends StatelessWidget {
  final bool isSuccess;
  final String orderCode;
  final String title;
  final String description;

  const PesananPaymentResultView({
    super.key,
    required this.isSuccess,
    required this.orderCode,
    required this.title,
    required this.description,
  });

  void _goToHistory(BuildContext context) {
    NavbarController.goTo(2);
    PesananTabController.openPesananTerakhir(refresh: true);
    AppNavigator.popUntilFirst(context);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final accent = isSuccess
        ? const Color(0xFF2E7D32)
        : const Color(0xFFE53935);
    final soft = isSuccess ? const Color(0xFFEAF7EC) : const Color(0xFFFFEFEF);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 28.h),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 96.w,
                      height: 96.h,
                      decoration: BoxDecoration(
                        color: soft,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isSuccess
                            ? Icons.check_circle_rounded
                            : Icons.cancel_rounded,
                        color: accent,
                        size: 52.sp,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      description,
                      textAlign: TextAlign.center,
                      style: textTheme.labelLarge?.copyWith(
                        color: const Color(0xFF737373),
                        height: 1.6,
                      ),
                    ),
                    SizedBox(height: 18.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8F3),
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(color: const Color(0xFFF8D7C5)),
                      ),
                      child: Text(
                        'ID Order: $orderCode',
                        style: textTheme.labelLarge?.copyWith(
                          color: const Color(0xFF4F4F4F),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _goToHistory(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF87537),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 15.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                  ),
                  child: Text(
                    'Buka Pesanan Terakhir',
                    style: textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
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
