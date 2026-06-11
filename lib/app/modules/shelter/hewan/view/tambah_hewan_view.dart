import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/hewan_upload_foto.dart';
import '../widgets/hewan_tag_input.dart';

// ============================================================
// LETAKNYA DI:
// lib/app/modules/shelter/hewan/view/tambah_hewan_view.dart
// ============================================================

class TambahHewanView extends StatefulWidget {
  final String? namaAwal;
  final String? hargaAwal;

  const TambahHewanView({super.key, this.namaAwal, this.hargaAwal});

  @override
  State<TambahHewanView> createState() => _TambahHewanViewState();
}

class _TambahHewanViewState extends State<TambahHewanView> {
  late final TextEditingController _namaController;
  final _jenisRasController = TextEditingController();
  final _umurController = TextEditingController();
  late final TextEditingController _hargaController;
  final _deskripsiController = TextEditingController();

  // ── initState: isi controller dari namaAwal jika ada (mode edit) ──
  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.namaAwal ?? '');
    _hargaController = TextEditingController(text: widget.hargaAwal ?? '');
  }

  String _selectedJenis = 'Anjing';
  int _selectedGender = 0; // 0 = Jantan, 1 = Betina
  List<String> _tags = ['Energik', 'Tenang', 'Ramah Anak'];
  final List<String> _jenisHewan = [
    'Anjing',
    'Kucing',
    'Kelinci',
    'Hamster',
    'Burung',
    'Ikan',
    'Lainnya',
  ];

  @override
  void dispose() {
    _namaController.dispose();
    _jenisRasController.dispose();
    _umurController.dispose();
    _hargaController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  // ── Publikasi hewan ───────────────────────────────────────
  void _publikasikan() {
    if (_namaController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.white,
                size: 18.sp,
              ),
              SizedBox(width: 8.w),
              const Text(
                'Nama hewan wajib diisi!',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
        ),
      );
      return;
    }

    // Tampilkan dialog sukses, lalu return data ke hewan_view
    _showDialogSukses();
  }

  // ── Data hewan hasil form, dikembalikan ke hewan_view ────
  Map<String, dynamic> _buildHewanData() {
    // Map status warna berdasarkan harga
    final harga = _hargaController.text.trim();
    return {
      'name': _namaController.text.trim(),
      'price': harga.isEmpty ? 'Rp 0 (Adopsi)' : harga,
      'status': 'AKTIF',
      'statusColor': Colors.green,
      'imageUrl': '', // kosong dulu, nanti connect ke API
      'waktu': 'Baru saja',
      'jenis': _selectedJenis,
      'jenisRas': _jenisRasController.text.trim(),
      'umur': _umurController.text.trim(),
      'deskripsi': _deskripsiController.text.trim(),
      'kelamin': _selectedGender == 0 ? 'Jantan' : 'Betina',
      'tags': List<String>.from(_tags),
    };
  }

  // ── Dialog sukses ─────────────────────────────────────────
  void _showDialogSukses() {
    final isEdit = widget.namaAwal != null;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(28.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon centang
              Container(
                width: 72.w,
                height: 72.w,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF3EE),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_rounded,
                  color: const Color(0xFFF87537),
                  size: 42.sp,
                ),
              ),
              SizedBox(height: 16.h),

              Text(
                isEdit ? 'Berhasil Diperbarui!' : 'Berhasil Dipublikasi!',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),

              Text(
                isEdit
                    ? 'Data ${_namaController.text} telah berhasil diperbarui.'
                    : 'Profil ${_namaController.text} telah berhasil ditambahkan dan siap diadopsi.',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13.sp,
                  color: const Color(0xFF9E9E9E),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),

              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: () {
                    // ✅ FIX: pop dialog dulu, lalu pop view dengan membawa DATA hewan
                    Navigator.of(context).pop(); // tutup dialog
                    Navigator.of(
                      context,
                    ).pop(_buildHewanData()); // ← kirim data ke hewan_view
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF87537),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                  ),
                  child: Text(
                    'Lihat Daftar Hewan',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Konfirmasi buang draf ─────────────────────────────────
  void _buangDraf() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'Buang Draf?',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            fontSize: 16.sp,
            color: Colors.black,
          ),
        ),
        content: Text(
          'Semua data yang sudah diisi akan hilang. Yakin ingin membatalkan?',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13.sp,
            color: const Color(0xFF9E9E9E),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: const Color(0xFF9E9E9E),
                fontSize: 13.sp,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // tutup dialog
              Navigator.pop(context); // kembali ke list
            },
            child: Text(
              'Ya, Buang',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.red,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // BUILD UTAMA
  // ═══════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).primaryColor;
    final isEdit = widget.namaAwal != null;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Scrollable content ──
            Expanded(
              child: SingleChildScrollView(
                // ✅ FIX: padding kiri-kanan seimbang, cukup ruang untuk teks
                padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 14.h),

                    // Back button
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 20.sp,
                        color: primaryColor,
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Label kecil oranye
                    Text(
                      isEdit ? 'EDIT HEWAN' : 'PUSAT KURASI',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: primaryColor,
                        letterSpacing: 1.5,
                      ),
                    ),
                    SizedBox(height: 8.h),

                    // ✅ FIX: Judul 2 baris — "Daftarkan Teman" + "Berbulu Baru"
                    Text(
                      'Daftarkan Teman',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                        height: 1.15,
                      ),
                    ),
                    Text(
                      'Berbulu Baru',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w800,
                        color: primaryColor,
                        height: 1.15,
                      ),
                    ),
                    SizedBox(height: 14.h),

                    // ✅ FIX: Subtitle lebih rapi, beri maxWidth penuh
                    Text(
                      'Setiap detail berharga. Bantu calon keluarga jatuh cinta dengan '
                      'menceritakan kisah indah melalui foto dan sifat kepribadian.',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13.sp,
                        color: const Color(0xFF757575),
                        height: 1.6,
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // ── Upload Foto ──
                    HewanUploadFoto(onTap: () {}),
                    SizedBox(height: 24.h),

                    // ── Form Fields ──
                    _buildLabel('Nama Panggilan Hewan'),
                    SizedBox(height: 8.h),
                    _buildTextField(_namaController, 'mis. Luna si Pemberani'),
                    SizedBox(height: 16.h),

                    _buildLabel('Kategori Hewan'),
                    SizedBox(height: 8.h),
                    _buildDropdown(),
                    SizedBox(height: 16.h),

                    _buildLabel('Jenis Hewan'),
                    SizedBox(height: 8.h),
                    _buildTextField(
                      _jenisRasController,
                      'mis. Golden Retriever',
                    ),
                    SizedBox(height: 16.h),

                    _buildLabel('Umur Hewan'),
                    SizedBox(height: 8.h),
                    _buildTextField(_umurController, 'mis. 2 Tahun'),
                    SizedBox(height: 16.h),

                    _buildLabel('Harga Hewan'),
                    SizedBox(height: 8.h),
                    _buildTextField(
                      _hargaController,
                      'mis. Rp700.000',
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 16.h),

                    _buildLabel('Deskripsi'),
                    SizedBox(height: 8.h),
                    _buildTextField(
                      _deskripsiController,
                      'Gambarkan kepribadian, keunikan, dan rumah sempurna yang mereka cari...',
                      maxLines: 4,
                    ),
                    SizedBox(height: 20.h),

                    // ── Toggle Jantan / Betina ──
                    _buildLabel('Jenis Kelamin'),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        _GenderBtn(
                          label: 'Jantan',
                          isActive: _selectedGender == 0,
                          onTap: () => setState(() => _selectedGender = 0),
                        ),
                        SizedBox(width: 12.w),
                        _GenderBtn(
                          label: 'Betina',
                          isActive: _selectedGender == 1,
                          onTap: () => setState(() => _selectedGender = 1),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    // ── Tags ──
                    _buildLabel('Kepribadian'),
                    SizedBox(height: 10.h),
                    HewanTagInput(
                      tags: _tags,
                      onChanged: (v) => setState(() => _tags = v),
                    ),
                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ),

            // ── Tombol Aksi (fixed di bawah) ──
            Container(
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0D000000),
                    blurRadius: 8,
                    offset: Offset(0, -3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Tombol Publikasi
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _publikasikan,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                      ),
                      icon: Icon(Icons.save_outlined, size: 18.sp),
                      label: Text(
                        isEdit ? 'Simpan Perubahan' : 'Publikasikan Profil',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),

                  // Tombol Buang Draf
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _buangDraf,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        side: const BorderSide(color: Color(0xFFE0E0E0)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                      ),
                      child: Text(
                        'Buang Draf',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
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

  // ── Helpers ───────────────────────────────────────────────
  Widget _buildLabel(String label) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: Theme.of(
        context,
      ).textTheme.labelLarge?.copyWith(color: Colors.black87),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: Theme.of(
          context,
        ).textTheme.labelLarge?.copyWith(color: const Color(0xFF9E9E9E)),
        filled: true,
        fillColor: const Color(0xFFF8F8F8),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedJenis,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: const Color(0xFF9E9E9E),
            size: 20.sp,
          ),
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(color: Colors.black87),
          onChanged: (v) => setState(() => _selectedJenis = v!),
          items: _jenisHewan
              .map((j) => DropdownMenuItem(value: j, child: Text(j)))
              .toList(),
        ),
      ),
    );
  }
}

// ── Widget Toggle Jantan/Betina ───────────────────────────────────────────────
class _GenderBtn extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _GenderBtn({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFF87537) : Colors.white,
            borderRadius: BorderRadius.circular(50.r),
            border: Border.all(
              color: isActive
                  ? const Color(0xFFF87537)
                  : const Color(0xFFE0E0E0),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: isActive ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
