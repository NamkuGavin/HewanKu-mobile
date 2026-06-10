import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../adopsi/widgets/hewan_model.dart';
import '../../../../common/widgets/app_net_image.dart';
import '../../../../common/contant/assets.dart';

const _orange = Color(0xFFF87537);

// ── Tile metode pembayaran ────────────────────────────────────────────────────
class PaymentMethodTile extends StatelessWidget {
  final String logoAsset;
  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentMethodTile({
    super.key,
    required this.logoAsset,
    required this.name,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 14.h),
        child: Row(
          children: [
            Image.asset(logoAsset, height: 28.h, width: 52.w, fit: BoxFit.contain),
            Container(
              width: 1, height: 32.h,
              color: const Color(0xFFE0E0E0),
              margin: EdgeInsets.symmetric(horizontal: 14.w),
            ),
            Expanded(
              child: Text(name,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500, color: Colors.black87)),
            ),
            _RadioCircle(isSelected: isSelected),
          ],
        ),
      ),
    );
  }
}

class _RadioCircle extends StatelessWidget {
  final bool isSelected;
  const _RadioCircle({required this.isSelected});

  @override
  Widget build(BuildContext context) => Container(
    width: 22.w, height: 22.w,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: _orange, width: 1.5),
    ),
    child: isSelected
        ? Center(
            child: Container(
              width: 12.w, height: 12.w,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: _orange),
            ),
          )
        : null,
  );
}

// ── Tabel Rincian Pesanan ────────────────────────────────────────────────────  
class OrderProductTable extends StatelessWidget {
  final HewanModel hewan;
  const OrderProductTable({super.key, required this.hewan});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE0E0E0)),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.vertical(top: Radius.circular(10.r)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text('Produk',
                    style: textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600, color: const Color(0xFF555555))),
                ),
                Text('Harga',
                  style: textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600, color: const Color(0xFF555555))),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
          // Row produk — tanpa icon cancel
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6.r),
                  child: SizedBox(
                    width: 40.w, height: 40.h,
                    child: AppNetImage(
                      url: hewan.imageUrl,
                      fallbackColor: Color(hewan.fallbackColorValue),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(hewan.name,
                        style: textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600, color: Colors.black),
                        overflow: TextOverflow.ellipsis),
                      Text(hewan.shelter,
                        style: textTheme.labelSmall?.copyWith(color: const Color(0xFF9E9E9E)),
                        overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Text(hewan.priceRange,
                  style: textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600, color: Colors.black)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Card detail hewan ─────────────────────────────────────────────────────────
class HewanDetailCard extends StatelessWidget {
  final HewanModel hewan;
  const HewanDetailCard({super.key, required this.hewan});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final rows = [
      ['Nama Hewan', hewan.name],
      ['Ras', hewan.ras ?? '-'],
      ['Umur', hewan.umur ?? '-'],
      ['Berat', hewan.berat ?? '-'],
      ['Kesehatan', hewan.kesehatan ?? '-'],
    ];

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8EE),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: _orange.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: rows.map((r) => Padding(
          padding: EdgeInsets.only(bottom: 6.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 70.w,
                child: Text(r[0],
                  style: textTheme.labelMedium?.copyWith(color: const Color(0xFF9E9E9E))),
              ),
              Expanded(
                child: Text(r[1],
                  style: textTheme.labelMedium?.copyWith(
                    color: Colors.black87, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        )).toList(),
      ),
    );
  }
}

// ── Card kontak shelter ──────────────────────────────────────────────────────
class KontakShelterCard extends StatelessWidget {
  final String namaShelter;
  final String nomor;
  final VoidCallback onTap;

  const KontakShelterCard({
    super.key,
    required this.namaShelter,
    required this.nomor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 110.w,
        height: double.infinity,
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: const Color(0xFFD4F5D4),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Kontak Shelter',
              textAlign: TextAlign.center,
              style: textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2E7D32),
              ),
            ),

            SizedBox(height: 4.h),

            Text(
              namaShelter,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textTheme.labelSmall?.copyWith(
                color: const Color(0xFF388E3C),
              ),
            ),

            SizedBox(height: 10.h),

            Image.asset(
              IconAsset.whatsappIcon,
              width: 28.w,
              height: 28.w,
            ),

            SizedBox(height: 8.h),

            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                nomor,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2E7D32),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Dialog QRIS ───────────────────────────────────────────────────────────────
