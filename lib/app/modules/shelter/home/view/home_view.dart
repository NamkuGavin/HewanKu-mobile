import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hewanku_mobile/app/common/contant/assets.dart';
import 'package:hewanku_mobile/app/modules/shelter/hewan/widgets/hewan_card.dart';
import 'package:hewanku_mobile/app/modules/shelter/hewan/view/tambah_hewan_view.dart';

// Import widget-widget dari folder home/widgets/
import '../widgets/home_shelter_banner.dart';
import '../widgets/home_stat_card.dart';
import '../widgets/home_section_header.dart';
import '../widgets/home_permohonan_card.dart';

// ============================================================
// lib/app/modules/shelter/home/view/home_view.dart
//
// View ini hanya berisi:
// 1. State (data + logika navigasi)
// 2. build() yang merakit widget-widget dari widgets/
// Tidak ada UI detail di sini — semua ada di masing-masing widget
// ============================================================

class HomeShelterView extends StatefulWidget {
  final VoidCallback? onGoToProfil;
  final VoidCallback? onGoToHewan;
  final VoidCallback? onGoToPermohonan;

  const HomeShelterView({
    super.key,
    this.onGoToProfil,
    this.onGoToHewan,
    this.onGoToPermohonan,
  });

  @override
  State<HomeShelterView> createState() => _HomeShelterViewState();
}

class _HomeShelterViewState extends State<HomeShelterView> {
  // ── Data dummy — ganti dengan API nanti ──────────────────
  final List<Map<String, dynamic>> _hewanList = [
    {
      'name': 'Mochi',
      'price': 'Rp 0 (Adopsi)',
      'status': 'AKTIF',
      'statusColor': Colors.green,
      'imageUrl':
          'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=200',
      'waktu': '2 jam lalu',
    },
    {
      'name': 'Buddy',
      'price': 'Rp 0 (Adopsi)',
      'status': 'PENDING',
      'statusColor': Colors.orange,
      'imageUrl':
          'https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=200',
      'waktu': '5 jam lalu',
    },
    {
      'name': 'Luna',
      'price': 'Teradopsi',
      'status': 'SELESAI',
      'statusColor': Colors.grey,
      'imageUrl':
          'https://images.unsplash.com/photo-1596492784531-6e6eb5ea9993?w=200',
      'waktu': '1 hari lalu',
    },
  ];

  final List<Map<String, String>> _permohonanList = [
    {
      'petName': 'Milo',
      'requester': 'Requested by Sarah Jenkins',
      'imageUrl':
          'https://images.unsplash.com/photo-1543466835-00a7907e9de1?w=100',
    },
    {
      'petName': 'Bella',
      'requester': 'Requested by David Chen',
      'imageUrl':
          'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=100',
    },
  ];

  // ── Logika navigasi ──────────────────────────────────────

  Future<void> _bukaHalamanTambah() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (_) => const TambahHewanView()),
    );
    if (result != null && mounted) {
      setState(() => _hewanList.insert(0, result));
    }
  }

  Future<void> _bukaHalamanEdit(Map<String, dynamic> hewan) async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            TambahHewanView(namaAwal: hewan['name'], hargaAwal: hewan['price']),
      ),
    );
    if (result != null && mounted) {
      final idx = _hewanList.indexOf(hewan);
      if (idx != -1) setState(() => _hewanList[idx] = result);
    }
  }

  void _konfirmasiHapus(Map<String, dynamic> hewan) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 32.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 20.h),
            Icon(
              Icons.delete_outline_rounded,
              size: 48.sp,
              color: Colors.red[400],
            ),
            SizedBox(height: 12.h),
            Text(
              'Hapus ${hewan['name']}?',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Data hewan ini akan dihapus permanen dan tidak bisa dikembalikan.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13.sp,
                color: const Color(0xFF9E9E9E),
                height: 1.5,
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      side: const BorderSide(color: Color(0xFFE0E0E0)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.r),
                      ),
                    ),
                    child: Text(
                      'Batal',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      setState(() => _hewanList.remove(hewan));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              Icon(
                                Icons.delete_outline_rounded,
                                color: Colors.white,
                                size: 18.sp,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                '${hewan['name']} telah dihapus',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          backgroundColor: Colors.red[400],
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[400],
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.r),
                      ),
                    ),
                    child: Text(
                      'Hapus',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Build ────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).primaryColor;
    final jumlahAktif = _hewanList.where((h) => h['status'] == 'AKTIF').length;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12.h),

              // ── Header logo + notif ──────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset(IconAsset.hewankuLogoSecondary),
                  Material(
                    color: const Color(0xFFF8F8F8),
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () {},
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
              SizedBox(height: 16.h),

              // ── Search bar ───────────────────────────────
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Cari Hewan...',
                  hintStyle: textTheme.labelLarge?.copyWith(
                    color: const Color(0xFF9E9E9E),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                    size: 20.sp,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFE9E9E9),
                  contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // ── Banner ───────────────────────────────────
              HomeShelterBanner(
                onDaftarShelter: widget.onGoToProfil,
                onDaftarHewan: _bukaHalamanTambah,
              ),
              SizedBox(height: 20.h),

              // ── Statistik ────────────────────────────────
              HomeStatCard(jumlahAktif: jumlahAktif),
              SizedBox(height: 24.h),

              // ── Section Hewan ────────────────────────────
              HomeSectionHeader(
                title: 'Hewan di Shelter kamu',
                onLihatSemua: widget.onGoToHewan,
              ),
              SizedBox(height: 8.h),

              ..._hewanList.map(
                (h) => HewanCard(
                  name: h['name'],
                  price: h['price'],
                  status: h['status'],
                  statusColor: h['statusColor'],
                  imageUrl: h['imageUrl'],
                  waktu: h['waktu'],
                  onEdit: () => _bukaHalamanEdit(h),
                  onDelete: () => _konfirmasiHapus(h),
                ),
              ),

              SizedBox(height: 8.h),

              // ── Section Permohonan ────────────────────────
              HomeSectionHeader(
                title: 'Permohonan Adopsi',
                onLihatSemua: widget.onGoToPermohonan,
              ),
              SizedBox(height: 8.h),

              ..._permohonanList.map(
                (p) => HomePermohonanCard(
                  petName: p['petName']!,
                  requester: p['requester']!,
                  imageUrl: p['imageUrl'],
                  onTap: widget.onGoToPermohonan,
                ),
              ),

              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}
