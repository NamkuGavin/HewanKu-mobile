import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdopsiFilterHewan extends StatefulWidget {
  const AdopsiFilterHewan({super.key});

  @override
  State<AdopsiFilterHewan> createState() => _AdopsiFilterHewanState();
}

class _AdopsiFilterHewanState extends State<AdopsiFilterHewan> {
  RangeValues _harga = const RangeValues(0, 9000000);
  String? _jenis = 'Kucing';

  static const _jenisHewan = [
    'Kucing', 'Anjing', 'Ikan', 'Burung', 'Kelinci', 'Hamster', 'Ular', 'Iguana', 'Kura - kura'];

  String _rupiah(double v) {
    final s = v.round().toString();
    final buf = StringBuffer();
    int c = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      if (c > 0 && c % 3 == 0) buf.write('.');
      buf.write(s[i]);
      c++;
    }
    return 'Rp${buf.toString().split('').reversed.join()}';
  }

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;
    const orange = Color(0xFFF87537);

    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, ctrl) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          children: [
            // Drag handle
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Container(
                width: 40.w, height: 4.h,
                decoration: BoxDecoration(
                  color: orange,
                  borderRadius: BorderRadius.circular(100.r),
                ),
              ),
            ),

            // Scrollable content
            Expanded(
              child: ListView(
                controller: ctrl,
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                physics: const BouncingScrollPhysics(),
                children: [
                  // ── Judul ──
                  Text('Filter Hewan', style: txt.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
                  SizedBox(height: 20.h),

                  // ── Harga ──
                  Text('Harga', style: txt.bodySmall?.copyWith(fontWeight: FontWeight.w700)),
                  SizedBox(height: 10.h),
                  Text('Telusuri berdasarkan Harga',
                      style: txt.labelLarge?.copyWith(color: const Color(0xFF888888))),
                  SizedBox(height: 4.h),

                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: orange,
                      inactiveTrackColor: const Color(0xFFE0E0E0),
                      thumbColor: orange,
                      overlayColor: const Color(0x29F87537),
                      trackHeight: 4.h,
                      rangeThumbShape: RoundRangeSliderThumbShape(enabledThumbRadius: 10.r),
                    ),
                    child: RangeSlider(
                      values: _harga,
                      min: 0,
                      max: 100000000,
                      divisions: 100,
                      onChanged: (v) => setState(() => _harga = v),
                    ),
                  ),

                  Center(
                    child: Text(
                      'Harga: ${_rupiah(_harga.start)} - ${_rupiah(_harga.end)}',
                      style: txt.labelLarge?.copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // ── Jenis Hewan ──
                  Text('Jenis Hewan', style: txt.bodySmall?.copyWith(fontWeight: FontWeight.w700)),
                  SizedBox(height: 4.h),

                  ..._jenisHewan.map((j) => Column(
                    children: [
                      InkWell(
                        onTap: () => setState(() => _jenis = j),
                        borderRadius: BorderRadius.circular(8.r),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          child: Row(
                            children: [
                              Expanded(child: Text(j, style: txt.labelLarge?.copyWith(color: const Color(0xFF333333)))),
                              Container(
                                width: 22.w, height: 22.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: _jenis == j ? orange : const Color(0xFFCCCCCC),
                                    width: _jenis == j ? 5.5 : 1.5,
                                  ),
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
                    ],
                  )),

                  SizedBox(height: 16.h),
                ],
              ),
            ),

            // ── Footer ──
            Container(
              padding: EdgeInsets.fromLTRB(24.w, 14.h, 24.w, 20.h),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, -4))],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => setState(() { _harga = const RangeValues(300000, 9000000); _jenis = null; }),
                      child: Text('Hapus', style: txt.labelLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop({'minPrice': _harga.start, 'maxPrice': _harga.end, 'jenis': _jenis}),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFDDDDDD), width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.r)),
                        minimumSize: Size(0, 45.h),
                      ),
                      child: Text('Apply', style: txt.labelLarge?.copyWith(color: const Color(0xFF333333), fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}