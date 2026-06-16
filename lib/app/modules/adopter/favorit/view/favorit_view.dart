import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../common/utils/app_navigator.dart';
import '../../../../common/widgets/app_snackbar.dart';
import '../../../../services/api/api_exception.dart';
import '../../adopsi/view/adopsi_detail_hewan.dart';
import '../model/favorit_item.dart';
import '../model/favorit_provider.dart';
import '../widgets/favorit_empty_state.dart';
import '../widgets/favorit_item_card.dart';

class FavoritView extends StatefulWidget {
  const FavoritView({super.key});

  @override
  State<FavoritView> createState() => _FavoritViewState();
}

class _FavoritViewState extends State<FavoritView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadFavorites());
  }

  Future<void> _loadFavorites({bool force = true}) async {
    try {
      await FavoritProvider.load(context, force: force);
    } catch (error) {
      if (!mounted || _isUnauthorized(error)) {
        return;
      }

      AppSnackbar.show(context, message: _resolveErrorMessage(error), type: _resolveErrorType(error));
    }
  }

  bool _isUnauthorized(Object error) {
    return error is ApiException && error.isUnauthorized;
  }

  String _resolveErrorMessage(Object error) {
    if (error is ApiException) {
      return error.message;
    }

    return 'Gagal memuat daftar favorit.';
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
    final controller = FavoritProvider.of(context);
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).primaryColor;

    return ValueListenableBuilder<List<FavoritItem>>(
      valueListenable: controller,
      builder: (context, favoritList, _) {
        final isLoading = controller.isLoading && favoritList.isEmpty;
        final sortedList = favoritList.reversed.toList(growable: false);
        final isEmpty = sortedList.isEmpty;

        return Scaffold(
          backgroundColor: const Color(0xFFFFFBF8),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: primaryColor, size: 20.sp),
            ),
            title: Text(
              'Favorit Saya',
              style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700, color: Colors.black),
            ),
          ),
          body: isLoading
              ? const Center(child: CircularProgressIndicator(color: Color(0xFFF87537)))
              : isEmpty
              ? const FavoritEmptyState()
              : RefreshIndicator(
                  color: const Color(0xFFF87537),
                  onRefresh: () => _loadFavorites(force: true),
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 18.h),
                          child: _FavoritSummaryCard(count: sortedList.length),
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 28.h),
                        sliver: SliverList.separated(
                          itemCount: sortedList.length,
                          itemBuilder: (context, index) {
                            final item = sortedList[index];
                            return FavoritItemCard(
                              item: item,
                              isHighlighted: index == 0,
                              onTap: () => AppNavigator.push(context, AdopsiDetailHewanView(hewan: item.hewan)),
                            );
                          },
                          separatorBuilder: (_, _) => SizedBox(height: 14.h),
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}

class _FavoritSummaryCard extends StatelessWidget {
  final int count;

  const _FavoritSummaryCard({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 18.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFF4EC), Color(0xFFFFFBF7)],
        ),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: const Color(0xFFF3DED1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42.w,
                height: 42.w,
                decoration: const BoxDecoration(color: Color(0xFFFFE7DD), shape: BoxShape.circle),
                child: Icon(Icons.favorite_rounded, color: Color(0xFFF87537), size: 20.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Koleksi Favoritmu',
                      style: GoogleFonts.poppins(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      '$count hewan tersimpan dan siap kamu lihat kembali.',
                      style: GoogleFonts.poppins(fontSize: 11.sp, color: const Color(0xFF7C7C7C), height: 1.45),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: const Color(0xFFF1E8E1)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded, size: 16.sp, color: const Color(0xFFF87537)),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'Penghapusan favorit dilakukan dari halaman detail hewan.',
                    style: GoogleFonts.poppins(fontSize: 11.sp, color: const Color(0xFF6F6F6F), height: 1.45),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
