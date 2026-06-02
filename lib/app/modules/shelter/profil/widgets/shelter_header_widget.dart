import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hewanku_mobile/app/common/contant/assets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ShelterHeaderWidget extends StatelessWidget {
  final VoidCallback? onNotifTap;

  const ShelterHeaderWidget({super.key, this.onNotifTap});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 10.h),
      child: Row(
        children: [
          SvgPicture.asset(IconAsset.hewankuLogoSecondary),
          const Spacer(),
          Material(
            color: const Color(0xFFF8F8F8),
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onNotifTap,
              child: SizedBox(
                width: 36.w,
                height: 36.h,
                child: Icon(
                  Icons.notifications_none_rounded,
                  size: 20.sp,
                  color: primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
