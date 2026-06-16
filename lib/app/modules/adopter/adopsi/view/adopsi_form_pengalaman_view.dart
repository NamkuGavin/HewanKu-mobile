import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../common/utils/app_navigator.dart';
import '../../../../common/widgets/app_loading_dialog.dart';
import '../../../../common/widgets/app_snackbar.dart';
import '../../../../models/order/adopter_order_form_data_model.dart';
import '../../../../models/order/adopter_order_personal_info_model.dart';
import '../../../../services/api/api_exception.dart';
import '../../../../services/order/adopter_order_service.dart';
import '../../../../widgets/build_header_app.dart';
import '../../navbar/view/navbar_controller.dart';
import '../../pesanan/view/pesanan_tab_controller.dart';
import '../widgets/adopsi_form_widgets.dart';
import '../widgets/hewan_model.dart';

class AdopsiFormPengalamanView extends StatefulWidget {
  final HewanModel hewan;
  final AdopterOrderPersonalInfoModel personalInfo;
  final VoidCallback? onCloseToDetail;

  const AdopsiFormPengalamanView({
    super.key,
    required this.hewan,
    required this.personalInfo,
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
  bool _isSubmitting = false;

  @override
  void dispose() {
    _hewanApaCtrl.dispose();
    _berapaLamaCtrl.dispose();
    super.dispose();
  }

  void _showWarning(String message) {
    AppSnackbar.show(context, message: message, type: AppSnackbarType.warning);
  }

  AdopterOrderFormDataModel? _buildFormData() {
    if (_pernahPelihara == null) {
      _showWarning(
        'Pertanyaan tentang pengalaman memelihara hewan wajib dijawab',
      );
      return null;
    }

    if (_pernahPelihara == true) {
      if (_hewanApaCtrl.text.trim().isEmpty) {
        _showWarning('Jenis hewan yang pernah dipelihara wajib diisi');
        return null;
      }
      if (_berapaLamaCtrl.text.trim().isEmpty) {
        _showWarning('Lama memelihara hewan wajib diisi');
        return null;
      }
    }

    if (_punyaHewanLain == null) {
      _showWarning('Pertanyaan tentang hewan peliharaan lain wajib dijawab');
      return null;
    }

    if (_adaAlergi == null) {
      _showWarning('Pertanyaan tentang alergi wajib dijawab');
      return null;
    }

    if (_lingkunganAman == null) {
      _showWarning('Pertanyaan tentang keamanan lingkungan wajib dijawab');
      return null;
    }

    return AdopterOrderFormDataModel.fromPersonalInfo(
      personalInfo: widget.personalInfo,
      hewanSebelumnya: _pernahPelihara!,
      hewanSebelumnyaDetail:
          _pernahPelihara == true && _hewanApaCtrl.text.trim().isNotEmpty
          ? _hewanApaCtrl.text.trim()
          : null,
      durasiMemelihara:
          _pernahPelihara == true && _berapaLamaCtrl.text.trim().isNotEmpty
          ? _berapaLamaCtrl.text.trim()
          : null,
      memilikiHewan: _punyaHewanLain!,
      keluargaAlergi: _adaAlergi!,
      lingkunganAman: _lingkunganAman!,
    );
  }

  String _resolveSuccessMessage(String? message) {
    final normalized = message?.trim();
    if (normalized == null || normalized.isEmpty) {
      return 'Form adopsi berhasil dikirim.';
    }
    return normalized;
  }

  String _resolveErrorMessage(Object error) {
    if (error is ApiException) {
      return error.message;
    }
    if (error is FormatException) {
      return error.message;
    }
    return 'Gagal mengirim form adopsi.';
  }

  AppSnackbarType _resolveErrorType(Object error) {
    if (error is ApiException) {
      final statusCode = error.statusCode;
      if (error.isUnauthorized ||
          statusCode == 400 ||
          statusCode == 401 ||
          statusCode == 403) {
        return AppSnackbarType.warning;
      }
      if (statusCode == null || statusCode >= 500) {
        return AppSnackbarType.error;
      }
      return AppSnackbarType.warning;
    }
    if (error is FormatException) {
      return AppSnackbarType.warning;
    }
    return AppSnackbarType.error;
  }

  bool _isUnauthorized(Object error) {
    return error is ApiException && error.isUnauthorized;
  }

  Future<void> _onKirimForm() async {
    if (_isSubmitting) {
      return;
    }

    if (widget.hewan.id <= 0) {
      _showWarning('ID hewan tidak valid. Coba buka detail hewan lagi.');
      return;
    }

    final formData = _buildFormData();
    if (formData == null) {
      return;
    }

    setState(() => _isSubmitting = true);
    AppLoadingDialog.show(context, message: 'Mengirim form adopsi...');

    try {
      final response = await AdopterOrderService.instance.createOrder(
        hewan: widget.hewan,
        formData: formData,
      );

      if (!mounted) {
        return;
      }

      PesananTabController.openPesananSaya(refresh: true);
      NavbarController.goTo(2);
      AppSnackbar.show(
        context,
        message: _resolveSuccessMessage(response.message),
        type: AppSnackbarType.success,
      );
      AppNavigator.popUntilFirst(context);
    } catch (error) {
      if (!mounted || _isUnauthorized(error)) {
        return;
      }

      AppSnackbar.show(
        context,
        message: _resolveErrorMessage(error),
        type: _resolveErrorType(error),
      );
    } finally {
      AppLoadingDialog.hide();
      if (mounted) {
        setState(() => _isSubmitting = false);
      } else {
        _isSubmitting = false;
      }
    }
  }

  void _onCloseX() {
    AppNavigator.pop(context);
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
              onClose: _isSubmitting ? () {} : _onCloseX,
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FormYesNo(
                      question:
                          'Apakah Anda pernah memelihara hewan sebelumnya?',
                      value: _pernahPelihara,
                      required: true,
                      onChanged: (v) => setState(() => _pernahPelihara = v),
                    ),
                    SizedBox(height: 20.h),
                    if (_pernahPelihara == true) ...[
                      const _SubQuestion(
                        label:
                            'Jika ya, hewan apa yang pernah Anda pelihara dan berapa lama?',
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          Expanded(
                            child: FormTextField(
                              label: 'Hewan dan ras',
                              required: true,
                              controller: _hewanApaCtrl,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: FormTextField(
                              label: 'Tahun / bulan / hari',
                              required: true,
                              controller: _berapaLamaCtrl,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                    ],
                    FormYesNo(
                      question:
                          'Saat ini apakah Anda memiliki hewan peliharaan lain?',
                      value: _punyaHewanLain,
                      required: true,
                      onChanged: (v) => setState(() => _punyaHewanLain = v),
                    ),
                    SizedBox(height: 20.h),
                    FormYesNo(
                      question:
                          'Apakah ada anggota keluarga atau teman serumah yang alergi terhadap hewan?',
                      value: _adaAlergi,
                      required: true,
                      onChanged: (v) => setState(() => _adaAlergi = v),
                    ),
                    SizedBox(height: 20.h),
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
              actionLabel: _isSubmitting ? 'Mengirim...' : 'Kirim Form',
              onKembali: () {
                if (_isSubmitting) {
                  return;
                }
                AppNavigator.pop(context);
              },
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
      style: GoogleFonts.poppins(
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF1A1A1A),
      ),
    );
  }
}
