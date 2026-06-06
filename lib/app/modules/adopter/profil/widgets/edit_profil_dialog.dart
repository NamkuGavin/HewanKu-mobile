import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditProfilDialog extends StatefulWidget {
  final String initialBio;
  final String initialNama;
  final String initialEmail;
  final String initialNoHp;

  const EditProfilDialog({
    super.key,
    required this.initialBio,
    required this.initialNama,
    required this.initialEmail,
    required this.initialNoHp,
  });

  /// Tampilkan dialog dan kembalikan data baru, atau null jika dibatalkan.
  static Future<EditProfilResult?> show(
    BuildContext context, {
    required String initialBio,
    required String initialNama,
    required String initialEmail,
    required String initialNoHp,
  }) {
    return showDialog<EditProfilResult>(
      context: context,
      builder: (_) => EditProfilDialog(
        initialBio: initialBio,
        initialNama: initialNama,
        initialEmail: initialEmail,
        initialNoHp: initialNoHp,
      ),
    );
  }

  @override
  State<EditProfilDialog> createState() => _EditProfilDialogState();
}

class _EditProfilDialogState extends State<EditProfilDialog> {
  late final TextEditingController _bioCtrl;
  late final TextEditingController _namaCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _noHpCtrl;

  @override
  void initState() {
    super.initState();
    _bioCtrl = TextEditingController(text: widget.initialBio);
    _namaCtrl = TextEditingController(text: widget.initialNama);
    _emailCtrl = TextEditingController(text: widget.initialEmail);
    _noHpCtrl = TextEditingController(text: widget.initialNoHp);
  }

  @override
  void dispose() {
    _bioCtrl.dispose();
    _namaCtrl.dispose();
    _emailCtrl.dispose();
    _noHpCtrl.dispose();
    super.dispose();
  }

  void _simpan() {
    Navigator.pop(
      context,
      EditProfilResult(
        bio: _bioCtrl.text.trim(),
        namaLengkap: _namaCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        noHandphone: _noHpCtrl.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
                'Ubah Profil',
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 24.h),
            _buildLabel(context, 'Bio'),
            SizedBox(height: 6.h),
            _buildField(_bioCtrl, hint: 'Tulis sesuatu tentang dirimu...', maxLines: 3),
            SizedBox(height: 16.h),
            _buildLabel(context, 'Nama Lengkap'),
            SizedBox(height: 6.h),
            _buildField(_namaCtrl, hint: 'Nama lengkap'),
            SizedBox(height: 16.h),
            _buildLabel(context, 'Email'),
            SizedBox(height: 6.h),
            _buildField(_emailCtrl, hint: 'Email', keyboardType: TextInputType.emailAddress),
            SizedBox(height: 16.h),
            _buildLabel(context, 'No. Handphone'),
            SizedBox(height: 6.h),
            _buildField(_noHpCtrl, hint: '+628...', keyboardType: TextInputType.phone),
            SizedBox(height: 28.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _simpan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFBA81F),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Simpan',
                  style: textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String label) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: Colors.black87,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildField(
    TextEditingController ctrl, {
    String hint = '',
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: TextStyle(fontSize: 13.sp),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: const Color(0xFFBBBBBB), fontSize: 13.sp),
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: Color(0xFFFBA81F), width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: Color(0xFFFBA81F), width: 1.5),
        ),
      ),
    );
  }
}

class EditProfilResult {
  final String bio;
  final String namaLengkap;
  final String email;
  final String noHandphone;

  const EditProfilResult({
    required this.bio,
    required this.namaLengkap,
    required this.email,
    required this.noHandphone,
  });
}