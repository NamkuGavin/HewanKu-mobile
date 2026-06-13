import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../common/utils/app_navigator.dart';
import '../../../../widgets/build_header_app.dart';
import '../widgets/hewan_model.dart';
import '../widgets/adopsi_form_widgets.dart';
import 'adopsi_form_pengalaman_view.dart';

/// Form A — Informasi Pribadi
class AdopsiFormIdentitasView extends StatefulWidget {
  final HewanModel hewan;

  const AdopsiFormIdentitasView({super.key, required this.hewan});

  @override
  State<AdopsiFormIdentitasView> createState() =>
      _AdopsiFormIdentitasViewState();
}

class _AdopsiFormIdentitasViewState extends State<AdopsiFormIdentitasView> {
  // ── Text field controllers ────────────────────────────────────────────────
  final _namaDepanCtrl = TextEditingController();
  final _namaBelakangCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _teleponCtrl = TextEditingController();
  final _tanggalLahirCtrl = TextEditingController();
  final _zipCodeCtrl = TextEditingController();

  // ── Dropdown selections ───────────────────────────────────────────────────
  String? _jenisKelamin;
  String? _daerah;
  String? _jalan;

  // ── Single-select checkboxes ───────────────────────────────────────────────
  String? _pekerjaan;
  String? _tempatTinggal;

  // ── Dropdown options ──────────────────────────────────────────────────────
  static const _opsiJenisKelamin = ['Pria', 'Wanita'];
  static const _opsiDaerah = [
    'Bandung',
    'Jakarta',
    'Surabaya',
    'Yogyakarta',
    'Medan',
    'Makassar',
  ];
  static const _opsiJalan = [
    'Telekomunikasi',
    'Jl. Sudirman',
    'Jl. Thamrin',
    'Jl. Gatot Subroto',
    'Jl. Asia Afrika',
  ];
  static const _opsiPekerjaan = [
    'Karyawan',
    'Pelajar / Mahasiswa',
    'Pengangguran',
    'Lainnya',
  ];
  static const _opsiTempatTinggal = ['Kos', 'Rumah', 'Kontrakan', 'Lainnya'];

  @override
  void dispose() {
    _namaDepanCtrl.dispose();
    _namaBelakangCtrl.dispose();
    _emailCtrl.dispose();
    _teleponCtrl.dispose();
    _tanggalLahirCtrl.dispose();
    _zipCodeCtrl.dispose();
    super.dispose();
  }

  // ── Validasi ──────────────────────────────────────────────────────────────
  bool _validate() {
    if (_namaDepanCtrl.text.trim().isEmpty) {
      _showError('Nama Depan wajib diisi');
      return false;
    }
    if (_namaBelakangCtrl.text.trim().isEmpty) {
      _showError('Nama Belakang wajib diisi');
      return false;
    }
    if (_emailCtrl.text.trim().isEmpty) {
      _showError('Email wajib diisi');
      return false;
    }
    if (_teleponCtrl.text.trim().isEmpty) {
      _showError('Nomor Telepon wajib diisi');
      return false;
    }
    if (_tanggalLahirCtrl.text.trim().isEmpty) {
      _showError('Tanggal Lahir wajib diisi');
      return false;
    }
    if (_jenisKelamin == null) {
      _showError('Jenis Kelamin wajib dipilih');
      return false;
    }
    if (_daerah == null) {
      _showError('Daerah wajib dipilih');
      return false;
    }
    if (_jalan == null) {
      _showError('Jalan wajib dipilih');
      return false;
    }
    if (_zipCodeCtrl.text.trim().isEmpty) {
      _showError('Zip Code wajib diisi');
      return false;
    }
    if (_pekerjaan == null) {
      _showError('Pekerjaan/Status wajib dipilih');
      return false;
    }
    if (_tempatTinggal == null) {
      _showError('Tempat Tinggal wajib dipilih');
      return false;
    }
    return true;
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: GoogleFonts.poppins(fontSize: 12.sp)),
        backgroundColor: const Color(0xFFF87537),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 90.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.r),
        ),
      ),
    );
  }

  void _onLanjutkan() {
    if (!_validate()) return;
    AppNavigator.push(
      context,
      AdopsiFormPengalamanView(
        hewan: widget.hewan,
        onCloseToDetail: () => AppNavigator.pop(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const BuildAppHeader(),
            FormSectionHeader(
              title: 'A. Informasi Pribadi',
              onClose: () => AppNavigator.pop(context),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FormTextField(
                      label: 'Nama Depan',
                      required: true,
                      controller: _namaDepanCtrl,
                    ),
                    SizedBox(height: 16.h),
                    FormTextField(
                      label: 'Nama Belakang',
                      required: true,
                      controller: _namaBelakangCtrl,
                    ),
                    SizedBox(height: 16.h),
                    FormTextField(
                      label: 'Email',
                      required: true,
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 16.h),
                    FormTextField(
                      label: 'Nomor Telepon',
                      required: true,
                      controller: _teleponCtrl,
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 16.h),
                    FormTextField(
                      label: 'Tanggal Lahir',
                      required: true,
                      controller: _tanggalLahirCtrl,
                      hint: 'DD/MM/YYYY',
                      keyboardType: TextInputType.datetime,
                    ),
                    SizedBox(height: 16.h),
                    FormDropdown(
                      label: 'Jenis Kelamin',
                      required: true,
                      value: _jenisKelamin,
                      items: _opsiJenisKelamin,
                      hint: 'Pilih jenis kelamin',
                      onChanged: (v) => setState(() => _jenisKelamin = v),
                    ),
                    SizedBox(height: 16.h),
                    FormDropdown(
                      label: 'Daerah',
                      required: true,
                      value: _daerah,
                      items: _opsiDaerah,
                      hint: 'Pilih daerah',
                      onChanged: (v) => setState(() => _daerah = v),
                    ),
                    SizedBox(height: 16.h),
                    FormDropdown(
                      label: 'Jalan',
                      required: true,
                      value: _jalan,
                      items: _opsiJalan,
                      hint: 'Pilih jalan',
                      onChanged: (v) => setState(() => _jalan = v),
                    ),
                    SizedBox(height: 16.h),
                    FormTextField(
                      label: 'Zip Code',
                      required: true,
                      controller: _zipCodeCtrl,
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 20.h),
                    FormCheckboxGroup(
                      label: 'Pekerjaan/Status',
                      required: true,
                      options: _opsiPekerjaan,
                      selected: _pekerjaan,
                      onToggle: (opt) => setState(() {
                        _pekerjaan = opt;
                      }),
                    ),
                    SizedBox(height: 20.h),
                    FormCheckboxGroup(
                      label: 'Tempat Tinggal',
                      required: true,
                      options: _opsiTempatTinggal,
                      selected: _tempatTinggal,
                      onToggle: (opt) => setState(() {
                        _tempatTinggal = opt;
                      }),
                    ),
                    SizedBox(height: 8.h),
                  ],
                ),
              ),
            ),
            FormBottomButtons(
              actionLabel: 'Lanjutkan',
              onKembali: () => AppNavigator.pop(context),
              onAction: _onLanjutkan,
            ),
          ],
        ),
      ),
    );
  }
}
