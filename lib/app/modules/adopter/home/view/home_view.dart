import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/widgets/app_loading_dialog.dart';
import '../../../../common/widgets/app_snackbar.dart';
import '../../../../models/home/adopter_news_model.dart';
import '../../../../services/api/api_exception.dart';
import '../../../../services/home/adopter_home_service.dart';
import '../../../../services/home/adopter_news_service.dart';
import '../../adopsi/widgets/hewan_model.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/home_hero_banner.dart';
import '../widgets/home_category_section.dart';
import '../widgets/home_featured_section.dart';
import '../widgets/home_news_section.dart';

class HomeView extends StatefulWidget {
  final VoidCallback? onGoToAdopsi;
  final ValueChanged<String>? onGoToAdopsiCategory;
  final VoidCallback? onGoToAdopsiSearch;

  const HomeView({
    super.key,
    this.onGoToAdopsi,
    this.onGoToAdopsiCategory,
    this.onGoToAdopsiSearch,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<HewanModel> _featuredItems = const [];
  List<AdopterNewsArticleModel> _newsItems = const [];
  bool _featuredHasError = false;
  bool _newsHasError = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadHomeContent());
  }

  Future<void> _loadHomeContent() async {
    if (_isLoading || !mounted) {
      return;
    }

    _isLoading = true;
    AppLoadingDialog.show(context, message: 'Memuat beranda...');

    try {
      final featuredFuture = _loadFeaturedItems();
      final newsFuture = _loadNewsItems();
      final featuredResult = await featuredFuture;
      final newsResult = await newsFuture;

      if (!mounted) {
        return;
      }

      setState(() {
        _featuredItems = featuredResult.data;
        _featuredHasError = featuredResult.hasError;
        _newsItems = newsResult.data;
        _newsHasError = newsResult.hasError;
      });

      _showLoadMessage(featuredResult, newsResult);
    } finally {
      AppLoadingDialog.hide();
      _isLoading = false;
    }
  }

  Future<_HomeSectionResult<HewanModel>> _loadFeaturedItems() async {
    try {
      final items = await AdopterHomeService.instance.getFeaturedAnimals();
      if (items.isEmpty) {
        return const _HomeSectionResult(
          data: <HewanModel>[],
          hasError: true,
          message: 'Data hewan unggulan belum tersedia.',
          type: AppSnackbarType.warning,
        );
      }

      return _HomeSectionResult(data: items, hasError: false);
    } catch (error) {
      return _HomeSectionResult(
        data: const <HewanModel>[],
        hasError: true,
        message: _resolveErrorMessage(
          error,
          fallback: 'Gagal memuat data hewan unggulan.',
        ),
        type: _resolveErrorType(error),
      );
    }
  }

  Future<_HomeSectionResult<AdopterNewsArticleModel>> _loadNewsItems() async {
    try {
      final items = await AdopterNewsService.instance.getRandomNews();
      if (items.isEmpty) {
        return const _HomeSectionResult(
          data: <AdopterNewsArticleModel>[],
          hasError: true,
          message: 'Data berita terkini belum tersedia.',
          type: AppSnackbarType.warning,
        );
      }

      return _HomeSectionResult(data: items, hasError: false);
    } catch (error) {
      return _HomeSectionResult(
        data: const <AdopterNewsArticleModel>[],
        hasError: true,
        message: _resolveErrorMessage(
          error,
          fallback: 'Gagal memuat berita terkini.',
        ),
        type: _resolveErrorType(error),
      );
    }
  }

  void _showLoadMessage(
    _HomeSectionResult<HewanModel> featuredResult,
    _HomeSectionResult<AdopterNewsArticleModel> newsResult,
  ) {
    if (!mounted) {
      return;
    }

    final issueResults = <_HomeSectionResult<Object>>[
      if (featuredResult.hasError)
        _HomeSectionResult<Object>(
          data: const <Object>[],
          hasError: true,
          message: featuredResult.message,
          type: featuredResult.type,
        ),
      if (newsResult.hasError)
        _HomeSectionResult<Object>(
          data: const <Object>[],
          hasError: true,
          message: newsResult.message,
          type: newsResult.type,
        ),
    ];

    if (issueResults.isEmpty) {
      return;
    }

    if (issueResults.length == 1) {
      final item = issueResults.first;
      AppSnackbar.show(
        context,
        message: item.message ?? 'Sebagian data beranda gagal dimuat.',
        type: item.type ?? AppSnackbarType.warning,
      );
      return;
    }

    final type = issueResults.any((item) => item.type == AppSnackbarType.error)
        ? AppSnackbarType.error
        : AppSnackbarType.warning;
    AppSnackbar.show(
      context,
      message: 'Sebagian data beranda gagal dimuat. Coba muat ulang lagi.',
      type: type,
    );
  }

  String _resolveErrorMessage(Object error, {required String fallback}) {
    if (error is ApiException) {
      return error.message;
    }

    return fallback;
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
          HomeSearchBar(onTap: widget.onGoToAdopsiSearch),
          SizedBox(height: 12.h),
          HomeHeroBanner(onAdopsiTap: widget.onGoToAdopsi),
          SizedBox(height: 28.h),
          HomeCategorySection(onCategoryTap: widget.onGoToAdopsiCategory),
          SizedBox(height: 28.h),
          HomeFeaturedSection(
            items: _featuredItems,
            hasError: _featuredHasError,
            onRetry: _loadHomeContent,
          ),
          SizedBox(height: 28.h),
          HomeNewsSection(
            items: _newsItems,
            hasError: _newsHasError,
            onRetry: _loadHomeContent,
          ),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }
}

class _HomeSectionResult<T> {
  final List<T> data;
  final bool hasError;
  final String? message;
  final AppSnackbarType? type;

  const _HomeSectionResult({
    required this.data,
    required this.hasError,
    this.message,
    this.type,
  });
}
