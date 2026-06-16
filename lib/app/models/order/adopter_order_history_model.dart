import 'package:flutter/material.dart';

import '../../modules/adopter/adopsi/widgets/hewan_model.dart';
import '../../modules/adopter/pesanan/model/pesanan_terakhir_item.dart';
import '../home/adopter_home_animals_model.dart';
import 'adopter_payment_session_model.dart';

enum AdopterOrderProgressState { completed, current, upcoming, failed }

class AdopterOrderProgressStepModel {
  final String title;
  final String? description;
  final AdopterOrderProgressState state;

  const AdopterOrderProgressStepModel({
    required this.title,
    required this.state,
    this.description,
  });
}

class AdopterOrderActivityItemModel {
  final String title;
  final String timestamp;

  const AdopterOrderActivityItemModel({
    required this.title,
    required this.timestamp,
  });
}

class AdopterOrderHistoryModel {
  final int id;
  final String kodePemesanan;
  final String status;
  final String statusPembayaran;
  final String timeLeft;
  final String linkPembayaran;
  final String tokenPembayaran;
  final AdopterOrderHistoryFormModel form;
  final AdopterFeaturedAnimalModel hewan;
  final AdopterPaymentSessionModel? paymentSession;
  final bool isReviewed;

  const AdopterOrderHistoryModel({
    required this.id,
    required this.kodePemesanan,
    required this.status,
    required this.statusPembayaran,
    required this.timeLeft,
    required this.linkPembayaran,
    required this.tokenPembayaran,
    required this.form,
    required this.hewan,
    this.paymentSession,
    this.isReviewed = false,
  });

  factory AdopterOrderHistoryModel.fromJson(Map<String, dynamic> json) {
    final animal = parseAdopterAnimal(json['hewan']);
    if (animal == null) {
      throw const FormatException('Data hewan pada pesanan tidak valid.');
    }

    return AdopterOrderHistoryModel(
      id: _readInt(json['id']),
      kodePemesanan: _readText(json['kodePemesanan']),
      status: _readText(json['status']),
      statusPembayaran: _readText(json['statusPembayaran']),
      timeLeft: _readText(json['timeLeft']),
      linkPembayaran: _readText(json['linkPembayaran']),
      tokenPembayaran: _readText(json['tokenPembayaran']),
      form: AdopterOrderHistoryFormModel.fromJson(_readMap(json['form'])),
      hewan: animal,
    );
  }

  AdopterOrderHistoryModel copyWith({
    AdopterPaymentSessionModel? paymentSession,
    bool clearPaymentSession = false,
    bool? isReviewed,
  }) {
    return AdopterOrderHistoryModel(
      id: id,
      kodePemesanan: kodePemesanan,
      status: status,
      statusPembayaran: statusPembayaran,
      timeLeft: timeLeft,
      linkPembayaran: linkPembayaran,
      tokenPembayaran: tokenPembayaran,
      form: form,
      hewan: hewan,
      paymentSession: clearPaymentSession
          ? null
          : paymentSession ?? this.paymentSession,
      isReviewed: isReviewed ?? this.isReviewed,
    );
  }

  String get normalizedStatus => status.trim().toUpperCase();

  String get normalizedPaymentStatus => statusPembayaran.trim().toLowerCase();

  bool get isAccepted =>
      normalizedStatus == 'DITERIMA' || normalizedStatus.contains('DITERIMA');

  bool get isRejected =>
      normalizedStatus == 'DITOLAK' || normalizedStatus.contains('DITOLAK');

  bool get isFormPending => !isAccepted && !isRejected;

  bool get isPaymentSuccess {
    final normalized = normalizedPaymentStatus;
    if (normalized.isEmpty) {
      return false;
    }

    return normalized.contains('sukses') ||
        normalized.contains('success') ||
        normalized.contains('berhasil') ||
        normalized.contains('settlement') ||
        normalized.contains('capture') ||
        normalized.contains('paid');
  }

  bool get isPaymentPending {
    if (!isAccepted || isPaymentSuccess) {
      return false;
    }

    final normalized = normalizedPaymentStatus;
    return normalized.isEmpty || normalized == 'pending';
  }

  bool get hasPaymentIssue {
    if (!isAccepted || isPaymentSuccess) {
      return false;
    }

    final normalized = normalizedPaymentStatus;
    return normalized.isNotEmpty && normalized != 'pending';
  }

