import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../model/pesanan_item.dart';
import 'pesanan_timeline.dart';
import '../../pesanan/view/pesanan_pembayaran_view.dart';
import '../../adopsi/widgets/hewan_model.dart';
import '../../../../common/utils/app_navigator.dart';
import '../../../../common/widgets/app_net_image.dart';

class PesananSayaCard extends StatefulWidget {
  final PesananItem item;
  const PesananSayaCard({super.key, required this.item});

  @override
  State<PesananSayaCard> createState() => _PesananSayaCardState();
}

class _PesananSayaCardState extends State<PesananSayaCard> {
  int _activeSubTab = 0;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final item = widget.item;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header: nama shelter kiri, STATUS LABEL pojok kanan atas ──
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Kiri: nama shelter, invoice, tanggal
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.namaShelter,
                        style: textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        item.nomorInvoice,
                        style: textTheme.labelMedium?.copyWith(
                          color: const Color(0xFF9E9E9E),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        item.tanggal,
                        style: textTheme.labelMedium?.copyWith(
                          color: const Color(0xFF9E9E9E),
                        ),
                      ),
                    ],
                  ),
                ),

                // Kanan: label status — GANTI blob+logo jadi teks status
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    color: item.statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    item.statusLabel,
                    style: textTheme.labelMedium?.copyWith(
                      color: item.statusColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Garis tipis pemisah header
          Divider(height: 1, thickness: 1, color: const Color(0xFFF5F5F5)),

          // ── Body ──
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Box nomor order
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3EC),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: const Color(0xFFF87537).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.nomorOrder,
                        style: textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        item.infoOrder,
                        style: textTheme.labelMedium?.copyWith(
                          color: const Color(0xFF9E9E9E),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 14.h),

                // Info hewan + total biaya
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: SizedBox(
                        width: 52.w,
                        height: 52.h,
                        child: AppNetImage(
                          url: item.hewan.imageUrl,
                          fallbackColor: const Color(0xFFE0E0E0),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.hewan.namaHewan,
                            style: textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            item.hewan.subNama,
                            style: textTheme.labelMedium?.copyWith(
                              color: const Color(0xFF9E9E9E),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Total Biaya',
                          style: textTheme.labelMedium?.copyWith(
                            color: const Color(0xFF9E9E9E),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          item.hewan.totalBiaya,
                          style: textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFF87537),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // Toggle Status Form | Status Pembayaran
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  child: Row(
                    children: [
                      _SubTab(
                        label: 'Status Form',
                        isActive: _activeSubTab == 0,
                        onTap: () => setState(() => _activeSubTab = 0),
                      ),
                      _SubTab(
                        label: 'Status pembayaran',
                        isActive: _activeSubTab == 1,
                        onTap: () => setState(() => _activeSubTab = 1),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 14.h),

                // Konten tab
                if (_activeSubTab == 0)
                  _buildStatusForm(item, textTheme)
                else
                  _buildStatusPembayaran(textTheme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusForm(PesananItem item, TextTheme textTheme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(14.w, 16.h, 14.w, 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: PesananTimeline(
        steps: item.timeline,
        perkiraanKedatangan: item.perkiraanKedatangan,
      ),
    );
  }

  Widget _buildStatusPembayaran(TextTheme textTheme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Status Pembayaran',
              style: textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700, color: Colors.black)),
          SizedBox(height: 8.h),
          Text('Menunggu konfirmasi pembayaran...',
              style: textTheme.labelMedium?.copyWith(
                  color: const Color(0xFF9E9E9E))),
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => AppNavigator.push(
                context,
                PesananPembayaranView(
                  pesanan: widget.item,
                  hewan: widget.item.hewanModel ?? HewanModel(
                    name: widget.item.hewan.namaHewan,
                    shelter: widget.item.hewan.subNama,
                    priceRange: widget.item.hewan.totalBiaya,
                    rating: 5.0,
                    reviewCount: 0,
                    tags: [],
                    imageUrl: widget.item.hewan.imageUrl,
                    fallbackColorValue: 0xFFFFD8C0,
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.r)),
              ),
              child: Text('Lanjutkan Pembayaran',
                  style: textTheme.labelLarge?.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SubTab extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _SubTab({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 9.h),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(50.r),
            border: isActive
                ? Border.all(color: const Color(0xFFF87537), width: 1.2)
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: isActive
                  ? const Color(0xFFF87537)
                  : const Color(0xFF9E9E9E),
            ),
          ),
        ),
      ),
    );
  }
}
