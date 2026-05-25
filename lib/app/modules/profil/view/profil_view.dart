import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/profile_avatar_widget.dart';
import '../widgets/profile_bio_card.dart';
import '../widgets/profile_info_section.dart';
import '../widgets/profile_action_button.dart';
import '../widgets/profile_header_widget.dart';

class ProfilView extends StatelessWidget {
  const ProfilView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header — navigasi ke favorit & notif sudah di-handle di dalam widget
        const ProfileHeaderWidget(),

        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),

                // 1. Foto profil
                ProfileAvatarWidget(
                  imageUrl: null,
                  onEditTap: () {
                    // TODO: buka image picker
                  },
                ),
                SizedBox(height: 24.h),

                // 2. Tentang Aku
                ProfileBioCard(
                  bio:
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, '
                      'sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
                      'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris '
                      'nisi ut aliquip ex ea commodo consequat.',
                ),
                SizedBox(height: 28.h),

                // 3. Informasi Pribadi
                ProfileInfoSection(
                  namaLengkap: 'Ali Luqmanul hakim',
                  email: 'alihakimluqmasdaliaks@gmail.com',
                  nomorHandphone: '+6291278312873',
                  onEditTap: () {
                    // TODO: navigasi ke halaman edit profil
                  },
                ),
                SizedBox(height: 28.h),

                // 4. Ubah Kata Sandi
                ProfileActionButton(
                  icon: Icons.lock_outline_rounded,
                  label: 'Ubah Kata Sandi',
                  onTap: () {
                    // TODO: navigasi ke halaman ubah kata sandi
                  },
                ),
                SizedBox(height: 12.h),

                // 5. Log Out
                ProfileActionButton(
                  icon: Icons.logout_rounded,
                  label: 'Log Out',
                  onTap: () {
                    // TODO: logic logout
                  },
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
