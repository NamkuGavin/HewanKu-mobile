import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import 'home_news_list_item.dart';

class HomeNewsSection extends StatelessWidget {
  const HomeNewsSection({super.key});

  static const Map<String, String> _beritaUtama = {
    'imageUrl':
        'https://images.alodokter.com/dk0z4ums3/image/upload/v1778544180/attached_image/anjing-golden-retriever-ini-keunikan-risiko-kesehatan-dan-cara-merawatnya-0-alodokter.jpg',
    'kategori': 'Anjing',
    'judul':
        'Anjing Golden Retriever: Keunikan, Risiko Kesehatan, dan Cara Merawatnya',
    'isi':
        'Golden Retriever dikenal sebagai anjing yang cerdas, ramah, dan mudah dilatih. Ketahui lebih lanjut tentang keunikan, potensi risiko kesehatan, serta cara merawatnya dengan baik agar tetap sehat dan bahagia.',
    'tanggal': '12 Mei 2026',
    'url':
        'https://www.alodokter.com/anjing-golden-retriever-ini-keunikan-risiko-kesehatan-dan-cara-merawatnya',
  };

  static const List<Map<String, String>> _beritaList = [
    {
      'imageUrl':
          'https://www.whiskasindonesia.com/cdn-cgi/image/height=617,f=auto,quality=90/sites/g/files/fnmzdf8246/files/2026-01/Kucing%20Anggora_v2_0_0.jpg',
      'kategori': 'Kucing',
      'judul': 'Kucing Anggora: Ciri Khas, Sifat, dan Tips Perawatan Bulunya',
      'tanggal': '',
      'url':
          'https://www.whiskasindonesia.com/jenis-jenis-kucing/kucing-anggora',
    },
    {
      'imageUrl':
          'https://tamansafari.com/taman-safari-bali/wp-content/uploads/2023/05/1625735970-makanan-kelinci-yang-sehat-banner.jpg',
      'kategori': 'Kelinci',
      'judul': 'Keunikan Kelinci: Sahabat Setia Manusia yang Menggemaskan',
      'tanggal': '',
      'url':
          'https://tamansafari.com/taman-safari-bali/keunikan-kelinci-sahabat-setia-manusia/',
    },
    {
      'imageUrl':
          'https://cdn.mos.cms.futurecdn.net/BacHx6LRGKbm2b7CVKxV7f-970-80.jpg.webp',
      'kategori': 'Hewan Kecil',
      'judul':
          'Fakta Menarik Guinea Pig yang Wajib Diketahui Sebelum Memelihara',
      'tanggal': '26 Agustus 2025',
      'url':
          'https://www.petsradar.com/small-pets/guinea-pigs/facts-about-guinea-pigs',
    },
    {
      'imageUrl':
          'https://cdn.mos.cms.futurecdn.net/3EKYqca75TBZpGuiGi3dSn-970-80.png.webp',
      'kategori': 'Reptil',
      'judul': 'Rekomendasi Reptil Peliharaan Terbaik untuk Pemula',
      'tanggal': '21 Oktober 2024',
      'url': 'https://www.petsradar.com/advice/best-pet-reptiles',
    },
  ];

  Future<void> _bukaArtikel(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).primaryColor;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Berita Terkini',
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 14.h),

          // ── Berita UTAMA ──
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
              onTap: () => _bukaArtikel(_beritaUtama['url']!),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    _beritaUtama['imageUrl']!,
                    width: double.infinity,
                    height: 190.h,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      height: 190.h,
                      color: const Color(0xFFE0E0E0),
                      child: const Icon(Icons.image, color: Colors.white54),
                    ),
                  ),
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

          // ── List berita kecil ──
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _beritaList.length,
            separatorBuilder: (_, _) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              final item = _beritaList[index];
              return HomeNewsListItem(
                imageUrl: item['imageUrl']!,
                kategori: item['kategori']!,
                judul: item['judul']!,
                tanggal: item['tanggal']!,
                onTap: () => _bukaArtikel(item['url']!),
              );
            },
          ),
        ],
      ),
    );
  }
}
