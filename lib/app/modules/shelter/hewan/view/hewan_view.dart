import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hewanku_mobile/app/common/contant/assets.dart';
import 'package:hewanku_mobile/app/modules/shelter/hewan/widgets/hewan_card.dart';
import 'package:hewanku_mobile/app/modules/shelter/hewan/widgets/hewan_banner.dart';

class HewanShelterView extends StatefulWidget {
  const HewanShelterView({super.key});

  @override
  State<HewanShelterView> createState() => _HewanShelterViewState();
}

class _HewanShelterViewState extends State<HewanShelterView> {
  final _searchController = TextEditingController();

  // Data dummy — ganti dengan API nanti
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).primaryColor;

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
                onTambah: () {
                  // TODO: navigasi ke halaman tambah hewan
                },
              ),
              SizedBox(height: 20.h),

              // ── Stat: Total Hewan + Tersedia ──
              Row(
                children: [
                  // Total Hewan
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
                      ),
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
                              color: const Color(0xFFFFF3EC),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Icon(
                              Icons.assignment_outlined,
                              color: primaryColor,
                              size: 20.sp,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Hewan',
                                style: textTheme.labelMedium?.copyWith(
                                  color: const Color(0xFF9E9E9E),
                                  fontSize: 10.sp,
                                ),
                              ),
                              Text(
                                '42',
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
                    ),
                  ),
                  SizedBox(width: 12.w),

                  // Tersedia
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
                      ),
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
                              color: const Color(0xFFE8F5E9),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Icon(
                              Icons.check_circle_outline,
                              color: Colors.green,
                              size: 20.sp,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tersedia',
                                style: textTheme.labelMedium?.copyWith(
                                  color: const Color(0xFF9E9E9E),
                                  fontSize: 10.sp,
                                ),
                              ),
                              Text(
                                '28',
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

              // ── List hewan ──
              ..._hewanList.map(
                (h) => HewanCard(
                  name: h['name'],
                  price: h['price'],
                  status: h['status'],
                  statusColor: h['statusColor'],
                  imageUrl: h['imageUrl'],
                  waktu: h['waktu'],
                  onEdit: () {
                    // TODO: edit hewan
                  },
                  onDelete: () {
                    // TODO: hapus hewan
                    setState(() => _hewanList.remove(h));
                  },
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
