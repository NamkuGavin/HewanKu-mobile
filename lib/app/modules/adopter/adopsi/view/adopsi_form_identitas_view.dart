import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/utils/app_navigator.dart';
import '../../../../common/utils/form_validator.dart';
import '../../../../common/widgets/app_snackbar.dart';
import '../../../../models/order/adopter_order_personal_info_model.dart';
import '../../../../widgets/build_header_app.dart';
import '../widgets/adopsi_form_widgets.dart';
import '../widgets/hewan_model.dart';
import 'adopsi_form_pengalaman_view.dart';

class AdopsiFormIdentitasView extends StatefulWidget {
  final HewanModel hewan;

  const AdopsiFormIdentitasView({super.key, required this.hewan});

  @override
  State<AdopsiFormIdentitasView> createState() =>
      _AdopsiFormIdentitasViewState();
}

class _AdopsiFormIdentitasViewState extends State<AdopsiFormIdentitasView> {
  final _namaDepanCtrl = TextEditingController();
  final _namaBelakangCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _teleponCtrl = TextEditingController();
  final _tanggalLahirCtrl = TextEditingController();
  final _zipCodeCtrl = TextEditingController();

  String? _jenisKelamin;
  String? _daerah;
  String? _jalan;
  String? _pekerjaan;
  String? _tempatTinggal;

  static const _opsiJenisKelamin = ['Laki-laki', 'Perempuan'];
  static const _opsiDaerah = [
    'Bandung',
    'Jakarta',
    'Surabaya',
    'Yogyakarta',
    'Medan',
    'Makassar',
  ];
  static const _opsiJalan = [
    'Jl. Telekomunikasi No. 1',
    'Jl. Jenderal Sudirman',
    'Jl. M.H. Thamrin',
    'Jl. Gatot Subroto',
    'Jl. Asia Afrika',
  ];
  static const _opsiPekerjaan = [
    'Karyawan',
    'Mahasiswa',
    'Pengangguran',
    'Lainnya',
  ];
  static const _opsiTempatTinggal = [
    'Kos',
    'Rumah Pribadi',
    'Kontrakan',
    'Lainnya',
  ];

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

  void _showWarning(String message) {
    AppSnackbar.show(context, message: message, type: AppSnackbarType.warning);
  }

  DateTime? _parseDate(String raw) {
    final value = raw.trim();
    if (value.isEmpty) {
      return null;
    }

    final isoParsed = DateTime.tryParse(value);
    if (isoParsed != null) {
      return DateTime(isoParsed.year, isoParsed.month, isoParsed.day);
    }

    final slashMatch = RegExp(r'^(\d{2})\/(\d{2})\/(\d{4})$').firstMatch(value);
    if (slashMatch == null) {
      return null;
    }

    final day = int.tryParse(slashMatch.group(1)!);
    final month = int.tryParse(slashMatch.group(2)!);
    final year = int.tryParse(slashMatch.group(3)!);
    if (day == null || month == null || year == null) {
      return null;
    }

    final parsed = DateTime(year, month, day);
    if (parsed.year != year || parsed.month != month || parsed.day != day) {
      return null;
    }

    return parsed;
  }

  AdopterOrderPersonalInfoModel? _buildPersonalInfo() {
    final firstName = _namaDepanCtrl.text.trim();
    final lastName = _namaBelakangCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final phone = _teleponCtrl.text.trim();
    final birthDateRaw = _tanggalLahirCtrl.text.trim();
    final zipCode = _zipCodeCtrl.text.trim();

    final nameError = FormValidator.name(firstName, fieldName: 'Nama depan');
    if (nameError != null) {
      _showWarning(nameError);
      return null;
    }

    final lastNameError = FormValidator.name(
      lastName,
      fieldName: 'Nama belakang',
    );
    if (lastNameError != null) {
      _showWarning(lastNameError);
      return null;
    }

    final emailError = FormValidator.email(email);
    if (emailError != null) {
      _showWarning(emailError);
      return null;
    }

    final phoneError = FormValidator.phone(phone);
    if (phoneError != null) {
      _showWarning(phoneError);
      return null;
    }

    final birthDate = _parseDate(birthDateRaw);
    if (birthDate == null) {
      _showWarning(
        'Tanggal lahir harus menggunakan format YYYY-MM-DD atau DD/MM/YYYY',
      );
      return null;
    }

    if (birthDate.isAfter(DateTime.now())) {
      _showWarning('Tanggal lahir tidak boleh di masa depan');
      return null;
    }

    if (_jenisKelamin == null) {
      _showWarning('Jenis kelamin wajib dipilih');
      return null;
    }

    if (_daerah == null) {
      _showWarning('Daerah wajib dipilih');
      return null;
    }

    if (_jalan == null) {
      _showWarning('Jalan wajib dipilih');
      return null;
    }

    if (zipCode.isEmpty) {
      _showWarning('Zip Code wajib diisi');
      return null;
    }

    if (!RegExp(r'^\d{4,10}$').hasMatch(zipCode)) {
      _showWarning('Format Zip Code tidak valid');
      return null;
    }

    if (_pekerjaan == null) {
      _showWarning('Pekerjaan/Status wajib dipilih');
      return null;
    }

    if (_tempatTinggal == null) {
      _showWarning('Tempat tinggal wajib dipilih');
      return null;
    }

    return AdopterOrderPersonalInfoModel(
      namaLengkap: '$firstName $lastName'.trim(),
      email: email,
      noTelepon: phone,
      tanggalLahir: birthDate,
      jenisKelamin: _jenisKelamin!,
      daerah: _daerah!,
      jalan: _jalan!,
      zipCode: zipCode,
      pekerjaanStatus: _pekerjaan!,
      tempatTinggal: _tempatTinggal!,
    );
  }

  void _onLanjutkan() {
    final personalInfo = _buildPersonalInfo();
    if (personalInfo == null) {
      return;
    }

    AppNavigator.push(
      context,
      AdopsiFormPengalamanView(
        hewan: widget.hewan,
        personalInfo: personalInfo,
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
                      hint: 'YYYY-MM-DD atau DD/MM/YYYY',
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
                      onToggle: (opt) => setState(() => _pekerjaan = opt),
                    ),
                    SizedBox(height: 20.h),
                    FormCheckboxGroup(
                      label: 'Tempat Tinggal',
                      required: true,
                      options: _opsiTempatTinggal,
                      selected: _tempatTinggal,
                      onToggle: (opt) => setState(() => _tempatTinggal = opt),
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
