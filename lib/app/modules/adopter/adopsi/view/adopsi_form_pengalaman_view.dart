import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../common/utils/app_navigator.dart';
import '../../../../widgets/build_header_app.dart';
import '../../navbar/view/navbar_controller.dart';
import '../../pesanan/model/pesanan_item.dart';
import '../../pesanan/model/pesanan_provider.dart';
import '../widgets/hewan_model.dart';
import '../widgets/adopsi_form_widgets.dart';

/// Form B — Pengalaman & Kondisi Lingkungan
class AdopsiFormPengalamanView extends StatefulWidget {
  final HewanModel hewan;

  /// Dipanggil saat X ditekan — Form A akan pop dirinya sendiri
  /// sehingga kembali langsung ke Detail Hewan
  final VoidCallback? onCloseToDetail;

  const AdopsiFormPengalamanView({
    super.key,
    required this.hewan,
    this.onCloseToDetail,
  });

  @override
  State<AdopsiFormPengalamanView> createState() =>
      _AdopsiFormPengalamanViewState();
}

class _AdopsiFormPengalamanViewState extends State<AdopsiFormPengalamanView> {
  bool? _pernahPelihara;
  final _hewanApaCtrl = TextEditingController();
  final _berapaLamaCtrl = TextEditingController();
  bool? _punyaHewanLain;
  bool? _adaAlergi;
  bool? _lingkunganAman;

  @override
  void dispose() {
    _hewanApaCtrl.dispose();
    _berapaLamaCtrl.dispose();
    super.dispose();
  }

  // ── Validasi ──────────────────────────────────────────────────────────────
  bool _validate() {
    if (_pernahPelihara == null) {
      _showError('Pertanyaan 1 wajib dijawab');
      return false;
    }
    if (_punyaHewanLain == null) {
      _showError('Pertanyaan 2 wajib dijawab');
      return false;
    }
    if (_adaAlergi == null) {
      _showError('Pertanyaan 3 wajib dijawab');
      return false;
    }
    if (_lingkunganAman == null) {
      _showError('Pertanyaan 4 wajib dijawab');
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.r)),
      ),
    );
  }

  // ── Buat PesananItem dari data hewan ──────────────────────────────────────
  PesananItem _buatPesanan() {
    final now = DateTime.now();
    const days = ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    final tanggal =
        '${days[now.weekday % 7]}, ${now.day.toString().padLeft(2, '0')} ${months[now.month - 1]} ${now.year}';
    final waktuMasuk =
        '${now.day} ${months[now.month - 1]}, ${now.year} pada ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} WIB';
    final invoiceNum = now.millisecondsSinceEpoch % 100000;
    final orderNum = (900000000 + now.millisecondsSinceEpoch % 99999999).toString();

    return PesananItem(
      namaShelter: widget.hewan.shelter,
      nomorInvoice: 'INV-${now.year}-$invoiceNum',
      tanggal: tanggal,
      nomorOrder: '#$orderNum',
      infoOrder: '1 Hewan  •  Form pengajuan kemungkinan dibaca 1-3 hari',
      status: PesananStatus.sedangDiproses,
      hewan: DetailHewan(
        imageUrl: widget.hewan.imageUrl,
        namaHewan: widget.hewan.name,
        subNama: widget.hewan.shelter,
        totalBiaya: widget.hewan.priceRange != '-'
            ? widget.hewan.priceRange
            : 'Lihat Detail',
      ),
      timeline: [
        TimelineStep(
          judul: 'Form Masuk',
          waktu: waktuMasuk,
          status: TimelineStatus.selesai,
        ),
        const TimelineStep(
          judul: 'Form Disetujui',
          status: TimelineStatus.menunggu,
        ),
        const TimelineStep(
          judul: 'Lanjutkan Pembayaran',
          status: TimelineStatus.menunggu,
        ),
      ],
      perkiraanKedatangan: '1-3 Hari Kerja',
      hewanModel: widget.hewan, // <-- simpan data lengkap HewanModel
    );
  }

  void _onKirimForm() {
    if (!_validate()) return;

    // Tambah ke PesananProvider
    PesananProvider.tambah(context, _buatPesanan());

    // Switch ke tab Pesanan (index 2) via NavbarController
    NavbarController.goTo(2);

    // Pop semua halaman kembali ke NavbarView
    AppNavigator.popUntilFirst(context);
  }

  void _onCloseX() {
    // Pop Form B dulu
    AppNavigator.pop(context);
    // Lalu Form A pop dirinya sendiri ke Detail Hewan
    widget.onCloseToDetail?.call();
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
              title: 'B. Pengalaman & Kondisi Lingkungan',
              onClose: _onCloseX,
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Pertanyaan 1
                    FormYesNo(
                      question:
                          'Apakah Anda pernah memelihara hewan sebelumnya?',
                      value: _pernahPelihara,
                      required: true,
                      onChanged: (v) => setState(() => _pernahPelihara = v),
                    ),
                    SizedBox(height: 20.h),

                    // Pertanyaan 1b — hanya tampil jika Iya
                    if (_pernahPelihara == true) ...[
                      _SubQuestion(
                        label:
                            'Jika ya, hewan apa yang pernah Anda pelihara dan berapa lama?',
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          Expanded(
                            child: FormTextField(
                              label: 'Hewan dan ras',
                              controller: _hewanApaCtrl,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: FormTextField(
                              label: 'Tahun, bulan, hari',
                              controller: _berapaLamaCtrl,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                    ],

                    // Pertanyaan 2
                    FormYesNo(
                      question:
                          'Saat ini apakah Anda memiliki hewan peliharaan lain?',
                      value: _punyaHewanLain,
                      required: true,
                      onChanged: (v) => setState(() => _punyaHewanLain = v),
                    ),
                    SizedBox(height: 20.h),

                    // Pertanyaan 3
                    FormYesNo(
                      question:
                          'Apakah ada anggota keluarga atau teman serumah yang alergi terhadap hewan?',
                      value: _adaAlergi,
                      required: true,
                      onChanged: (v) => setState(() => _adaAlergi = v),
                    ),
                    SizedBox(height: 20.h),

                    // Pertanyaan 4
                    FormYesNo(
                      question:
                          'Apakah lingkungan tempat tinggal Anda aman untuk hewan?',
                      value: _lingkunganAman,
                      required: true,
                      onChanged: (v) => setState(() => _lingkunganAman = v),
                    ),
                    SizedBox(height: 8.h),
                  ],
                ),
              ),
            ),
            FormBottomButtons(
              actionLabel: 'Kirim Form',
              onKembali: () => AppNavigator.pop(context),
              onAction: _onKirimForm,
            ),
          ],
        ),
      ),
    );
  }
}

class _SubQuestion extends StatelessWidget {
  final String label;
  const _SubQuestion({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF1A1A1A),
      ),
    );
  }
}