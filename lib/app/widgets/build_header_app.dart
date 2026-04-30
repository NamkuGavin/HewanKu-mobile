import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../common/contant/assets.dart';

class BuildAppHeader extends StatelessWidget {
  final VoidCallback onFavoriteTap;

  const BuildAppHeader({super.key, required this.onFavoriteTap});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
      child: Row(
        children: [
          SvgPicture.asset(IconAsset.hewankuLogoSecondary),
          Spacer(),
          _HeaderIconButton(icon: Icons.favorite_border_rounded, color: primaryColor, onTap: onFavoriteTap),
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _HeaderIconButton({required this.icon, required this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF8F8F8),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(width: 36.w, height: 36.h, child: Icon(icon, size: 20.w, color: color)),
      ),
    );
  }
}
