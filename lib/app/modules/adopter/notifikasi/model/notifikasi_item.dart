enum NotifikasiTipe { appUpdate, hasilForm, customerAlert }

class NotifikasiItem {
  final String judul;
  final String deskripsi;
  final String waktu;
  final NotifikasiTipe tipe;
  final String? imageUrl;
  final bool isRead;

  const NotifikasiItem({
    required this.judul,
    required this.deskripsi,
    required this.waktu,
    required this.tipe,
    this.imageUrl,
    this.isRead = true,
  });

  NotifikasiItem copyWith({bool? isRead}) => NotifikasiItem(
    judul: judul,
    deskripsi: deskripsi,
    waktu: waktu,
    tipe: tipe,
    imageUrl: imageUrl,
    isRead: isRead ?? this.isRead,
  );
}