  bool get hasPaymentTimer => paymentSession != null;

  bool get isPaymentExpiredLocally {
    final session = paymentSession;
    if (session == null || !isPaymentPending) {
      return false;
    }
    return session.isExpired;
  }

  Duration get remainingPaymentDuration {
    final session = paymentSession;
    if (session == null) {
      return Duration.zero;
    }
    return session.remainingDuration;
  }

  bool get hasFinalFailure =>
      isRejected || hasPaymentIssue || isPaymentExpiredLocally;

  bool get shouldAppearInHistory => isPaymentSuccess || hasFinalFailure;

  bool get shouldAppearInActiveOrders => !shouldAppearInHistory;

  bool get canAccessPaymentTab =>
      isAccepted ||
      isPaymentSuccess ||
      hasPaymentIssue ||
      isPaymentExpiredLocally;

  bool get canOpenPayment =>
      canAccessPaymentTab &&
      !isPaymentSuccess &&
      !isPaymentExpiredLocally &&
      paymentLinkUrl.isNotEmpty;

  bool get shouldClearLocalPaymentSession =>
      isPaymentSuccess || hasPaymentIssue || isRejected;

  String get orderCodeLabel => kodePemesanan.isEmpty
      ? 'HWN-${id.toString().padLeft(8, '0')}'
      : kodePemesanan;

  String get orderDateLabel => _formatDate(form.tanggalHewan);

  String get totalBiayaLabel => hewan.toHewanModel().price;

  String get shelterLabel => hewan.shelter.label;

  String get paymentLinkUrl => _sanitizeQuotedValue(linkPembayaran);

  String get paymentTokenValue => _sanitizeQuotedValue(tokenPembayaran);

