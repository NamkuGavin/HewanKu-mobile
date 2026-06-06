import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UbahSandiDialog extends StatefulWidget {
  const UbahSandiDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => const UbahSandiDialog(),
    );
  }

  @override
  State<UbahSandiDialog> createState() => _UbahSandiDialogState();
}

class _UbahSandiDialogState extends State<UbahSandiDialog> {
  final _sandiLamaCtrl = TextEditingController();
  final _sandiBaru = TextEditingController();
  final _konfirmasiCtrl = TextEditingController();

  bool _obscureLama = true;
  bool _obscureBaru = true;
  bool _obscureKonfirmasi = true;

  @override
  void dispose() {
    _sandiLamaCtrl.dispose();
    _sandiBaru.dispose();
    _konfirmasiCtrl.dispose();
    super.dispose();
  }

  void _simpan() {
    // TODO: validasi & panggil API
    Navigator.pop(context);
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
                'Ubah Sandi Baru',
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 24.h),
            _buildLabel(context, 'Sandi Lama'),
            SizedBox(height: 6.h),
            _buildPasswordField(
              _sandiLamaCtrl,
              obscure: _obscureLama,
              onToggle: () => setState(() => _obscureLama = !_obscureLama),
            ),
            SizedBox(height: 16.h),
            _buildLabel(context, 'Sandi Baru'),
            SizedBox(height: 6.h),
            _buildPasswordField(
              _sandiBaru,
              obscure: _obscureBaru,
              onToggle: () => setState(() => _obscureBaru = !_obscureBaru),
            ),
            SizedBox(height: 16.h),
            _buildLabel(context, 'Konfirmasi Sandi'),
            SizedBox(height: 6.h),
            _buildPasswordField(
              _konfirmasiCtrl,
              obscure: _obscureKonfirmasi,
              onToggle: () => setState(() => _obscureKonfirmasi = !_obscureKonfirmasi),
            ),
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

  Widget _buildPasswordField(
    TextEditingController ctrl, {
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: ctrl,
      obscureText: obscure,
      style: TextStyle(fontSize: 13.sp),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            size: 18.sp,
            color: const Color(0xFF9E9E9E),
          ),
          onPressed: onToggle,
        ),
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