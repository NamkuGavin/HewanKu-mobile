import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hewanku_mobile/app/common/contant/assets.dart';

// Import LogoutSheet dari adopter — dipakai bersama
import 'package:hewanku_mobile/app/modules/adopter/profil/widgets/logout_sheet.dart';

class ProfilShelterView extends StatefulWidget {
  const ProfilShelterView({super.key});

  @override
  State<ProfilShelterView> createState() => _ProfilShelterViewState();
}

class _ProfilShelterViewState extends State<ProfilShelterView> {
  final _namaShelterController = TextEditingController(
    text: 'Paws Shelter Central',
  );
  final _emailController = TextEditingController(
    text: 'contact@pawsshelter.org',
  );
  final _teleponController = TextEditingController(text: '+62 812 3456 7890');
  final _alamatController = TextEditingController(
    text: 'Jl. Kemang Raya No. 12, Jakarta Selatan, 12730',
  );

  @override
  void dispose() {
    _namaShelterController.dispose();
    _emailController.dispose();
    _teleponController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _ShelterHeader(onNotifTap: () {}),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ShelterCoverAvatar(
                      onEditCover: () {},
                      onEditAvatar: () {},
                    ),
                    SizedBox(height: 52.h),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // INFORMASI DASAR
                          _SectionTitle(title: 'INFORMASI DASAR'),
                          SizedBox(height: 14.h),
                          _InfoField(
                            label: 'Nama Shelter',
                            hintText: 'Paws Shelter Central',
                            controller: _namaShelterController,
                            prefixIcon: Icons.home_outlined,
                          ),
                          SizedBox(height: 14.h),
                          _InfoField(
                            label: 'Email Kontak',
                            hintText: 'contact@shelter.com',
                            controller: _emailController,
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(height: 14.h),
                          _InfoField(
                            label: 'Nomor Telepon',
                            hintText: '+62 812 3456 7890',
                            controller: _teleponController,
                            prefixIcon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                          ),
                          SizedBox(height: 28.h),

                          // METODE PEMBAYARAN
                          _SectionTitle(title: 'METODE PEMBAYARAN'),
                          SizedBox(height: 14.h),
                          const _PaymentSection(),
                          SizedBox(height: 28.h),

                          // LOKASI & DETAIL
                          _SectionTitle(title: 'LOKASI & DETAIL'),
                          SizedBox(height: 14.h),
                          _InfoField(
                            label: 'Alamat Lengkap',
                            hintText: 'Jl. ...',
                            controller: _alamatController,
                            prefixIcon: Icons.location_on_outlined,
                            maxLines: 3,
                          ),
                          SizedBox(height: 20.h),

                          // Status Verifikasi
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 14.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF3EC),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: const Color(0xFFF87537).withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.verified_user_outlined,
                                  color: primaryColor,
                                  size: 22.sp,
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Status Verifikasi',
                                        style: textTheme.labelLarge?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: primaryColor,
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        'Terverifikasi sejak Jan 2023',
                                        style: textTheme.labelMedium?.copyWith(
                                          color: primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.check_circle,
                                  color: primaryColor,
                                  size: 22.sp,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.h),

                          // ── Tombol SIMPAN PERUBAHAN ──
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.r),
                                ),
                              ),
                              icon: Icon(
                                Icons.save_outlined,
                                color: Colors.white,
                                size: 18.sp,
                              ),
                              label: Text(
                                'SIMPAN PERUBAHAN',
                                style: textTheme.labelLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 12.h),

                          // ── Tombol LOG OUT — sama persis dengan adopter ──
                          GestureDetector(
                            onTap: () => LogoutSheet.show(context),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                horizontal: 18.w,
                                vertical: 14.h,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF87537),
                                borderRadius: BorderRadius.circular(50.r),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.logout_rounded,
                                    color: Colors.white,
                                    size: 18.sp,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    'Log Out',
                                    style: textTheme.labelLarge?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Header ──
