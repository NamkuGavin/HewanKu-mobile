import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileAvatarWidget extends StatelessWidget {
  final String? imageUrl;
  final VoidCallback? onEditTap;

  const ProfileAvatarWidget({super.key, this.imageUrl, this.onEditTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          // Foto profil bulat
          CircleAvatar(
            radius: 50.r,
            backgroundColor: const Color(0xFFE0E0E0),
            backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
            child: imageUrl == null
                ? Icon(Icons.person, size: 50.r, color: Colors.white)
                : null,
          ),

          // Tombol edit (+) di pojok kanan bawah
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: onEditTap,
              child: Container(
                width: 24.w,
                height: 24.h,
                decoration: const BoxDecoration(
                  color: Color(0xFFF87537),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.add, color: Colors.white, size: 16.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
