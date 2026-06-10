import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/contant/assets.dart';
import '../../../../common/utils/app_navigator.dart';
import '../../adopsi/widgets/hewan_model.dart';
import '../model/pesanan_item.dart';
import '../widgets/pembayaran_widgets.dart';

class PesananPembayaranView extends StatefulWidget {
  final PesananItem pesanan;
  final HewanModel hewan;

  const PesananPembayaranView({
    super.key,
    required this.pesanan,
    required this.hewan,
  });

  @override
  State<PesananPembayaranView> createState() => _PesananPembayaranViewState();
}

class _PesananPembayaranViewState extends State<PesananPembayaranView> {
  int _selectedPayment = -1; // -1 = belum pilih

  static const _methods = [
    _PaymentMethod('Gopay', ImageAsset.gopay),
    _PaymentMethod('Qris', ImageAsset.qris),
    _PaymentMethod('Mandiri', ImageAsset.mandiriLogo),
    _PaymentMethod('Dana', ImageAsset.danaLogo),
  ];

  void _onLanjutkanBayar() {
    if (_selectedPayment < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pilih metode pembayaran terlebih dahulu', style: GoogleFonts.poppins(fontSize: 14.sp)),
          backgroundColor: const Color(0xFFF87537),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 180.h),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.r)),
        ),
      );
      return;
    }
    final method = _methods[_selectedPayment].name;
    if (method == 'Qris') {
      _showQrisDialog();
    } else {
      _showTransferDialog(method);
    }
  }

  void _showQrisDialog() {
    showDialog(
      context: context,
      builder: (_) => QrisDialog(total: widget.hewan.priceRange),
    );
  }

  void _showTransferDialog(String method) {
    showDialog(
      context: context,
      builder: (_) => TransferDialog(
        method: method,
        total: widget.hewan.priceRange,
        nomorRekening: '1234 5678 9012 3456',
        atasNama: widget.pesanan.namaShelter,
      ),
    );
  }

  Future<void> _hubungiShelter() async {
    final nomor = (widget.hewan.kontakShelter ?? '+6282738712871')
        .replaceAll('+', '')
        .replaceAll(' ', '');
    final uri = Uri.parse('https://wa.me/$nomor');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).primaryColor;
    final h = widget.hewan;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // ── AppBar ──
            Padding(
              padding: EdgeInsets.fromLTRB(8.w, 12.h, 20.w, 10.h),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => AppNavigator.pop(context),
                    icon: Icon(Icons.arrow_back_rounded, color: primaryColor, size: 24.sp),
                  ),
                  Expanded(
                    child: Text(
                      'Rincian Pembayaran',
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(width: 40.w),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Pilih Metode Pembayaran ──
                    _SectionCard(
                      child: Column(
                        children: List.generate(_methods.length, (i) {
                          final isLast = i == _methods.length - 1;
                          return Column(
                            children: [
                              PaymentMethodTile(
                                logoAsset: _methods[i].logo,
                                name: _methods[i].name,
                                isSelected: _selectedPayment == i,
                                onTap: () => setState(() => _selectedPayment = i),
                              ),
                              if (!isLast)
                                Divider(height: 1, thickness: 1, color: const Color(0xFFF0F0F0)),
                            ],
                          );
                        }),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // ── Rincian Pesanan ──
                    _SectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Rincian Pesanan',
                                  style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700)),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('Batas Pembayaran',
                                      style: textTheme.labelMedium?.copyWith(
                                          color: const Color(0xFF9E9E9E))),
                                  Text('23:50:00',
                                      style: textTheme.labelLarge?.copyWith(
                                          color: primaryColor, fontWeight: FontWeight.w700)),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),

                          // Tabel produk
                          OrderProductTable(hewan: h),
                          SizedBox(height: 16.h),

                          // Detail hewan
                          Text('Detail Hewan',
                              style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700)),
                          SizedBox(height: 10.h),

                          IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: HewanDetailCard(hewan: h),
                                ),
                                SizedBox(width: 10.w),
                                KontakShelterCard(
                                  namaShelter: widget.pesanan.namaShelter,
                                  nomor: h.kontakShelter ?? '+6282738712871',
                                  onTap: _hubungiShelter,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── Tombol Lanjutkan Bayar ──
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _onLanjutkanBayar,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFBA81F),
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.r)),
                        ),
                        child: Text('LANJUTKAN BAYAR',
                          style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
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

class _SectionCard extends StatelessWidget {
  final Widget child;
  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: child,
      );
}

class _PaymentMethod {
  final String name;
  final String logo;
  const _PaymentMethod(this.name, this.logo);
}