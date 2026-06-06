import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../common/contant/assets.dart';
import '../modules/adopter/favorit/view/favorit_view.dart';
import '../modules/adopter/notifikasi/view/notifikasi_view.dart';

class BuildAppHeader extends StatelessWidget {
  /// Jika [title] diisi, tampilkan teks di tengah (untuk halaman Profil).
  /// Jika null, tampilkan logo HewanKu (default — Home, Adopsi, dll).
  final String? title;

  const BuildAppHeader({
    super.key,
    this.title,
    @Deprecated('tidak dipakai') VoidCallback? onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Kiri: logo (hanya tampil kalau tidak ada title)
          if (title == null)
            Align(
              alignment: Alignment.centerLeft,
              child: SvgPicture.asset(IconAsset.hewankuLogoSecondary),
            ),

          // Tengah: title (hanya tampil kalau ada title)
          if (title != null)
            Text(
              title!,
              style: textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),

          // Kanan: icon notif & favorit (selalu tampil)
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _HeaderIconButton(
                  icon: Icons.notifications_none_rounded,
                  color: primaryColor,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const NotifikasiView()),
                  ),
                ),
                SizedBox(width: 8.w),
                _HeaderIconButton(
                  icon: Icons.favorite_border_rounded,
                  color: primaryColor,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FavoritView()),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _HeaderIconButton({
    required this.icon,
    required this.color,
    this.onTap,
  });

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
          child: Icon(icon, size: 20.w, color: color),
        ),
      ),
    );
  }
}