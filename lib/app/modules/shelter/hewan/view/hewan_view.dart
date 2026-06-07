import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hewanku_mobile/app/common/contant/assets.dart';
import 'package:hewanku_mobile/app/modules/shelter/hewan/widgets/hewan_card.dart';
import 'package:hewanku_mobile/app/modules/shelter/hewan/widgets/hewan_banner.dart';
import 'package:hewanku_mobile/app/modules/shelter/hewan/view/tambah_hewan_view.dart';

// ============================================================
// LETAKNYA DI:
// lib/app/modules/shelter/hewan/view/hewan_view.dart
// ============================================================

class HewanShelterView extends StatefulWidget {
  const HewanShelterView({super.key});

  @override
  State<HewanShelterView> createState() => _HewanShelterViewState();
}

class _HewanShelterViewState extends State<HewanShelterView> {
  final _searchController = TextEditingController();

  // ── Data dummy — ganti dengan API nanti ──
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

  // ── List yang sudah difilter berdasarkan search ──
  List<Map<String, dynamic>> get _filteredList {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) return _hewanList;
    return _hewanList
        .where((h) => (h['name'] as String).toLowerCase().contains(query))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ── Navigasi ke TambahHewanView, tunggu data kembali ─────
  Future<void> _bukaHalamanTambah() async {
    // Tunggu hasil dari TambahHewanView
    // Kalau user publikasi → dapat Map data hewan
    // Kalau user buang draf / back → dapat null
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (_) => const TambahHewanView()),
    );

    // ✅ Kalau dapat data, tambahkan ke list
    if (result != null) {
      setState(() {
        _hewanList.insert(0, result); // tambah di posisi paling atas
      });

      // Snackbar konfirmasi
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.pets_rounded, color: Colors.white, size: 18.sp),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  '${result['name']} berhasil ditambahkan ke daftar!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFFF87537),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  // ── Navigasi ke edit hewan ────────────────────────────────
  Future<void> _bukaHalamanEdit(Map<String, dynamic> hewan) async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            TambahHewanView(namaAwal: hewan['name'], hargaAwal: hewan['price']),
      ),
    );

    // Update data jika ada perubahan
    if (result != null) {
      setState(() {
        final idx = _hewanList.indexOf(hewan);
        if (idx != -1) _hewanList[idx] = result;
      });
    }
  }

  // ── Konfirmasi hapus ──────────────────────────────────────
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
            // Handle bar
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
                // Batal
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
                // Hapus
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
                              Expanded(
                                child: Text(
                                  '${hewan['name']} telah dihapus',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
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

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).primaryColor;
    final filtered = _filteredList;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12.h),

              // ── Header: logo + notif ──
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

              // ── Search bar ──
              TextFormField(
                controller: _searchController,
                onChanged: (_) => setState(() {}), // trigger filter
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

              // ── Banner tambah hewan ──
              HewanBanner(
                // ✅ FIX: panggil _bukaHalamanTambah, bukan TODO
                onTambah: _bukaHalamanTambah,
              ),
              SizedBox(height: 20.h),

              // ── Stat: Total Hewan + Tersedia ──
              Row(
                children: [
                  // Total Hewan — auto update dari _hewanList.length
                  Expanded(
                    child: _StatCard(
                      icon: Icons.assignment_outlined,
                      iconBgColor: const Color(0xFFFFF3EC),
                      iconColor: primaryColor,
                      label: 'Total Hewan',
                      // ✅ auto-update jumlah
                      value: '${_hewanList.length}',
                    ),
                  ),
                  SizedBox(width: 12.w),
                  // Tersedia — hewan dengan status AKTIF
                  Expanded(
                    child: _StatCard(
                      icon: Icons.check_circle_outline,
                      iconBgColor: const Color(0xFFE8F5E9),
                      iconColor: Colors.green,
                      label: 'Tersedia',
                      // ✅ auto-update: hitung yang AKTIF
                      value:
                          '${_hewanList.where((h) => h['status'] == 'AKTIF').length}',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              // ── Judul daftar ──
              Text(
                'Daftar Inventaris Hewan',
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 14.h),

              Text(
                'Hewan di Shelter kamu',
                style: textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 12.h),

              // ── Empty state jika search kosong ──
              if (filtered.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 32.h),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.pets_rounded,
                          size: 48.sp,
                          color: Colors.grey[300],
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'Tidak ada hewan ditemukan',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.grey,
                            fontSize: 13.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // ── List hewan ──
              ...filtered.map(
                (h) => HewanCard(
                  name: h['name'],
                  price: h['price'],
                  status: h['status'],
                  statusColor: h['statusColor'],
                  imageUrl: h['imageUrl'],
                  waktu: h['waktu'],
                  onEdit: () => _bukaHalamanEdit(h), // ✅ buka edit
                  onDelete: () => _konfirmasiHapus(h), // ✅ konfirmasi hapus
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

// ── Widget kartu statistik (reusable) ────────────────────────
class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36.w,
            height: 36.h,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, color: iconColor, size: 20.sp),
          ),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: textTheme.labelMedium?.copyWith(
                  color: const Color(0xFF9E9E9E),
                  fontSize: 10.sp,
                ),
              ),
              Text(
                value,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                  fontSize: 22.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
