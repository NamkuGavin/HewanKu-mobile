import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/hewan_upload_foto.dart';
import '../widgets/hewan_info_card.dart';
import '../widgets/hewan_tag_input.dart';

class TambahHewanView extends StatefulWidget {
  const TambahHewanView({super.key});

  @override
  State<TambahHewanView> createState() => _TambahHewanViewState();
}

class _TambahHewanViewState extends State<TambahHewanView> {
  final _namaController = TextEditingController();
  final _jenisRasController = TextEditingController();
  final _umurController = TextEditingController();
  final _hargaController = TextEditingController();
  final _deskripsiController = TextEditingController();

  String _selectedJenis = 'Anjing';
  int _selectedGender = 0; // 0=Jantan, 1=Betina
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

  void _publikasikan() {
    if (_namaController.text.isEmpty) {
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

    // Snackbar berhasil publikasi
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white, size: 18.sp),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                '${_namaController.text} berhasil dipublikasikan! 🐾',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
        duration: const Duration(seconds: 3),
      ),
    );

    // Kembali ke halaman sebelumnya
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 12.h),

                    // ── Header: back + label ──
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 20.sp,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    // Label kecil oranye
                    Text(
                      'PUSAT KURASI',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: primaryColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 6.h),

                    // Judul besar
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                          height: 1.2,
                        ),
                        children: [
                          const TextSpan(text: 'Daftarkan\nTeman\n'),
                          TextSpan(
                            text: 'Berbulu Baru',
                            style: TextStyle(color: primaryColor),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),

                    Text(
                      'Setiap detail berharga. Bantu calon keluarga jatuh cinta dengan menceritakan kisah indah melalui foto dan sifat kepribadian.',
                      style: textTheme.labelLarge?.copyWith(
                        color: const Color(0xFF757575),
                        height: 1.6,
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // ── Upload foto ──
                    HewanUploadFoto(onTap: () {}),
                    SizedBox(height: 24.h),

                    // ── Info Pratinjau Cepat ──
                    Text(
                      'Info Pratinjau Cepat',
                      style: textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    HewanInfoCard(
                      icon: Icons.schedule_outlined,
                      label: 'Estimasi Perawatan',
                      value: 'Perhatian Segera',
                      iconColor: primaryColor,
                      iconBgColor: const Color(0xFFFFF3EC),
                      onTap: () {},
                    ),
                    SizedBox(height: 8.h),
                    HewanInfoCard(
                      icon: Icons.health_and_safety_outlined,
                      label: 'Status Kesehatan',
                      value: 'Sudah Diperiksa Dokter',
                      iconColor: Colors.green,
                      iconBgColor: const Color(0xFFE8F5E9),
                      onTap: () {},
                    ),
                    SizedBox(height: 24.h),

                    // ── Field-field ──
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

                    // ── Toggle Jantan/Betina ──
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

            // ── Tombol bawah ──
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
              child: Column(
                children: [
                  // Publikasikan
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _publikasikan,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                      ),
                      icon: Icon(Icons.save_outlined, size: 18.sp),
                      label: Text(
                        'Publikasikan Profil',
                        style: textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  // Buang Draf
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
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
                        style: textTheme.labelLarge?.copyWith(
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

  // ── Helper widgets ──

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
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
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

// Toggle Jantan/Betina
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