  String get paymentCountdownLabel {
    final remaining = remainingPaymentDuration;
    final minutes = remaining.inMinutes
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    final seconds = remaining.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String get processStatusLabel {
    if (isFormPending) {
      return 'Menunggu Persetujuan';
    }
    if (isAccepted && isPaymentSuccess) {
      return 'Selesai';
    }
    if (isPaymentExpiredLocally) {
      return 'Pembayaran Gagal';
    }
    if (isAccepted && hasPaymentIssue) {
      return 'Pembayaran Gagal';
    }
    if (isAccepted) {
      return 'Menunggu Pembayaran';
    }
    if (isRejected) {
      return 'Form Ditolak';
    }
    return 'Diproses';
  }

  Color get processStatusColor {
    if (isPaymentSuccess) {
      return const Color(0xFF2E7D32);
    }
    if (isRejected || hasPaymentIssue || isPaymentExpiredLocally) {
      return const Color(0xFFE53935);
    }
    if (isAccepted) {
      return const Color(0xFFFBA81F);
    }
    return const Color(0xFFF87537);
  }

  String get paymentButtonLabel {
    if (hasPaymentIssue) {
      return 'Buka Ulang Pembayaran';
    }
    if (isPaymentExpiredLocally) {
      return 'Pembayaran Gagal';
    }
    return 'Lanjutkan Pembayaran';
  }

  String get paymentStatusLabel {
    if (!canAccessPaymentTab) {
      return 'Belum tersedia';
    }
    if (isPaymentSuccess) {
      return 'Pembayaran Berhasil';
    }
    if (isPaymentExpiredLocally) {
      return 'Pembayaran Gagal';
    }
    if (hasPaymentIssue) {
      return normalizedPaymentStatus.isEmpty
          ? 'Pembayaran Bermasalah'
          : 'Status: ${statusPembayaran.trim()}';
    }
    return 'Menunggu Pembayaran';
  }

  String get failureHistoryMessage {
    if (isRejected) {
      return 'Form adopsi tidak disetujui oleh shelter.';
    }
    if (isPaymentExpiredLocally) {
      return 'Pembayaran tidak diselesaikan dalam batas waktu 15 menit.';
    }
    if (hasPaymentIssue) {
      final label = statusPembayaran.trim().isEmpty
          ? 'pembayaran gagal diproses'
          : 'status pembayaran ${statusPembayaran.trim()}';
      return 'Pesanan berakhir karena $label.';
    }
    return 'Pesanan tidak berhasil diselesaikan.';
  }

  DateTime? get orderDate => DateTime.tryParse(form.tanggalHewan.trim());

  HewanModel get hewanModel => hewan.toHewanModel();

  List<AdopterOrderProgressStepModel> buildFormSteps() {
    if (isRejected) {
      return const <AdopterOrderProgressStepModel>[
        AdopterOrderProgressStepModel(
          title: 'Kirim Form Adopsi',
          state: AdopterOrderProgressState.completed,
        ),
        AdopterOrderProgressStepModel(
          title: 'Menunggu Persetujuan Shelter',
          state: AdopterOrderProgressState.completed,
        ),
        AdopterOrderProgressStepModel(
          title: 'Form Ditolak',
          state: AdopterOrderProgressState.failed,
        ),
      ];
    }

    if (isAccepted) {
      return const <AdopterOrderProgressStepModel>[
        AdopterOrderProgressStepModel(
          title: 'Kirim Form Adopsi',
          state: AdopterOrderProgressState.completed,
        ),
        AdopterOrderProgressStepModel(
          title: 'Menunggu Persetujuan Shelter',
          state: AdopterOrderProgressState.completed,
        ),
        AdopterOrderProgressStepModel(
          title: 'Form Diterima',
          state: AdopterOrderProgressState.completed,
        ),
      ];
    }

    return const <AdopterOrderProgressStepModel>[
      AdopterOrderProgressStepModel(
        title: 'Kirim Form Adopsi',
        state: AdopterOrderProgressState.completed,
      ),
      AdopterOrderProgressStepModel(
        title: 'Menunggu Persetujuan Shelter',
        state: AdopterOrderProgressState.current,
      ),
      AdopterOrderProgressStepModel(
        title: 'Form Diterima',
        state: AdopterOrderProgressState.upcoming,
      ),
    ];
  }

  List<AdopterOrderActivityItemModel> buildFormActivities({DateTime? now}) {
    final baseTime = now ?? DateTime.now();
    final activities = <AdopterOrderActivityItemModel>[
      AdopterOrderActivityItemModel(
        title: 'Form adopsi berhasil dikirim.',
        timestamp: _formatDateTime(
          baseTime.subtract(const Duration(minutes: 2)),
        ),
      ),
    ];

    if (isFormPending) {
      activities.add(
        AdopterOrderActivityItemModel(
          title: 'Form sedang menunggu persetujuan dari shelter.',
          timestamp: _formatDateTime(baseTime),
        ),
      );
      return activities;
    }

    activities.add(
      AdopterOrderActivityItemModel(
        title: 'Shelter telah meninjau formulir adopsi.',
        timestamp: _formatDateTime(
          baseTime.subtract(const Duration(minutes: 1)),
        ),
      ),
    );

    activities.add(
      AdopterOrderActivityItemModel(
        title: isAccepted
            ? 'Form adopsi diterima dan siap lanjut ke pembayaran.'
            : 'Form adopsi ditolak oleh shelter.',
        timestamp: _formatDateTime(baseTime),
      ),
    );

    return activities;
  }

  List<AdopterOrderProgressStepModel> buildPaymentSteps() {
    if (!canAccessPaymentTab) {
      return const <AdopterOrderProgressStepModel>[
        AdopterOrderProgressStepModel(
          title: 'Silakan Membayar',
          state: AdopterOrderProgressState.upcoming,
        ),
        AdopterOrderProgressStepModel(
          title: 'Pembayaran Berhasil',
          state: AdopterOrderProgressState.upcoming,
        ),
        AdopterOrderProgressStepModel(
          title: 'Beri Ulasan di Pesanan Terakhir',
          state: AdopterOrderProgressState.upcoming,
        ),
      ];
    }

    if (isPaymentSuccess) {
      return <AdopterOrderProgressStepModel>[
        AdopterOrderProgressStepModel(
          title: 'Silakan Membayar',
          state: AdopterOrderProgressState.completed,
        ),
        AdopterOrderProgressStepModel(
          title: 'Pembayaran Berhasil',
          state: AdopterOrderProgressState.completed,
        ),
        AdopterOrderProgressStepModel(
          title: 'Beri Ulasan di Pesanan Terakhir',
          state: isReviewed
              ? AdopterOrderProgressState.completed
              : AdopterOrderProgressState.current,
        ),
      ];
    }

    if (isPaymentExpiredLocally) {
      return const <AdopterOrderProgressStepModel>[
        AdopterOrderProgressStepModel(
          title: 'Silakan Membayar',
          state: AdopterOrderProgressState.completed,
        ),
        AdopterOrderProgressStepModel(
          title: 'Pembayaran Gagal',
          state: AdopterOrderProgressState.failed,
        ),
        AdopterOrderProgressStepModel(
          title: 'Beri Ulasan di Pesanan Terakhir',
          state: AdopterOrderProgressState.upcoming,
        ),
      ];
    }

    if (hasPaymentIssue) {
      return <AdopterOrderProgressStepModel>[
        const AdopterOrderProgressStepModel(
          title: 'Silakan Membayar',
          state: AdopterOrderProgressState.completed,
        ),
        AdopterOrderProgressStepModel(
          title: 'Status Pembayaran ${statusPembayaran.trim()}',
          state: AdopterOrderProgressState.failed,
        ),
        const AdopterOrderProgressStepModel(
          title: 'Beri Ulasan di Pesanan Terakhir',
          state: AdopterOrderProgressState.upcoming,
        ),
      ];
    }

    return const <AdopterOrderProgressStepModel>[
      AdopterOrderProgressStepModel(
        title: 'Silakan Membayar',
        state: AdopterOrderProgressState.current,
      ),
      AdopterOrderProgressStepModel(
        title: 'Pembayaran Berhasil',
        state: AdopterOrderProgressState.upcoming,
      ),
      AdopterOrderProgressStepModel(
        title: 'Beri Ulasan di Pesanan Terakhir',
        state: AdopterOrderProgressState.upcoming,
      ),
    ];
  }

  List<AdopterOrderActivityItemModel> buildPaymentActivities({DateTime? now}) {
    final baseTime = now ?? DateTime.now();

    if (!canAccessPaymentTab) {
      return const <AdopterOrderActivityItemModel>[];
    }

    final activities = <AdopterOrderActivityItemModel>[
      AdopterOrderActivityItemModel(
        title: 'Tagihan Midtrans sudah dibuat untuk pesanan ini.',
        timestamp: _formatDateTime(
          baseTime.subtract(const Duration(minutes: 2)),
        ),
      ),
    ];

    if (isPaymentSuccess) {
      activities.addAll(<AdopterOrderActivityItemModel>[
        AdopterOrderActivityItemModel(
          title: 'Pembayaran berhasil terverifikasi.',
          timestamp: _formatDateTime(
            baseTime.subtract(const Duration(minutes: 1)),
          ),
        ),
        AdopterOrderActivityItemModel(
          title: isReviewed
              ? 'Ulasan untuk hewan sudah berhasil dikirim.'
              : 'Lanjutkan beri ulasan dari tab Pesanan Terakhir.',
          timestamp: _formatDateTime(baseTime),
        ),
      ]);
      return activities;
    }

    if (isPaymentExpiredLocally) {
      activities.add(
        AdopterOrderActivityItemModel(
          title:
              'Waktu pembayaran 15 menit telah habis dan pesanan dinyatakan gagal.',
          timestamp: _formatDateTime(baseTime),
        ),
      );
      return activities;
    }

    if (hasPaymentIssue) {
      activities.add(
        AdopterOrderActivityItemModel(
          title:
              'Status pembayaran saat ini ${statusPembayaran.trim()}. Cek kembali atau buka ulang halaman pembayaran.',
          timestamp: _formatDateTime(baseTime),
        ),
      );
      return activities;
    }

    if (hasPaymentTimer) {
      activities.add(
        AdopterOrderActivityItemModel(
          title:
              'Pembayaran sedang berjalan. Selesaikan dalam 15 menit sejak halaman Midtrans dibuka.',
          timestamp: _formatDateTime(paymentSession!.startedAt),
        ),
      );
    } else {
      activities.add(
        AdopterOrderActivityItemModel(
          title:
              'Menunggu kamu membuka Midtrans untuk menyelesaikan pembayaran.',
          timestamp: _formatDateTime(baseTime),
        ),
      );
    }
    return activities;
  }

  PesananTerakhirItem toPesananTerakhirItem() {
    final animal = hewanModel;
    final statusLabel = isPaymentSuccess ? 'BERHASIL' : 'GAGAL';
    final statusColor = isPaymentSuccess
        ? const Color(0xFF4CAF50)
        : const Color(0xFFE53935);
    final message = isPaymentSuccess
        ? PesananTerakhirItem.defaultPesanTerimakasih
        : failureHistoryMessage;

    return PesananTerakhirItem(
      namaShelter: shelterLabel,
      nomorInvoice: orderCodeLabel,
      tanggal: orderDateLabel,
      statusLabel: statusLabel,
      statusColor: statusColor,
      detailAdopsi: <DetailAdopsiRow>[
        DetailAdopsiRow(
          imageUrl: animal.imageUrl,
          namaHewan: animal.name,
          subNama: animal.shelter,
          harga: animal.price,
        ),
      ],
      totalBiaya: animal.price,
      pesanTerimakasih: message,
      canReview: isPaymentSuccess && !isReviewed,
      actionLabel: isPaymentSuccess && isReviewed ? 'SELESAI' : statusLabel,
      orderId: id,
      animalId: animal.id,
      animalName: animal.name,
    );
  }

  static List<AdopterOrderHistoryModel> parseList(Object? rawData) {
    if (rawData is! List) {
      return const <AdopterOrderHistoryModel>[];
    }

    return rawData
        .whereType<Object?>()
        .map((item) {
          if (item is Map<String, dynamic>) {
            return AdopterOrderHistoryModel.fromJson(item);
          }
          if (item is Map) {
            return AdopterOrderHistoryModel.fromJson(
              Map<String, dynamic>.from(item),
            );
          }
          return null;
        })
        .whereType<AdopterOrderHistoryModel>()
        .toList(growable: true)
      ..sort((a, b) {
        final aDate = a.orderDate;
        final bDate = b.orderDate;
        if (aDate != null && bDate != null) {
          return bDate.compareTo(aDate);
        }
        if (aDate != null) {
          return -1;
        }
        if (bDate != null) {
          return 1;
        }
        return b.id.compareTo(a.id);
      });
  }
}

class AdopterOrderHistoryFormModel {
  final int id;
  final String nama;
  final String email;
  final String noTelepon;
  final String tanggalHewan;
  final String tanggalLahir;

