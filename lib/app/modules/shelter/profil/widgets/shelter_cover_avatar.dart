import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShelterCoverAvatar extends StatelessWidget {
  final String? coverUrl;
  final String? avatarUrl;
  final VoidCallback? onEditCover;
  final VoidCallback? onEditAvatar;

  const ShelterCoverAvatar({
    super.key,
    this.coverUrl,
    this.avatarUrl,
    this.onEditCover,
    this.onEditAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // ── Cover foto shelter (landscape) ──
        Container(
          width: double.infinity,
          height: 160.h,
          decoration: BoxDecoration(
            color: const Color(0xFFE0E0E0),
            image: coverUrl != null
                ? DecorationImage(
                    image: NetworkImage(coverUrl!),
                    fit: BoxFit.cover,
                  )
                : const DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1601758124510-52d02ddb7cbd?w=600',
                    ),
                    fit: BoxFit.cover,
                  ),
          ),
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.all(10.w),
              child: GestureDetector(
                onTap: onEditCover,
                child: Container(
                  width: 30.w,
                  height: 30.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF87537),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Icon(Icons.edit, color: Colors.white, size: 14.sp),
                ),
              ),
            ),
          ),
        ),

        // ── Foto profil + tombol edit ──
        Positioned(
          bottom: -40.h,
          left: 20.w,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Foto profil
              Container(
                width: 80.w,
                height: 80.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  color: const Color(0xFFE0E0E0),
                  image: avatarUrl != null
                      ? DecorationImage(
                          image: NetworkImage(avatarUrl!),
                          fit: BoxFit.cover,
                        )
                      : const DecorationImage(
                          image: NetworkImage(
                            'https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=200',
                          ),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              // Tombol edit avatar
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: onEditAvatar,
                  child: Container(
                    width: 24.w,
                    height: 24.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF87537),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Icon(Icons.edit, color: Colors.white, size: 12.sp),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
