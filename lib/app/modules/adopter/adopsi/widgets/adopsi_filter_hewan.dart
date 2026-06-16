import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdopsiFilterResult {
  final String? jenis;
  final int hargaMin;
  final int hargaMax;
  final bool clear;

  const AdopsiFilterResult({required this.jenis, required this.hargaMin, required this.hargaMax, this.clear = false});

  const AdopsiFilterResult.clear() : jenis = null, hargaMin = -1, hargaMax = -1, clear = true;

  bool get hasJenis => jenis != null && jenis!.trim().isNotEmpty;
  bool get hasHarga => hargaMin >= 0 || hargaMax >= 0;
  bool get hasAnyFilter => hasJenis || hasHarga;
}

class AdopsiFilterHewan extends StatefulWidget {
  final List<String> categories;
  final String? initialJenis;
  final int initialHargaMin;
  final int initialHargaMax;

  const AdopsiFilterHewan({
    super.key,
    required this.categories,
    required this.initialJenis,
    required this.initialHargaMin,
    required this.initialHargaMax,
  });

  @override
  State<AdopsiFilterHewan> createState() => _AdopsiFilterHewanState();
}

class _AdopsiFilterHewanState extends State<AdopsiFilterHewan> {
  static const double _minSliderValue = 0;
  static const double _maxSliderValue = 100000000;

  late RangeValues _harga;
  String? _jenis;

  List<String> get _jenisHewan {
    if (widget.categories.isEmpty) {
      return const <String>[];
    }
    return widget.categories;
  }

  @override
  void initState() {
    super.initState();
    final hasInitialHarga = widget.initialHargaMin >= 0 || widget.initialHargaMax >= 0;
    _harga = hasInitialHarga
        ? RangeValues(widget.initialHargaMin.toDouble(), widget.initialHargaMax.toDouble())
        : const RangeValues(_minSliderValue, _maxSliderValue);
    _jenis = widget.initialJenis;
  }

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

  bool get _hasCustomHarga =>
      _harga.start.round() != _minSliderValue.round() || _harga.end.round() != _maxSliderValue.round();

  void _applyFilter() {
    Navigator.of(context).pop(
      AdopsiFilterResult(
        jenis: _jenis,
        hargaMin: _hasCustomHarga ? _harga.start.round() : -1,
        hargaMax: _hasCustomHarga ? _harga.end.round() : -1,
      ),
    );
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
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(color: orange, borderRadius: BorderRadius.circular(100.r)),
              ),
            ),
            Expanded(
              child: ListView(
                controller: ctrl,
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                physics: const BouncingScrollPhysics(),
                children: [
                  Text('Filter Hewan', style: txt.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
                  SizedBox(height: 20.h),
                  Text('Harga', style: txt.bodySmall?.copyWith(fontWeight: FontWeight.w700)),
                  SizedBox(height: 10.h),
                  Text('Telusuri berdasarkan Harga', style: txt.labelLarge?.copyWith(color: const Color(0xFF888888))),
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
                      min: _minSliderValue,
                      max: _maxSliderValue,
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
                  Text('Jenis Hewan', style: txt.bodySmall?.copyWith(fontWeight: FontWeight.w700)),
                  SizedBox(height: 4.h),
                  ..._jenisHewan.map(
                    (jenis) => Column(
                      children: [
                        InkWell(
                          onTap: () => setState(() => _jenis = _jenis == jenis ? null : jenis),
                          borderRadius: BorderRadius.circular(8.r),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(jenis, style: txt.labelLarge?.copyWith(color: const Color(0xFF333333))),
                                ),
                                Container(
                                  width: 22.w,
                                  height: 22.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: _jenis == jenis ? orange : const Color(0xFFCCCCCC),
                                      width: _jenis == jenis ? 5.5 : 1.5,
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
                    ),
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(24.w, 14.h, 24.w, 20.h),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, -4)),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(const AdopsiFilterResult.clear()),
                      child: Text(
                        'Hapus',
                        style: txt.labelLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _applyFilter,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFDDDDDD), width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.r)),
                        minimumSize: Size(0, 45.h),
                      ),
                      child: Text(
                        'Apply',
                        style: txt.labelLarge?.copyWith(color: const Color(0xFF333333), fontWeight: FontWeight.w700),
                      ),
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
