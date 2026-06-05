import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../model/pesanan_item.dart';
import '../model/pesanan_provider.dart';
import '../model/pesanan_terakhir_item.dart';
import '../widgets/pesanan_tab_switcher.dart';
import '../widgets/pesanan_saya_card.dart';
import '../widgets/pesanan_terakhir_card.dart';
import '../widgets/pesanan_empty_state.dart';
import '../widgets/rating_dan_ulasan_dialog.dart';

class PesananView extends StatefulWidget {
  const PesananView({super.key});

  @override
  State<PesananView> createState() => _PesananViewState();
}

class _PesananViewState extends State<PesananView> {
  int _selectedTab = 0;

  // ── Data dummy Pesanan Terakhir (tetap statis) ────────────────────────────
  static final List<PesananTerakhirItem> _pesananTerakhir = [
    PesananTerakhirItem(
      namaShelter: 'Shelter Hewan Abadi',
      nomorInvoice: 'INV-2024-101',
      tanggal: 'Senin, 01 Februari 2026',
      statusLabel: 'Berhasil',
      totalBiaya: 'Rp 3.000.000',
      detailAdopsi: const [
        DetailAdopsiRow(
          imageUrl:
              'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=100',
          namaHewan: 'Kucing',
          subNama: 'Kucing Siamese',
          kesehatan: 'Sudah Vaksin',
          kuantitas: '2x',
          harga: 'Rp 1.500.000',
        ),
      ],
    ),
    PesananTerakhirItem(
      namaShelter: 'Shelter Hewan Abadi',
      nomorInvoice: 'INV-2024-100',
      tanggal: 'Senin, 01 Februari 2026',
      statusLabel: 'Berhasil',
      totalBiaya: 'Rp 2.000.000',
      detailAdopsi: const [
        DetailAdopsiRow(
          imageUrl:
              'https://images.unsplash.com/photo-1585110396000-c9ffd4e4b308?w=100',
          namaHewan: 'Kelinci',
          subNama: 'Kelinci putih',
          kesehatan: 'Sudah Vaksin',
          kuantitas: '1x',
          harga: 'Rp 1.000.000',
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ValueListenableBuilder<List<PesananItem>>(
      valueListenable: PesananProvider.of(context),
      builder: (context, pesananBaru, _) {
        final allPesananSaya = pesananBaru; // item baru dari form adopsi
        final isEmpty = _selectedTab == 0
            ? allPesananSaya.isEmpty
            : _pesananTerakhir.isEmpty;

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 10.h),
                  child: Center(
                    child: Text(
                      'Pesanan',
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

                // Tab switcher
                PesananTabSwitcher(
                  selectedIndex: _selectedTab,
                  onTabChanged: (i) => setState(() => _selectedTab = i),
                ),
                SizedBox(height: 20.h),

                // Konten
                Expanded(
                  child: isEmpty
                      ? const PesananEmptyState()
                      : _selectedTab == 0
                          // ── Tab Pesanan Saya ──
                          ? ListView.separated(
                              padding: EdgeInsets.only(bottom: 28.h),
                              itemCount: allPesananSaya.length,
                              separatorBuilder: (_, _) =>
                                  SizedBox(height: 20.h),
                              itemBuilder: (context, index) =>
                                  PesananSayaCard(item: allPesananSaya[index]),
                            )
                          // ── Tab Pesanan Terakhir ──
                          : ListView.separated(
                              padding: EdgeInsets.only(bottom: 28.h),
                              itemCount: _pesananTerakhir.length,
                              separatorBuilder: (_, _) =>
                                  SizedBox(height: 20.h),
                              itemBuilder: (context, index) =>
                                  PesananTerakhirCard(
                                item: _pesananTerakhir[index],
                                onRatingTap: () {
                                  RatingUlasanDialog.show(
                                    context,
                                    namaShelter:
                                        _pesananTerakhir[index].namaShelter,
                                  );
                                },
                              ),
                            ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}