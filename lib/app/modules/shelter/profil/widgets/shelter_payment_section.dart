import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Section metode pembayaran dengan toggle Transfer Bank | QRIS
class ShelterPaymentSection extends StatefulWidget {
  const ShelterPaymentSection({super.key});

  @override
  State<ShelterPaymentSection> createState() => _ShelterPaymentSectionState();
}

class _ShelterPaymentSectionState extends State<ShelterPaymentSection> {
  // 0 = Transfer Bank, 1 = QRIS
  int _selectedPayment = 0;

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
        // ── Toggle Transfer Bank | QRIS ──
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF0F0F0),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              _PaymentTab(
                label: 'Transfer Bank',
                isActive: _selectedPayment == 0,
                onTap: () => setState(() => _selectedPayment = 0),
              ),
              _PaymentTab(
                label: 'QRIS',
                isActive: _selectedPayment == 1,
                onTap: () => setState(() => _selectedPayment = 1),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),

        // ── Konten sesuai tab aktif ──
        if (_selectedPayment == 0) ...[
          // Transfer Bank
          _buildFieldLabel(context, 'Nama Bank'),
          SizedBox(height: 6.h),
          _buildTextField(
            hint: 'Contoh: BCA / Mandiri',
            controller: _namaBankController,
            icon: Icons.account_balance_outlined,
          ),
          SizedBox(height: 14.h),
          _buildFieldLabel(context, 'Nomor Rekening'),
          SizedBox(height: 6.h),
          _buildTextField(
            hint: '1234567890',
            controller: _nomorRekeningController,
            icon: Icons.credit_card_outlined,
            keyboardType: TextInputType.number,
          ),
        ] else ...[
          // QRIS
          _buildFieldLabel(context, 'Nama Bank'),
          SizedBox(height: 6.h),
          _buildTextField(
            hint: 'Contoh: BCA / Mandiri',
            controller: _namaBankController,
            icon: Icons.account_balance_outlined,
          ),
          SizedBox(height: 16.h),

          // Upload foto QRIS
          GestureDetector(
            onTap: () {
              // TODO: buka image picker
            },
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
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE8D6),
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

  Widget _buildFieldLabel(BuildContext context, String label) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: Colors.black87,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildTextField({
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

// Tab toggle Transfer Bank / QRIS
class _PaymentTab extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _PaymentTab({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

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
            style: textTheme.labelLarge?.copyWith(
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
