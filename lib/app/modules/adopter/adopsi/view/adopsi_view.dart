import 'package:flutter/material.dart';

import '../../../../common/widgets/app_loading_dialog.dart';
import '../../../../common/widgets/app_snackbar.dart';
import '../../../../models/home/adopter_animal_filter_request_model.dart';
import '../../../../services/api/api_exception.dart';
import '../../../../services/home/adopter_home_service.dart';
import '../../home/widgets/home_section_placeholder.dart';
import 'adopsi_navigation_controller.dart';
import '../widgets/adopsi_featured_section.dart';
import '../widgets/adopsi_filter_chips.dart';
import '../widgets/adopsi_filter_hewan.dart';
import '../widgets/adopsi_list_section.dart';
import '../widgets/adopsi_results_list.dart';
import '../widgets/adopsi_search_bar.dart';
import '../widgets/hewan_model.dart';

class AdopsiView extends StatefulWidget {
  const AdopsiView({super.key});

  @override
  State<AdopsiView> createState() => _AdopsiViewState();
}

class _AdopsiViewState extends State<AdopsiView> {
  final TextEditingController _searchController = TextEditingController();

  List<HewanModel> _recommendedItems = const [];
  List<HewanModel> _popularItems = const [];
  List<HewanModel> _topRatedItems = const [];
  List<HewanModel> _searchSourceItems = const [];
  List<HewanModel> _searchResults = const [];
  List<HewanModel> _filteredItems = const [];
  List<String> _availableCategories = const [];
  bool _recommendedHasError = false;
  bool _popularHasError = false;
  bool _topRatedHasError = false;
  bool _filterHasError = false;
  bool _isLoading = false;
  bool _isResettingSearchInput = false;
  String _searchQuery = '';
  String? _selectedFilterJenis;
  String? _queuedHomeCategory;
  int _filterHargaMin = -1;
  int _filterHargaMax = -1;

  bool get _hasActiveFilter =>
      _normalizedValue(_selectedFilterJenis) != null || _filterHargaMin >= 0 || _filterHargaMax >= 0;

  bool get _hasActiveAdvancedFilter => _filterHargaMin >= 0 || _filterHargaMax >= 0;