class _ShelterHeader extends StatelessWidget {
  final VoidCallback? onNotifTap;
  const _ShelterHeader({this.onNotifTap});

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

// ── Cover + Avatar ──
class _ShelterCoverAvatar extends StatelessWidget {
  final VoidCallback? onEditCover;
  final VoidCallback? onEditAvatar;
  const _ShelterCoverAvatar({this.onEditCover, this.onEditAvatar});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          height: 160.h,
          decoration: const BoxDecoration(
            image: DecorationImage(
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
                  decoration: const BoxDecoration(
                    color: Color(0xFFF87537),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.edit, color: Colors.white, size: 14.sp),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -40.h,
          left: 20.w,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 80.w,
                height: 80.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=200',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
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

// ── Info Field ──
class _InfoField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final IconData prefixIcon;
  final TextInputType keyboardType;
  final int maxLines;

  const _InfoField({
    required this.label,
    required this.hintText,
    required this.controller,
    required this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.labelLarge?.copyWith(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 6.h),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: textTheme.labelLarge?.copyWith(color: Colors.black87),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: textTheme.labelLarge?.copyWith(
              color: const Color(0xFF9E9E9E),
            ),
            prefixIcon: Icon(
              prefixIcon,
              size: 18.sp,
              color: const Color(0xFF9E9E9E),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 14.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(
                color: Color(0xFFF87537),
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Payment Section ──
class _PaymentSection extends StatefulWidget {
  const _PaymentSection();

  @override
  State<_PaymentSection> createState() => _PaymentSectionState();
}

class _PaymentSectionState extends State<_PaymentSection> {
  int _selected = 0;
  final _namaBankController = TextEditingController();
  final _nomorRekeningController = TextEditingController(text: '1234567890');

  @override
  void dispose() {
    _namaBankController.dispose();
    _nomorRekeningController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF0F0F0),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              _TabBtn(
                label: 'Transfer Bank',
                isActive: _selected == 0,
                onTap: () => setState(() => _selected = 0),
              ),
              _TabBtn(
                label: 'QRIS',
                isActive: _selected == 1,
                onTap: () => setState(() => _selected = 1),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        if (_selected == 0) ...[
          _fieldLabel(context, 'Nama Bank'),
          SizedBox(height: 6.h),
          _textField(
            context,
            hint: 'Contoh: BCA / Mandiri',
            controller: _namaBankController,
            icon: Icons.account_balance_outlined,
          ),
          SizedBox(height: 14.h),
          _fieldLabel(context, 'Nomor Rekening'),
          SizedBox(height: 6.h),
          _textField(
            context,
            hint: '1234567890',
            controller: _nomorRekeningController,
            icon: Icons.credit_card_outlined,
            keyboardType: TextInputType.number,
          ),
        ] else ...[
          _fieldLabel(context, 'Nama Bank'),
          SizedBox(height: 6.h),
          _textField(
            context,
            hint: 'Contoh: BCA / Mandiri',
            controller: _namaBankController,
            icon: Icons.account_balance_outlined,
          ),
          SizedBox(height: 16.h),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: double.infinity,
              height: 180.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 56.w,
                    height: 56.h,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFE8D6),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.add_a_photo_outlined,
                      color: const Color(0xFFF87537),
                      size: 26.sp,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Unggah Foto QRIS',
                    style: textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Format PNG dan JPEG hingga 50MB',
                    style: textTheme.labelMedium?.copyWith(
                      color: const Color(0xFF9E9E9E),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _fieldLabel(BuildContext context, String label) => Text(
    label,
    style: Theme.of(context).textTheme.labelLarge?.copyWith(
      color: Colors.black87,
      fontWeight: FontWeight.w500,
    ),
  );

  Widget _textField(
    BuildContext context, {
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: Theme.of(
        context,
      ).textTheme.labelLarge?.copyWith(color: Colors.black87),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: Theme.of(
          context,
        ).textTheme.labelLarge?.copyWith(color: const Color(0xFF9E9E9E)),
        prefixIcon: Icon(icon, size: 18.sp, color: const Color(0xFF9E9E9E)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Color(0xFFF87537), width: 1.5),
        ),
      ),
    );
  }
}

class _TabBtn extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  const _TabBtn({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: EdgeInsets.all(4.w),
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10.r),
            border: isActive
                ? Border.all(color: const Color(0xFFF87537), width: 1.5)
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: isActive
                  ? const Color(0xFFF87537)
                  : const Color(0xFF9E9E9E),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w800,
        color: Colors.black,
        letterSpacing: 0.5,
      ),
    );
  }
}
