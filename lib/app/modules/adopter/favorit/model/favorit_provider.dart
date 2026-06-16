import 'package:flutter/material.dart';

import '../../../../services/favorite/adopter_favorite_service.dart';
import '../../adopsi/widgets/hewan_model.dart';
import 'favorit_item.dart';

class FavoritController extends ValueNotifier<List<FavoritItem>> {
  FavoritController() : super(const <FavoritItem>[]);

  bool _isLoading = false;
  bool _hasLoaded = false;
  bool _hasLoadError = false;
  final Set<int> _busyIds = <int>{};

  bool get isLoading => _isLoading;
  bool get hasLoaded => _hasLoaded;
  bool get hasLoadError => _hasLoadError;

  bool isBusy(int animalId) => _busyIds.contains(animalId);

  bool containsAnimal(HewanModel hewan) {
    if (hewan.id > 0) {
      return value.any((item) => item.id == hewan.id);
    }
    return value.any((item) => item.namaHewan == hewan.name);
  }

  Future<void> loadFavorites({bool force = false}) async {
    if (_isLoading) {
      return;
    }
    if (_hasLoaded && !force) {
      return;
    }

    _isLoading = true;
    _hasLoadError = false;
    notifyListeners();

    try {
      final items = await AdopterFavoriteService.instance.getFavorites();
      value = items;
      _hasLoaded = true;
      _hasLoadError = false;
    } catch (_) {
      _hasLoaded = true;
      _hasLoadError = true;
      notifyListeners();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addFavorite(HewanModel hewan) async {
    if (hewan.id <= 0 || _busyIds.contains(hewan.id)) {
      return;
    }

    _busyIds.add(hewan.id);
    notifyListeners();

    try {
      await AdopterFavoriteService.instance.addFavorite(hewan.id);
      final item = FavoritItem.fromHewanModel(hewan);
      if (!value.any((favorite) => favorite.id == item.id)) {
        value = <FavoritItem>[item, ...value];
      }
      _hasLoaded = true;
      _hasLoadError = false;
    } finally {
      _busyIds.remove(hewan.id);
      notifyListeners();
    }
  }

  Future<void> removeFavorite(HewanModel hewan) async {
    if (hewan.id <= 0 || _busyIds.contains(hewan.id)) {
      return;
    }

    _busyIds.add(hewan.id);
    notifyListeners();

    try {
      await AdopterFavoriteService.instance.removeFavorite(hewan.id);
      value = value.where((item) => item.id != hewan.id).toList(growable: false);
      _hasLoaded = true;
      _hasLoadError = false;
    } finally {
      _busyIds.remove(hewan.id);
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(HewanModel hewan) async {
    if (containsAnimal(hewan)) {
      await removeFavorite(hewan);
      return;
    }

    await addFavorite(hewan);
  }

  void clearFavorites() {
    _isLoading = false;
    _hasLoaded = false;
    _hasLoadError = false;
    _busyIds.clear();
    value = const <FavoritItem>[];
    notifyListeners();
  }
}

class FavoritProvider extends InheritedNotifier<FavoritController> {
  const FavoritProvider({super.key, required super.notifier, required super.child});

  static FavoritController of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<FavoritProvider>();
    assert(provider != null, 'FavoritProvider tidak ditemukan di widget tree.');
    return provider!.notifier!;
  }

  static Future<void> load(BuildContext context, {bool force = false}) {
    return of(context).loadFavorites(force: force);
  }

  static Future<void> tambah(BuildContext context, HewanModel hewan) {
    return of(context).addFavorite(hewan);
  }

  static Future<void> hapus(BuildContext context, HewanModel hewan) {
    return of(context).removeFavorite(hewan);
  }

  static Future<void> toggle(BuildContext context, HewanModel hewan) {
    return of(context).toggleFavorite(hewan);
  }

  static bool isFavorit(BuildContext context, HewanModel hewan) {
    return of(context).containsAnimal(hewan);
  }

  static void clear(BuildContext context) {
    of(context).clearFavorites();
  }
}
