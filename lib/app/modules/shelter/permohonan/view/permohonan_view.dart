import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../model/permohonan_item.dart';
import '../widgets/permohonan_stat_card.dart';
import '../widgets/permohonan_request_card.dart';

class PermohonanView extends StatefulWidget {
  const PermohonanView({super.key});

  @override
  State<PermohonanView> createState() => _PermohonanViewState();
}

class _PermohonanViewState extends State<PermohonanView> {
  // 0 = Status Form, 1 = Status Pembayaran
  int _activeTab = 0;

  // Data dummy — ganti dengan API nanti
  final List<PermohonanItem> _requests = [
    PermohonanItem(
      id: '1',
      namaHewan: 'Luna',
      jenisHewan: 'Golden Retriever',
      namaAdopter: 'Budi Santoso',
      namaFile: 'Budi_Luna.pdf',
      waktu: '2 mins ago',
      imageUrl:
          'https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=200',
    ),
    PermohonanItem(
      id: '2',
      namaHewan: 'Milo',
      jenisHewan: 'Tabby Cat',
      namaAdopter: 'Siti Aminah',
      namaFile: 'Siti_Milo.pdf',
      waktu: '15 mins ago',
      imageUrl:
          'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=200',
    ),
    PermohonanItem(
      id: '3',
      namaHewan: 'Rocky',
      jenisHewan: 'Bulldog',
      namaAdopter: 'Andi Wijaya',
      namaFile: 'Andi_Rocky.pdf',
      waktu: '1 hour ago',
      imageUrl:
          'https://images.unsplash.com/photo-1583337130417-3346a1be7dee?w=200',
    ),
  ];

  // Hitung statistik dari data
  int get _formMasuk => _requests.length;
  int get _diterima =>
      _requests.where((r) => r.status == StatusPermohonan.disetujui).length;
  int get _ditolak =>
      _requests.where((r) => r.status == StatusPermohonan.ditolak).length;
  List<PermohonanItem> get _pending =>
      _requests.where((r) => r.status == StatusPermohonan.pending).toList();

  // Aksi setuju — update status + tampil snackbar
  void _onSetuju(PermohonanItem item) {
    setState(() => item.status = StatusPermohonan.disetujui);
    _showSnackbar(
      message: 'Form ${item.judulHewan} telah disetujui ✓',
      color: Colors.green,
      icon: Icons.check_circle_outline,
    );
  }

  // Aksi tolak — update status + tampil snackbar
  void _onTolak(PermohonanItem item) {
    setState(() => item.status = StatusPermohonan.ditolak);
    _showSnackbar(
      message: 'Form ${item.judulHewan} telah ditolak',
      color: Colors.red,
      icon: Icons.cancel_outlined,
    );
  }

  void _showSnackbar({
    required String message,
    required Color color,
    required IconData icon,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 18.sp),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ── Header oranye penuh ──
          Container(
            color: const Color(0xFFF87537),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // Baris back + judul
                  Padding(
                    padding: EdgeInsets.fromLTRB(8.w, 8.h, 20.w, 12.h),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Permohonan',
                            textAlign: TextAlign.center,
                            style: textTheme.bodyLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(width: 44.w), // balance icon back
                      ],
                    ),
                  ),

                  // Toggle Status Form | Status Pembayaran
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Row(
                        children: [
                          _TabItem(
                            label: 'Status Form',
                            isActive: _activeTab == 0,
                            onTap: () => setState(() => _activeTab = 0),
                          ),
                          _TabItem(
                            label: 'Status\nPembayaran',
                            isActive: _activeTab == 1,
                            onTap: () => setState(() => _activeTab = 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Konten ──
          Expanded(
            child: _activeTab == 0
                ? _buildStatusForm(textTheme)
                : _buildStatusPembayaran(textTheme),
          ),
        ],
      ),
    );
  }

  // ── Tab Status Form ──
  Widget _buildStatusForm(TextTheme textTheme) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul section
          Text(
            'Adopsi Form',
            style: textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 22.sp,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Kelola formulir adopsi hewan peliharaan yang masuk',
            style: textTheme.labelLarge?.copyWith(
              color: const Color(0xFF9E9E9E),
            ),
          ),
          SizedBox(height: 20.h),

          // 3 Stat cards
          Row(
            children: [
              PermohonanStatCard(
                icon: Icons.assignment_outlined,
                iconColor: const Color(0xFFF87537),
                iconBgColor: const Color(0xFFFFF3EC),
                borderColor: const Color(0xFFF87537),
                label: 'FORM\nMASUK',
                count: _formMasuk,
              ),
              SizedBox(width: 10.w),
              PermohonanStatCard(
                icon: Icons.check_circle_outline,
                iconColor: Colors.green,
                iconBgColor: const Color(0xFFE8F5E9),
                borderColor: Colors.green,
                label: 'DITERIMA',
                count: _diterima,
              ),
              SizedBox(width: 10.w),
              PermohonanStatCard(
                icon: Icons.cancel_outlined,
                iconColor: Colors.red,
                iconBgColor: const Color(0xFFFFEBEE),
                borderColor: Colors.red,
                label: 'DITOLAK',
                count: _ditolak,
              ),
            ],
          ),
          SizedBox(height: 24.h),

          // Pending Requests
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pending Requests',
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'View all',
                  style: TextStyle(
                    color: const Color(0xFFF87537),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),

          // List request
          if (_pending.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40.h),
                child: Column(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 60.sp,
                      color: Colors.green,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'Semua permohonan sudah ditangani',
                      style: textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF9E9E9E),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...List.generate(_pending.length, (i) {
              final item = _pending[i];
              return PermohonanRequestCard(
                item: item,
                onSetuju: () => _onSetuju(item),
                onTolak: () => _onTolak(item),
              );
            }),
        ],
      ),
    );
  }

  // ── Tab Status Pembayaran (placeholder) ──
  Widget _buildStatusPembayaran(TextTheme textTheme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.payment_outlined,
            size: 60.sp,
            color: const Color(0xFFF87537),
          ),
          SizedBox(height: 16.h),
          Text(
            'Status Pembayaran',
            style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 8.h),
          Text(
            'Halaman ini akan dibuat selanjutnya',
            style: textTheme.labelLarge?.copyWith(
              color: const Color(0xFF9E9E9E),
            ),
          ),
        ],
      ),
    );
  }
}

// Tab button di header oranye
class _TabItem extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TabItem({
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
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            // Aktif = FBA81F (kuning oranye), nonaktif = transparan
            color: isActive ? const Color(0xFFFBA81F) : Colors.transparent,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              // Aktif = putih, nonaktif = putih juga (di atas bg oranye header)
              color: Colors.white,
              height: 1.3,
            ),
          ),
        ),
      ),
    );
  }
}
