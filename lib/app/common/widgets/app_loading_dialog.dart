import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppLoadingDialog {
  AppLoadingDialog._();

  static OverlayEntry? _entry;

  static void show(BuildContext context, {String message = 'Memuat data...'}) {
    if (_entry != null) {
      return;
    }

    final overlay = Overlay.maybeOf(context, rootOverlay: true) ?? Navigator.maybeOf(context, rootNavigator: true)?.overlay;
    if (overlay == null) {
      return;
    }

    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (overlayContext) {
        final theme = Theme.of(overlayContext);

        return Positioned.fill(
          child: Material(
            color: const Color(0x1A000000),
            child: Center(
              child: Container(
                constraints: BoxConstraints(minWidth: 140.w, maxWidth: 220.w),
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18.r),
                  border: Border.all(color: theme.primaryColor.withValues(alpha: 0.14)),
                  boxShadow: const [BoxShadow(color: Color(0x16000000), blurRadius: 20, offset: Offset(0, 10))],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 30.w,
                      height: 30.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2F2F2F),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    _entry = entry;
    overlay.insert(entry);
  }

  static void hide() {
    _entry?.remove();
    _entry = null;
  }
}