  bool get _isSearchMode => _searchQuery.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    AdopsiNavigationController.categoryRequest.addListener(_onHomeCategoryRequest);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadAnimalSections());
  }

  @override
  void dispose() {
    AdopsiNavigationController.categoryRequest.removeListener(_onHomeCategoryRequest);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadAnimalSections() async {
    if (_isLoading || !mounted) {
      return;
    }

    _isLoading = true;
    AppLoadingDialog.show(context, message: 'Memuat daftar adopsi...');

    try {
      final sections = await AdopterHomeService.instance.getAnimalSections();
      final recommendedItems = sections.recommendedAnimals;
      final popularItems = sections.featuredAnimals;
      final topRatedItems = sections.topRatedAnimals;

      if (!mounted) {
        return;
      }

      setState(() {
        _recommendedItems = recommendedItems;
        _popularItems = popularItems;
        _topRatedItems = topRatedItems;
        _searchSourceItems = recommendedItems;
        _availableCategories = _collectCategories(recommendedItems, popularItems, topRatedItems);
        _recommendedHasError = recommendedItems.isEmpty;
        _popularHasError = popularItems.isEmpty;
        _topRatedHasError = topRatedItems.isEmpty;
      });

      final emptySections = <String>[
        if (recommendedItems.isEmpty) 'rekomendasi',
        if (popularItems.isEmpty) 'hewan popular',
        if (topRatedItems.isEmpty) 'rating tertinggi',
      ];

      if (emptySections.isNotEmpty) {
        AppSnackbar.show(
          context,
          message: emptySections.length == 3 ? 'Data adopsi belum tersedia.' : 'Sebagian data adopsi belum tersedia.',
          type: AppSnackbarType.warning,
        );
      }
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _recommendedItems = const [];
        _popularItems = const [];
        _topRatedItems = const [];
        _searchSourceItems = const [];
        _availableCategories = const [];
        _recommendedHasError = true;
        _popularHasError = true;
        _topRatedHasError = true;
      });

      AppSnackbar.show(context, message: _resolveErrorMessage(error), type: _resolveErrorType(error));
    } finally {
      AppLoadingDialog.hide();
      _isLoading = false;

      final queuedHomeCategory = _queuedHomeCategory;
      if (mounted && queuedHomeCategory != null) {
        _queuedHomeCategory = null;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _applyHomeCategoryFilter(queuedHomeCategory);
          }
        });
      }
    }
  }

  void _onHomeCategoryRequest() {
    final request = AdopsiNavigationController.categoryRequest.value;
    final category = _normalizedValue(request?.category);
    if (category == null || !mounted) {
      return;
    }

    if (_isLoading) {
      _queuedHomeCategory = category;
      return;
    }

    _applyHomeCategoryFilter(category);
  }

  Future<void> _applyHomeCategoryFilter(String category) async {
    if (!_availableCategories.any((item) => item.trim().toLowerCase() == category.toLowerCase())) {
      setState(() {
        _availableCategories = [category, ..._availableCategories];
      });
    }

    await _applyFilter(jenis: category, hargaMin: -1, hargaMax: -1);
  }

  List<String> _collectCategories(List<HewanModel> a, List<HewanModel> b, List<HewanModel> c) {
    final categories = <String>[];
    final seen = <String>{};

    for (final item in [...a, ...b, ...c]) {
      final category = _normalizedValue(item.kategori);
      if (category == null) {
        continue;
      }

      final key = category.toLowerCase();
      if (seen.add(key)) {
        categories.add(category);
      }
    }

    return categories;
  }

  String? _normalizedValue(String? value) {
    final normalized = value?.trim();
    if (normalized == null || normalized.isEmpty) {
      return null;
    }
    return normalized;
  }

  String _normalizeKeyword(String value) => value.trim().toLowerCase();

  bool _matchesSearch(HewanModel item, String query) {
    final normalizedQuery = _normalizeKeyword(query);
    final category = _normalizeKeyword(item.kategori ?? '');
    final name = _normalizeKeyword(item.name);
    final tags = item.tags.map(_normalizeKeyword).join(' ');

    return name.contains(normalizedQuery) || category.contains(normalizedQuery) || tags.contains(normalizedQuery);
  }

  void _resetFilterState() {
    _selectedFilterJenis = null;
    _filterHargaMin = -1;
    _filterHargaMax = -1;
    _filteredItems = const [];
    _filterHasError = false;
  }

  void _resetSearchState() {
    _searchQuery = '';
    _searchResults = const [];
  }

  void _clearSearchInput() {
    if (_searchController.text.isEmpty) {
      return;
    }

    _isResettingSearchInput = true;
    _searchController.clear();
    _isResettingSearchInput = false;
  }

  void _restoreDefaultView() {
    _clearSearchInput();
    setState(() {
      _resetSearchState();
      _resetFilterState();
    });
  }

  void _onSearchChanged(String value) {
    if (_isResettingSearchInput) {
      return;
    }

    final query = value.trim();

    if (query.isEmpty) {
      setState(() {
        _searchQuery = '';
        _searchResults = const [];
      });
      return;
    }

    final results = _searchSourceItems.where((item) => _matchesSearch(item, query)).toList(growable: false);

    setState(() {
      _searchQuery = query;
      _searchResults = results;
      _resetFilterState();
    });
  }

  Future<void> _applyQuickCategoryFilter(String? category) async {
    if (category == null) {
      _restoreDefaultView();
      return;
    }

    await _applyFilter(jenis: category, hargaMin: -1, hargaMax: -1);
  }

  Future<void> _openFilterSheet() async {
    FocusScope.of(context).unfocus();

    final result = await showModalBottomSheet<AdopsiFilterResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AdopsiFilterHewan(
        categories: _availableCategories,
        initialJenis: _selectedFilterJenis,
        initialHargaMin: _filterHargaMin,
        initialHargaMax: _filterHargaMax,
      ),
    );

    if (!mounted || result == null) {
      return;
    }

    if (result.clear || !result.hasAnyFilter) {
      _restoreDefaultView();
      return;
    }

    await _applyFilter(jenis: result.jenis, hargaMin: result.hargaMin, hargaMax: result.hargaMax);
  }

  Future<void> _applyFilter({required String? jenis, required int hargaMin, required int hargaMax}) async {
    final request = AdopterAnimalFilterRequestModel(jenis: _normalizedValue(jenis), hargaMin: hargaMin, hargaMax: hargaMax);

    FocusScope.of(context).unfocus();
    AppLoadingDialog.show(context, message: 'Mencari hewan yang sesuai...');

    try {
      final items = await AdopterHomeService.instance.filterAnimals(request);

      if (!mounted) {
        return;
      }

      _clearSearchInput();
      setState(() {
        _resetSearchState();
        _selectedFilterJenis = request.jenis;
        _filterHargaMin = request.hargaMin;
        _filterHargaMax = request.hargaMax;
        _filteredItems = items;
        _filterHasError = false;
      });

      if (items.isEmpty) {
        AppSnackbar.show(context, message: 'Belum ada hewan yang sesuai dengan filter.', type: AppSnackbarType.warning);
      }
    } catch (error) {
      if (!mounted) {
        return;
      }

      _clearSearchInput();
      setState(() {
        _resetSearchState();
        _selectedFilterJenis = request.jenis;
        _filterHargaMin = request.hargaMin;
        _filterHargaMax = request.hargaMax;
        _filteredItems = const [];
        _filterHasError = true;
      });

      AppSnackbar.show(context, message: _resolveErrorMessage(error), type: _resolveErrorType(error));
    } finally {
      AppLoadingDialog.hide();
    }
  }

  Future<void> _retryCurrentFilter() async {
    await _applyFilter(jenis: _selectedFilterJenis, hargaMin: _filterHargaMin, hargaMax: _filterHargaMax);
  }

  Widget _buildContent() {
    if (_isSearchMode) {
      return AdopsiResultsList(
        title: 'Hasil Pencarian',
        subtitle: 'Menampilkan hasil untuk "$_searchQuery"',
        items: _searchResults,
        emptyTitle: 'Hewan tidak ditemukan.',
        emptyDescription: 'Coba gunakan kata kunci nama hewan atau kategori lain.',
        actionLabel: 'Reset',
        onActionTap: _restoreDefaultView,
      );
    }

    if (_hasActiveFilter) {
      if (_filterHasError) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: HomeSectionPlaceholder(
            icon: Icons.filter_alt_off_rounded,
            title: 'Filter hewan belum bisa dimuat.',
            description: 'Coba lagi untuk mengambil hasil filter terbaru.',
            onRetry: _retryCurrentFilter,
          ),
        );
      }

      return AdopsiResultsList(
        title: 'Hasil Filter',
        subtitle: 'Menampilkan semua hewan yang sesuai filter pilihanmu',
        items: _filteredItems,
        emptyTitle: 'Belum ada hasil filter.',
        emptyDescription: 'Ubah jenis atau rentang harga untuk melihat hasil lain.',
        actionLabel: 'Reset',
        onActionTap: _restoreDefaultView,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AdopsiFeaturedSection(items: _recommendedItems, hasError: _recommendedHasError, onRetry: _loadAnimalSections),
        const SizedBox(height: 24),
        AdopsiListSection(
          title: 'Hewan Popular',
          subtitle: 'Paling sering dilihat dan diminati adopter',
          items: _popularItems,
          hasError: _popularHasError,
          onRetry: _loadAnimalSections,
        ),
        const SizedBox(height: 24),
        AdopsiListSection(
          title: 'Hewan Rating Tinggi',
          subtitle: 'Pilihan hewan dengan rating terbaik',
          items: _topRatedItems,
          hasError: _topRatedHasError,
          onRetry: _loadAnimalSections,
        ),
      ],
    );
  }

  String _resolveErrorMessage(Object error) {
    if (error is ApiException) {
      return error.message;
    }
    return 'Gagal memuat data adopsi.';
  }

  AppSnackbarType _resolveErrorType(Object error) {
    if (error is ApiException) {
      final statusCode = error.statusCode;
      if (statusCode == null || statusCode >= 500) {
        return AppSnackbarType.error;
      }
      return AppSnackbarType.warning;
    }
    return AppSnackbarType.error;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdopsiSearchBar(controller: _searchController, onChanged: _onSearchChanged, onClear: _restoreDefaultView),
          AdopsiFilterChips(
            categories: _availableCategories,
            selectedCategory: _selectedFilterJenis,
            hasActiveAdvancedFilter: _hasActiveAdvancedFilter,
            onCategorySelected: (value) => _applyQuickCategoryFilter(value),
            onFilterTap: _openFilterSheet,
          ),
          const SizedBox(height: 20),
          _buildContent(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
