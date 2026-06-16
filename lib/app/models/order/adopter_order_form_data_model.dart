import '../../modules/adopter/adopsi/widgets/hewan_model.dart';
import 'adopter_order_personal_info_model.dart';

class AdopterOrderFormDataModel {
  final String namaLengkap;
  final String email;
  final String noTelepon;
  final DateTime tanggalLahir;
  final String jenisKelamin;
  final String daerah;
  final String jalan;
  final String zipCode;
  final String pekerjaanStatus;
  final String tempatTinggal;
  final bool hewanSebelumnya;
  final String? hewanSebelumnyaDetail;
  final String? durasiMemelihara;
  final bool memilikiHewan;
  final bool keluargaAlergi;
  final bool lingkunganAman;

  const AdopterOrderFormDataModel({
    required this.namaLengkap,
    required this.email,
    required this.noTelepon,
    required this.tanggalLahir,
    required this.jenisKelamin,
    required this.daerah,
    required this.jalan,
    required this.zipCode,
    required this.pekerjaanStatus,
    required this.tempatTinggal,
    required this.hewanSebelumnya,
    required this.hewanSebelumnyaDetail,
    required this.durasiMemelihara,
    required this.memilikiHewan,
    required this.keluargaAlergi,
    required this.lingkunganAman,
  });

  factory AdopterOrderFormDataModel.fromPersonalInfo({
    required AdopterOrderPersonalInfoModel personalInfo,
    required bool hewanSebelumnya,
    required String? hewanSebelumnyaDetail,
    required String? durasiMemelihara,
    required bool memilikiHewan,
    required bool keluargaAlergi,
    required bool lingkunganAman,
  }) {
    return AdopterOrderFormDataModel(
      namaLengkap: personalInfo.namaLengkap,
      email: personalInfo.email,
      noTelepon: personalInfo.noTelepon,
      tanggalLahir: personalInfo.tanggalLahir,
      jenisKelamin: personalInfo.jenisKelamin,
      daerah: personalInfo.daerah,
      jalan: personalInfo.jalan,
      zipCode: personalInfo.zipCode,
      pekerjaanStatus: personalInfo.pekerjaanStatus,
      tempatTinggal: personalInfo.tempatTinggal,
      hewanSebelumnya: hewanSebelumnya,
      hewanSebelumnyaDetail: hewanSebelumnyaDetail,
      durasiMemelihara: durasiMemelihara,
      memilikiHewan: memilikiHewan,
      keluargaAlergi: keluargaAlergi,
      lingkunganAman: lingkunganAman,
    );
  }

  Map<String, dynamic> toCreateOrderJson({
    required HewanModel hewan,
    DateTime? tanggalPengajuan,
  }) {
    final category = hewan.kategori?.trim().isNotEmpty == true
        ? hewan.kategori!.trim()
        : (hewan.tags.isNotEmpty ? hewan.tags.first : hewan.name);

    return {
      'daerah': daerah,
      'email': email,
      'hewanSebelumnya': hewanSebelumnya,
      'jalan': jalan,
      'jenisHewan': category,
      'jenisKelamin': jenisKelamin,
      'keluargaAlergi': keluargaAlergi,
      'lingkunganAman': lingkunganAman,
      'memilikiHewan': memilikiHewan,
      'nama': namaLengkap,
      'noTelepon': noTelepon,
      'pekerjaanStatus': pekerjaanStatus,
      'tanggalHewan': _formatDate(tanggalPengajuan ?? DateTime.now()),
      'tanggalLahir': _formatDate(tanggalLahir),
      'tempatTinggal': tempatTinggal,
      'zipCode': zipCode,
    };
  }

  static String _formatDate(DateTime value) {
    final year = value.year.toString().padLeft(4, '0');
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}