class QrisDialog extends StatelessWidget {
  final String total;
  const QrisDialog({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back_rounded, color: _orange, size: 22.sp),
                  ),
                  Row(
                    children: [
                      Icon(Icons.pets, color: Colors.black, size: 20.sp),
                      SizedBox(width: 6.w),
                      Text('HewanKu',
                        style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700)),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.network(
                  'https://images.unsplash.com/photo-1595078475328-1ab05d0a6a0e?w=400',
                  width: double.infinity, height: 280.h, fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    width: double.infinity, height: 280.h,
                    color: const Color(0xFFF5F5F5),
                    child: Center(child: Icon(Icons.qr_code_2_rounded, size: 120.sp, color: const Color(0xFF333333))),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text('Total Pembayaran',
                style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700)),
              SizedBox(height: 8.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  children: [
                    Expanded(child: Text(total,
                      style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700))),
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: total));
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text('Total disalin'),
                          backgroundColor: _orange,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                          duration: const Duration(seconds: 1),
                        ));
                      },
                      child: Icon(Icons.copy_outlined, size: 20.sp, color: const Color(0xFF555555)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Dialog Transfer ───────────────────────────────────────────────────────────
class TransferDialog extends StatelessWidget {
  final String method;
  final String total;
  final String nomorRekening;
  final String atasNama;

  const TransferDialog({
    super.key,
    required this.method,
    required this.total,
    required this.nomorRekening,
    required this.atasNama,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 60.h),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back_rounded, color: _orange, size: 22.sp),
                ),
                Row(
                  children: [
                    Icon(Icons.pets, color: Colors.black, size: 20.sp),
                    SizedBox(width: 6.w),
                    Text('HewanKu',
                      style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 24.h),
            Center(child: Text('Transfer via $method',
              style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700))),
            SizedBox(height: 20.h),
            _InfoRow(label: 'Nomor Rekening', value: nomorRekening, copyable: true),
            SizedBox(height: 12.h),
            _InfoRow(label: 'Atas Nama', value: atasNama),
            SizedBox(height: 12.h),
            _InfoRow(
              label: 'Total Transfer', value: total, copyable: true,
              valueStyle: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w800, color: Colors.black),
            ),
            SizedBox(height: 20.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3EC),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: _orange.withValues(alpha: 0.3)),
              ),
              child: Text(
                'Selesaikan pembayaran dalam 24 jam. Kirim bukti transfer ke kontak shelter setelah bayar.',
                style: textTheme.labelMedium?.copyWith(color: const Color(0xFFF87537), height: 1.5),
              ),
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFBA81F),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.r)),
                ),
                child: Text('Saya sudah Transfer',
                  style: textTheme.labelLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool copyable;
  final TextStyle? valueStyle;

  const _InfoRow({
    required this.label,
    required this.value,
    this.copyable = false,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                  style: textTheme.labelMedium?.copyWith(color: const Color(0xFF9E9E9E))),
                SizedBox(height: 2.h),
                Text(value,
                  style: valueStyle ?? textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700, color: Colors.black)),
              ],
            ),
          ),
          if (copyable)
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: value));
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('$label disalin'),
                  backgroundColor: _orange,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                  duration: const Duration(seconds: 1),
                ));
              },
              child: Icon(Icons.copy_outlined, size: 18.sp, color: const Color(0xFF555555)),
            ),
        ],
      ),
    );
  }
}