import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/utils/app_navigator.dart';
import '../../../../common/widgets/app_net_image.dart';
import '../../../../models/order/adopter_order_history_model.dart';
import '../view/pesanan_progress_detail_view.dart';

class PesananSayaCard extends StatelessWidget {
  final AdopterOrderHistoryModel item;

  const PesananSayaCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final hewan = item.hewanModel;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      hewan.name,
                      style: textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      item.shelterLabel,
                      style: textTheme.labelMedium?.copyWith(
                        color: const Color(0xFF8C8C8C),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: item.processStatusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Text(
                  item.processStatusLabel,
                  style: textTheme.labelMedium?.copyWith(
                    color: item.processStatusColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: SizedBox(
                  width: 64.w,
                  height: 64.h,
                  child: AppNetImage(
                    url: hewan.imageUrl,
                    fallbackColor: Color(hewan.fallbackColorValue),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _InfoPair(label: 'ID Order', value: item.orderCodeLabel),
                    SizedBox(height: 8.h),
                    _InfoPair(label: 'Tanggal', value: item.orderDateLabel),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8F3),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: const Color(0xFFF8D7C5)),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: _InfoPair(
                    label: 'Total',
                    value: item.totalBiayaLabel,
                    valueColor: const Color(0xFFF87537),
                  ),
                ),
                SizedBox(width: 12.w),
                SizedBox(
                  height: 40.h,
                  child: ElevatedButton(
                    onPressed: () {
                      AppNavigator.push(
                        context,
                        PesananProgressDetailView(
                          orderId: item.id,
                          initialOrder: item,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF87537),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 18.w,
                        vertical: 10.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Lihat Progress',
                      style: textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoPair extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoPair({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: textTheme.labelMedium?.copyWith(
            color: const Color(0xFF9E9E9E),
          ),
        ),
        SizedBox(height: 3.h),
        Text(
          value,
          style: textTheme.labelLarge?.copyWith(
            color: valueColor ?? Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
