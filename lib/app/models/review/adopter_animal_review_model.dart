class AdopterAnimalReviewModel {
  final Map<int, AdopterReviewBucketModel> buckets;
  final List<AdopterAnimalReviewItemModel> reviews;

  const AdopterAnimalReviewModel({
    required this.buckets,
    required this.reviews,
  });

  const AdopterAnimalReviewModel.empty()
    : buckets = const <int, AdopterReviewBucketModel>{
        1: AdopterReviewBucketModel(count: 0, ratio: 0),
        2: AdopterReviewBucketModel(count: 0, ratio: 0),
        3: AdopterReviewBucketModel(count: 0, ratio: 0),
        4: AdopterReviewBucketModel(count: 0, ratio: 0),
        5: AdopterReviewBucketModel(count: 0, ratio: 0),
      },
      reviews = const <AdopterAnimalReviewItemModel>[];

  factory AdopterAnimalReviewModel.fromJson(Map<String, dynamic> json) {
    return AdopterAnimalReviewModel(
      buckets: <int, AdopterReviewBucketModel>{
        1: AdopterReviewBucketModel.fromRaw(json['bintang1']),
        2: AdopterReviewBucketModel.fromRaw(json['bintang2']),
        3: AdopterReviewBucketModel.fromRaw(json['bintang3']),
        4: AdopterReviewBucketModel.fromRaw(json['bintang4']),
        5: AdopterReviewBucketModel.fromRaw(json['bintang5']),
      },
      reviews: _parseReviewList(json['ulasan']),
    );
  }

  bool get hasReviews => totalReviews > 0 || reviews.isNotEmpty;

  int get totalReviews {
    final bucketTotal = buckets.values.fold<int>(
      0,
      (sum, item) => sum + item.count,
    );
    if (bucketTotal > 0) {
      return bucketTotal;
    }
    return reviews.length;
  }

  double get averageRating {
    final total = totalReviews;
    if (total <= 0) {
      return 0;
    }

    final hasBucketValue = buckets.values.any((item) => item.count > 0);
    if (!hasBucketValue && reviews.isNotEmpty) {
      final ratingSum = reviews.fold<double>(
        0,
        (sum, item) => sum + item.rating,
      );
      return ratingSum / reviews.length;
    }

    final weighted = buckets.entries.fold<double>(
      0,
      (sum, entry) => sum + (entry.key * entry.value.count),
    );
    return weighted / total;
  }

  Map<int, double> get distributionRatio {
    final hasBucketRatio = buckets.values.any(
      (item) => item.count > 0 || item.ratio > 0,
    );
    if (!hasBucketRatio && reviews.isNotEmpty) {
      final total = reviews.length;
      final counts = <int, int>{1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
      for (final review in reviews) {
        final rounded = review.rating.round().clamp(1, 5).toInt();
        counts[rounded] = (counts[rounded] ?? 0) + 1;
      }

      return <int, double>{
        1: (counts[1] ?? 0) / total,
        2: (counts[2] ?? 0) / total,
        3: (counts[3] ?? 0) / total,
        4: (counts[4] ?? 0) / total,
        5: (counts[5] ?? 0) / total,
      };
    }

    return <int, double>{
      1: buckets[1]?.ratio ?? 0,
      2: buckets[2]?.ratio ?? 0,
      3: buckets[3]?.ratio ?? 0,
      4: buckets[4]?.ratio ?? 0,
      5: buckets[5]?.ratio ?? 0,
    };
  }
}

class AdopterReviewBucketModel {
  final int count;
  final double ratio;

  const AdopterReviewBucketModel({required this.count, required this.ratio});

  factory AdopterReviewBucketModel.fromRaw(Object? raw) {
    if (raw is List && raw.length >= 2) {
      return AdopterReviewBucketModel(
        count: _readInt(raw[0]),
        ratio: _readDouble(raw[1]),
      );
    }

    return const AdopterReviewBucketModel(count: 0, ratio: 0);
  }
}

class AdopterAnimalReviewItemModel {
  final int id;
  final String userName;
  final String comment;
  final double rating;
  final String dateAdded;
  final String photoUrl;

  const AdopterAnimalReviewItemModel({
    required this.id,
    required this.userName,
    required this.comment,
    required this.rating,
    required this.dateAdded,
    this.photoUrl = '',
  });

  factory AdopterAnimalReviewItemModel.fromJson(Map<String, dynamic> json) {
    return AdopterAnimalReviewItemModel(
      id: _readInt(json['id']),
      userName: _resolveUserName(json['user']),
      comment: _readText(json['komen']),
      rating: _readDouble(json['rating']),
      dateAdded: _formatDate(_readText(json['dateAdded'])),
      photoUrl: _resolvePhotoUrl(json['user']),
    );
  }
}

List<AdopterAnimalReviewItemModel> _parseReviewList(Object? raw) {
  if (raw is! List) {
    return const <AdopterAnimalReviewItemModel>[];
  }

  return raw
      .whereType<Object?>()
      .map((item) {
        if (item is Map<String, dynamic>) {
          return AdopterAnimalReviewItemModel.fromJson(item);
        }
        if (item is Map) {
          return AdopterAnimalReviewItemModel.fromJson(
            Map<String, dynamic>.from(item),
          );
        }
        return null;
      })
      .whereType<AdopterAnimalReviewItemModel>()
      .toList(growable: false);
}

String _resolveUserName(Object? rawUser) {
  if (rawUser is String) {
    final normalized = rawUser.trim();
    return normalized.isEmpty ? 'Adopter HewanKu' : normalized;
  }

  if (rawUser is Map<String, dynamic>) {
    return _resolveUserNameFromMap(rawUser);
  }

  if (rawUser is Map) {
    return _resolveUserNameFromMap(Map<String, dynamic>.from(rawUser));
  }

  return 'Adopter HewanKu';
}

String _resolveUserNameFromMap(Map<String, dynamic> json) {
  final displayName = _readText(json['displayName']);
  if (displayName.isNotEmpty) {
    return displayName;
  }

  final nama = _readText(json['nama']);
  if (nama.isNotEmpty) {
    return nama;
  }

  final fullName =
      '${_readText(json['namaDepan'])} ${_readText(json['namaBelakang'])}'
          .trim();
  if (fullName.isNotEmpty) {
    return fullName;
  }

  final username = _readText(json['username']);
  if (username.isNotEmpty) {
    return username;
  }

  final email = _readText(json['email']);
  if (email.isNotEmpty) {
    return email;
  }

  return 'Adopter HewanKu';
}

String _resolvePhotoUrl(Object? rawUser) {
  if (rawUser is Map<String, dynamic>) {
    return _readPhotoUrlFromMap(rawUser);
  }
  if (rawUser is Map) {
    return _readPhotoUrlFromMap(Map<String, dynamic>.from(rawUser));
  }
  return '';
}

String _readPhotoUrlFromMap(Map<String, dynamic> json) {
  final candidates = <Object?>[
    json['urlFoto'],
    json['foto'],
    json['photoUrl'],
    json['imageUrl'],
    json['avatar'],
  ];

  for (final candidate in candidates) {
    final value = _readText(candidate);
    if (value.isNotEmpty) {
      return value;
    }
  }

  return '';
}

String _formatDate(String rawDate) {
  final parsed = DateTime.tryParse(rawDate.trim());
  if (parsed == null) {
    return rawDate.trim().isEmpty ? '-' : rawDate.trim();
  }

  final day = parsed.day.toString().padLeft(2, '0');
  final month = parsed.month.toString().padLeft(2, '0');
  final year = parsed.year;
  return '$day/$month/$year';
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

double _readDouble(Object? raw) {
  if (raw is double) {
    return raw;
  }
  if (raw is num) {
    return raw.toDouble();
  }
  if (raw is String) {
    return double.tryParse(raw.trim()) ?? 0;
  }
  return 0;
}

String _readText(Object? raw) => raw?.toString().trim() ?? '';
