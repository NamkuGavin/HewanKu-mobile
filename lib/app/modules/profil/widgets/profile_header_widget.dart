import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final VoidCallback? onNotifTap;
  final VoidCallback? onFavoriteTap;

  const ProfileHeaderWidget({
    super.key,
    this.onNotifTap,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).primaryColor;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Judul di tengah MUTLAK — tidak terpengaruh ikon di kanan
          Text(
            'Akun Saya',
            style: textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),

          // Ikon notif + favorit di pojok kanan
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _IconBtn(
                  icon: Icons.notifications_none_rounded,
                  color: primaryColor,
                  onTap: onNotifTap,
                ),
                SizedBox(width: 8.w),
                _IconBtn(
                  icon: Icons.favorite_border_rounded,
                  color: primaryColor,
                  onTap: onFavoriteTap,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _IconBtn({required this.icon, required this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF8F8F8),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 36.w,
          height: 36.h,
          child: Icon(icon, size: 20.sp, color: color),
        ),
      ),
    );
  }
}