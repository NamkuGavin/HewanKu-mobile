import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../model/notifikasi_item.dart';

class NotifikasiItemCard extends StatelessWidget {
  final NotifikasiItem item;
  final bool isHighlighted;
  final VoidCallback? onMarkAsRead;
  final VoidCallback? onDelete;

  const NotifikasiItemCard({
    super.key,
    required this.item,
    this.isHighlighted = false,
    this.onMarkAsRead,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      // Long press → popup menu Mark as read & Delete
      onLongPress: () => _showPopupMenu(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        color: isHighlighted ? const Color(0xFFFFF3EC) : Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon / foto kiri
            _buildAvatar(),
            SizedBox(width: 14.w),

            // Teks kanan
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.judul,
                    style: textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    item.deskripsi,
                    style: textTheme.labelLarge?.copyWith(
                      color: const Color(0xFF757575),
                      height: 1.4,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    item.waktu,
                    style: textTheme.labelMedium?.copyWith(
                      color: const Color(0xFF9E9E9E),
                      fontWeight: FontWeight.w400,
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

  Widget _buildAvatar() {
    // Tipe App Update → icon hijau centang
    if (item.tipe == NotifikasiTipe.appUpdate) {
      return Container(
        width: 42.w,
        height: 42.h,
        decoration: const BoxDecoration(
          color: Color(0xFF4CAF50),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.check_circle, color: Colors.white, size: 24.sp),
      );
    }

    // Tipe Hasil Form → icon oranye dokumen
    if (item.tipe == NotifikasiTipe.hasilForm) {
      return Container(
        width: 42.w,
        height: 42.h,
        decoration: const BoxDecoration(
          color: Color(0xFFF87537),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.description_outlined,
          color: Colors.white,
          size: 22.sp,
        ),
      );
    }

    // Tipe Customer Alert → foto user atau icon default
    if (item.imageUrl != null) {
      return CircleAvatar(
        radius: 21.r,
        backgroundImage: NetworkImage(item.imageUrl!),
        backgroundColor: const Color(0xFFE0E0E0),
      );
    }

    // Default: icon person abu
    return CircleAvatar(
      radius: 21.r,
      backgroundColor: const Color(0xFFE0E0E0),
      child: Icon(Icons.person, color: Colors.white70, size: 22.sp),
    );
  }

  // Popup menu saat long press
  void _showPopupMenu(BuildContext context) async {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx + size.width - 160,
        offset.dy + size.height * 0.3,
        offset.dx + size.width,
        offset.dy + size.height,
      ),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      color: Colors.white,
      items: [
        PopupMenuItem(
          onTap: onMarkAsRead,
          child: Text(
            'Mark as read',
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        PopupMenuItem(
          onTap: onDelete,
          child: Text(
            'Delete',
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.red,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