  const AdopterOrderHistoryFormModel({
    required this.id,
    required this.nama,
    required this.email,
    required this.noTelepon,
    required this.tanggalHewan,
    required this.tanggalLahir,
  });

  factory AdopterOrderHistoryFormModel.fromJson(Map<String, dynamic> json) {
    return AdopterOrderHistoryFormModel(
      id: _readInt(json['id']),
      nama: _readText(json['nama']),
      email: _readText(json['email']),
      noTelepon: _readText(json['noTelepon']),
      tanggalHewan: _readText(json['tanggalHewan']),
      tanggalLahir: _readText(json['tanggalLahir']),
    );
  }
}

String _formatDate(String rawDate) {
  final parsed = DateTime.tryParse(rawDate.trim());
  if (parsed == null) {
    return rawDate.trim().isEmpty ? '-' : rawDate.trim();
  }

  const months = <String>[
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  final day = parsed.day.toString().padLeft(2, '0');
  final month = months[parsed.month - 1];
  final year = parsed.year;
  return '$day $month $year';
}

String _formatDateTime(DateTime value) {
  const months = <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];

  final day = value.day.toString().padLeft(2, '0');
  final month = months[value.month - 1];
  final year = value.year;
  final hour = value.hour.toString().padLeft(2, '0');
  final minute = value.minute.toString().padLeft(2, '0');
  return '$day $month $year, $hour:$minute';
}

String _sanitizeQuotedValue(String rawValue) {
  final cleaned = rawValue.trim();
  if (cleaned.isEmpty) {
    return '';
  }

  return cleaned.replaceAll('"', '').trim();
}

int _readInt(Object? raw) {
  if (raw is int) {
    return raw;
  }
  if (raw is num) {
    return raw.toInt();
  }
  if (raw is String) {
    return int.tryParse(raw.trim()) ?? 0;
  }
  return 0;
}

String _readText(Object? raw) => raw?.toString().trim() ?? '';

Map<String, dynamic> _readMap(Object? raw) {
  if (raw is Map<String, dynamic>) {
    return raw;
  }
  if (raw is Map) {
    return Map<String, dynamic>.from(raw);
  }
  return const <String, dynamic>{};
}
