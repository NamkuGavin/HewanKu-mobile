import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../model/notifikasi_item.dart';
import '../widgets/notifikasi_item_card.dart';
import '../widgets/notifikasi_empty_state.dart';

class NotifikasiView extends StatefulWidget {
  const NotifikasiView({super.key});

  @override
  State<NotifikasiView> createState() => _NotifikasiViewState();
}

class _NotifikasiViewState extends State<NotifikasiView> {
  // StatefulWidget karena list bisa berubah (delete / mark as read)
  // Ganti dengan data dari API nanti
  // Untuk test empty state: ubah jadi list kosong []
  List<NotifikasiItem> _notifList = [
    const NotifikasiItem(
      judul: 'App Update',
      deskripsi: 'New update out now! Discover improved productivity tools and more.',
      waktu: '2 days ago',
      tipe: NotifikasiTipe.appUpdate,
      isRead: true,
    ),
    const NotifikasiItem(
      judul: 'Hasil Form',
      deskripsi: 'Get subcription premium now at 40% off for more productivity tools and more.',
      waktu: '2 days ago',
      tipe: NotifikasiTipe.hasilForm,
      isRead: false, // ← unread = highlighted oranye muda
    ),
    const NotifikasiItem(
      judul: 'New Customer allert',
      deskripsi: 'lucky for you, you have a new customer waiting for your service...',
      waktu: 'now',
      tipe: NotifikasiTipe.customerAlert,
      isRead: true,
    ),
    const NotifikasiItem(
      judul: 'New Customer allert',
      deskripsi: 'lucky for you, you have a new customer waiting for your service...',
      waktu: 'now',
      tipe: NotifikasiTipe.customerAlert,
      imageUrl: 'https://images.unsplash.com/photo-1535268647677-300dbf3d78d1?w=100',
      isRead: true,
    ),
    const NotifikasiItem(
      judul: 'New Customer allert',
      deskripsi: 'lucky for you, you have a new customer waiting for your service...',
      waktu: 'now',
      tipe: NotifikasiTipe.customerAlert,
      isRead: true,
    ),
    const NotifikasiItem(
      judul: 'New Customer allert',
      deskripsi: 'lucky for you, you have a new customer waiting for your service...',
      waktu: 'now',
      tipe: NotifikasiTipe.customerAlert,
      imageUrl: 'https://images.unsplash.com/photo-1543466835-00a7907e9de1?w=100',
      isRead: true,
    ),
    const NotifikasiItem(
      judul: 'New Customer allert',
      deskripsi: 'lucky for you, you have a new customer waiting for your service...',
      waktu: 'now',
      tipe: NotifikasiTipe.customerAlert,
      isRead: true,
    ),
  ];

  // Tandai sebagai sudah dibaca
  void _markAsRead(int index) {
    setState(() {
      _notifList[index] = _notifList[index].copyWith(isRead: true);
    });
  }

  // Hapus notifikasi
  void _delete(int index) {
    setState(() {
      _notifList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).primaryColor;
    final isEmpty = _notifList.isEmpty;

    return Scaffold(
      backgroundColor: isEmpty ? const Color(0xFFF5F5F5) : Colors.white,
      appBar: AppBar(
        backgroundColor: isEmpty ? const Color(0xFFF5F5F5) : Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: primaryColor,
            size: 20.sp,
          ),
        ),
        title: Text(
          'Notifikasi',
          style: textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),

      body: isEmpty
          ? const NotifikasiEmptyState()
          : ListView.separated(
              itemCount: _notifList.length,
              separatorBuilder: (_, __) => const Divider(
                height: 1,
                thickness: 1,
                color: Color(0xFFF0F0F0),
              ),
              itemBuilder: (context, index) {
                final item = _notifList[index];
                return NotifikasiItemCard(
                  item: item,
                  // Highlighted kalau belum dibaca (isRead = false)
                  isHighlighted: !item.isRead,
                  onMarkAsRead: () => _markAsRead(index),
                  onDelete: () => _delete(index),
                );
              },
            ),
    );
  }
}