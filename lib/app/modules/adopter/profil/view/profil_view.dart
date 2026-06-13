import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/profile_avatar_widget.dart';
import '../widgets/profile_bio_card.dart';
import '../widgets/profile_info_section.dart';
import '../widgets/profile_action_button.dart';
import '../widgets/profile_header_widget.dart';
import '../widgets/logout_sheet.dart';
import '../widgets/edit_profil_dialog.dart';
import '../widgets/ubah_sandi_dialog.dart';

class ProfilView extends StatefulWidget {
  const ProfilView({super.key});

  @override
  State<ProfilView> createState() => _ProfilViewState();
}

class _ProfilViewState extends State<ProfilView> {
  String _bio = '';
  String _namaLengkap = 'Ali Luqmanul hakim';
  String _email = 'alihakimluqmasdaliaks@gmail.com';
  String _noHandphone = '+6291278312873';

  Future<void> _bukaEditProfil() async {
    final result = await EditProfilDialog.show(
      context,
      initialBio: _bio,
      initialNama: _namaLengkap,
      initialEmail: _email,
      initialNoHp: _noHandphone,
    );
    if (result != null) {
      setState(() {
        _bio = result.bio;
        _namaLengkap = result.namaLengkap;
        _email = result.email;
        _noHandphone = result.noHandphone;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ProfileHeaderWidget(),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                ProfileAvatarWidget(
                  imageUrl: null,
                  onEditTap: () {
                    // TODO: buka image picker
                  },
                ),
                SizedBox(height: 24.h),
                ProfileBioCard(bio: _bio),
                SizedBox(height: 28.h),
                ProfileInfoSection(
                  namaLengkap: _namaLengkap,
                  email: _email,
                  noHandphone: _noHandphone,
                  onEditTap: _bukaEditProfil,
                ),
                SizedBox(height: 28.h),
                ProfileActionButton(
                  icon: Icons.lock_outline_rounded,
                  label: 'Ubah Kata Sandi',
                  onTap: () => UbahSandiDialog.show(context),
                ),
                SizedBox(height: 12.h),
                ProfileActionButton(
                  icon: Icons.logout_rounded,
                  label: 'Log Out',
                  onTap: () => LogoutSheet.show(context),
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
