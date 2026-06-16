class AdopterPaymentSessionModel {
  final int orderId;
  final DateTime startedAt;
  final DateTime expiresAt;

  const AdopterPaymentSessionModel({
    required this.orderId,
    required this.startedAt,
    required this.expiresAt,
  });

  bool get isExpired => !DateTime.now().isBefore(expiresAt);

  Duration get remainingDuration {
    final remaining = expiresAt.difference(DateTime.now());
    if (remaining.isNegative) {
      return Duration.zero;
    }
    return remaining;
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'orderId': orderId,
      'startedAt': startedAt.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
    };
  }

  factory AdopterPaymentSessionModel.fromJson(Map<String, dynamic> json) {
    return AdopterPaymentSessionModel(
      orderId: _readInt(json['orderId']),
      startedAt: _readDateTime(json['startedAt']),
      expiresAt: _readDateTime(json['expiresAt']),
    );
  }
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

DateTime _readDateTime(Object? raw) {
  final normalized = raw?.toString().trim() ?? '';
  final parsed = DateTime.tryParse(normalized);
  return parsed ?? DateTime.fromMillisecondsSinceEpoch(0);
}
