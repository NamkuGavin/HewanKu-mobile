import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_net_image.dart';

class AdopsiFeaturedSection extends StatelessWidget {
  const AdopsiFeaturedSection({super.key});

  static const List<_HewanData> _items = [
    _HewanData(
      name: 'Kucing Anggora',
      price: 'Rp 2.000.000',
      url:
          'https://images.unsplash.com/photo-1545249390-6bdfa286032f?w=400&q=80',
      fallback: Color(0xFFE8DDD0),
    ),
    _HewanData(
      name: 'British Short Hair',
      price: 'Rp 2.000.000',
      url:
          'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=400&q=80',
      fallback: Color(0xFF8A9BAB),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rekomendasi',
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          SizedBox(height: 14.h),
          Row(
            children: _items
                .map((item) => Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: item == _items.first ? 8.w : 0,
                          left: item == _items.last ? 8.w : 0,
                        ),
                        child: _FeaturedCard(data: item),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _HewanData {
  final String name;
  final String price;
  final String url;
  final Color fallback;

  const _HewanData({
    required this.name,
    required this.price,
    required this.url,
    required this.fallback,
  });
}

class _FeaturedCard extends StatelessWidget {
  final _HewanData data;
  const _FeaturedCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
            ),
            child: SizedBox(
              height: 145.h,
              width: double.infinity,
              child: AppNetImage(url: data.url, fallbackColor: data.fallback),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 3.h),
            child: Text(
              data.name,
              style: GoogleFonts.poppins(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A1A),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 12.h),
            child: Text(
              data.price,
              style: GoogleFonts.poppins(
                fontSize: 11.sp,
                color: const Color(0xFFAAAAAA),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}