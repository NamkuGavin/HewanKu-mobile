import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'home_news_list_item.dart';

class HomeNewsSection extends StatelessWidget {
  const HomeNewsSection({super.key});

  static const Map<String, String> _beritaUtama = {
    'imageUrl': 'https://images.unsplash.com/photo-1543466835-00a7907e9de1?w=600',
    'kategori': 'Kucing & Anjing',
    'judul': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
    'isi': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
    'tanggal': 'Senin, 12 Agustus 2022',
  };

  static const List<Map<String, String>> _beritaList = [
    {
      'imageUrl': 'https://images.unsplash.com/photo-1444212477490-ca407925329e?w=200',
      'kategori': 'Kucing & Anjing',
      'judul': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, se...',
      'tanggal': 'Senin, 12 Agustus 2022',
    },
    {
      'imageUrl': 'https://images.unsplash.com/photo-1534361960057-19f4434a4f9a?w=200',
      'kategori': 'Kucing & Anjing',
      'judul': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, se...',
      'tanggal': 'Senin, 12 Agustus 2022',
    },
    {
      'imageUrl': 'https://images.unsplash.com/photo-1474511320723-9a56873867b5?w=200',
      'kategori': 'Kucing & Anjing',
      'judul': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, se...',
      'tanggal': 'Senin, 12 Agustus 2022',
    },
    {
      'imageUrl': 'https://images.unsplash.com/photo-1564349683136-77e08dba1ef7?w=200',
      'kategori': 'Kucing & Anjing',
      'judul': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, se...',
      'tanggal': 'Senin, 12 Agustus 2022',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).primaryColor;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul section
          Text(
            'Berita Terkini',
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 14.h),

          // ── Berita UTAMA dibungkus Card ──
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.07),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            clipBehavior: Clip.hardEdge,
            child: GestureDetector(
              onTap: () {
                // TODO: navigasi ke detail berita
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Foto lebar atas
                  Image.network(
                    _beritaUtama['imageUrl']!,
                    width: double.infinity,
                    height: 190.h,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 190.h,
                      color: const Color(0xFFE0E0E0),
                      child: const Icon(Icons.image, color: Colors.white54),
                    ),
                  ),

                  // Teks di dalam card
                  Padding(
                    padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _beritaUtama['kategori']!,
                          style: textTheme.labelMedium?.copyWith(
                            color: const Color(0xFF9E9E9E),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          _beritaUtama['judul']!,
                          style: textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            height: 1.4,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          _beritaUtama['tanggal']!,
                          style: textTheme.labelMedium?.copyWith(
                            color: const Color(0xFF9E9E9E),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        // Garis oranye pembatas di dalam card
                        Divider(color: primaryColor, thickness: 1.5),
                        SizedBox(height: 8.h),
                        Text(
                          _beritaUtama['isi']!,
                          style: textTheme.labelLarge?.copyWith(
                            color: const Color(0xFF757575),
                            height: 1.6,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),

          // ── List berita kecil — masing-masing card ──
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _beritaList.length,
            separatorBuilder: (_, __) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              final item = _beritaList[index];
              return HomeNewsListItem(
                imageUrl: item['imageUrl']!,
                kategori: item['kategori']!,
                judul: item['judul']!,
                tanggal: item['tanggal']!,
                onTap: () {
                  // TODO: navigasi ke detail berita
                },
              );
            },
          ),
        ],
      ),
    );
  }
}