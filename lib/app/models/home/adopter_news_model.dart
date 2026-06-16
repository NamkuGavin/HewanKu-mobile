class AdopterNewsModel {
  final List<AdopterNewsArticleModel> articles;

  const AdopterNewsModel({required this.articles});

  factory AdopterNewsModel.fromJson(Object? rawData) {
    final items = rawData is List
        ? rawData
              .whereType<Object?>()
              .map((item) {
                if (item is Map<String, dynamic>) {
                  return AdopterNewsArticleModel.fromJson(item);
                }
                if (item is Map) {
                  return AdopterNewsArticleModel.fromJson(Map<String, dynamic>.from(item));
                }
                return null;
              })
              .whereType<AdopterNewsArticleModel>()
              .toList(growable: false)
        : const <AdopterNewsArticleModel>[];

    return AdopterNewsModel(articles: items);
  }
}

class AdopterNewsArticleModel {
  final int id;
  final DateTime publishedAt;
  final String title;
  final String description;
  final String link;
  final String imageUrl;
  final String category;

  const AdopterNewsArticleModel({
    required this.id,
    required this.publishedAt,
    required this.title,
    required this.description,
    required this.link,
    required this.imageUrl,
    required this.category,
  });

  factory AdopterNewsArticleModel.fromJson(Map<String, dynamic> json) {
    final yoast = _readMap(json['yoast_head_json']);
    final title = _cleanText(_readMap(json['title'])['rendered']);
    final content = _cleanText(_readMap(json['content'])['rendered']);

    final fallbackDescription = _cleanText(_readMap(json['excerpt'])['rendered']);
    final description = _cleanText(yoast['description']).isNotEmpty
        ? _cleanText(yoast['description'])
        : (fallbackDescription.isNotEmpty ? fallbackDescription : content);

    return AdopterNewsArticleModel(
      id: _readInt(json['id']),
      publishedAt: _readDate(json['date']),
      title: _normalizeText(title),
      description: _normalizeText(description),
      link: _cleanText(json['link']),
      imageUrl: _extractImageUrl(json, yoast, content),
      category: _extractCategory(yoast),
    );
  }

  String get formattedDate {
    const monthNames = <String>[
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

    final month = monthNames[publishedAt.month - 1];
    return '${publishedAt.day} $month ${publishedAt.year}';
  }
}

Map<String, dynamic> _readMap(Object? raw) {
  if (raw is Map<String, dynamic>) {
    return raw;
  }
  if (raw is Map) {
    return Map<String, dynamic>.from(raw);
  }
  return const <String, dynamic>{};
}

List<Object?> _readList(Object? raw) {
  if (raw is List) {
    return raw.whereType<Object?>().toList(growable: false);
  }
  return const <Object?>[];
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

DateTime _readDate(Object? raw) {
  if (raw is String && raw.trim().isNotEmpty) {
    return DateTime.tryParse(raw.trim()) ?? DateTime.fromMillisecondsSinceEpoch(0);
  }
  return DateTime.fromMillisecondsSinceEpoch(0);
}

String _cleanText(Object? raw) {
  return raw?.toString().trim() ?? '';
}

String _normalizeText(String raw) {
  if (raw.isEmpty) {
    return raw;
  }

  final withoutTags = raw.replaceAll(RegExp(r'<[^>]*>'), ' ');
  return withoutTags
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&amp;', '&')
      .replaceAll('&quot;', '"')
      .replaceAll('&#8217;', '\'')
      .replaceAll('&#8216;', '\'')
      .replaceAll('&#8220;', '"')
      .replaceAll('&#8221;', '"')
      .replaceAll('&#8230;', '...')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

String _extractImageUrl(Map<String, dynamic> json, Map<String, dynamic> yoast, String content) {
  final ogImages = _readList(yoast['og_image']);
  for (final item in ogImages) {
    final map = _readMap(item);
    final url = _cleanText(map['url']);
    if (url.isNotEmpty) {
      return url;
    }
  }

  final contentMatch = RegExp(r'src="([^"]+)"').firstMatch(content);
  if (contentMatch != null) {
    return _cleanText(contentMatch.group(1));
  }

  final guidUrl = _cleanText(_readMap(json['guid'])['rendered']);
  return guidUrl;
}

String _extractCategory(Map<String, dynamic> yoast) {
  final schema = _readMap(yoast['schema']);
  final graph = _readList(schema['@graph']);

  for (final item in graph) {
    final map = _readMap(item);
    final sections = _readList(map['articleSection']);
    if (sections.isNotEmpty) {
      final category = _cleanText(sections.first);
      if (category.isNotEmpty) {
        return category;
      }
    }
  }

  return 'Berita';
}
