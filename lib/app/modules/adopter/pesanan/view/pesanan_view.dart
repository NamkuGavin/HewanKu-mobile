import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/widgets/app_snackbar.dart';
import '../../../../models/order/adopter_order_history_model.dart';
import '../../../../services/api/api_exception.dart';
import '../../../../services/order/adopter_order_service.dart';
import '../../home/widgets/home_section_placeholder.dart';
import '../../navbar/view/navbar_controller.dart';
import '../model/pesanan_terakhir_item.dart';
import '../widgets/pesanan_empty_state.dart';
import '../widgets/pesanan_saya_card.dart';
import '../widgets/pesanan_tab_switcher.dart';
import '../widgets/pesanan_terakhir_card.dart';
import '../widgets/rating_dan_ulasan_dialog.dart';
import 'pesanan_tab_controller.dart';

class PesananView extends StatefulWidget {
  const PesananView({super.key});

  @override
  State<PesananView> createState() => _PesananViewState();
}

class _PesananViewState extends State<PesananView> {
  int _selectedTab = 0;
  List<AdopterOrderHistoryModel> _orders = const <AdopterOrderHistoryModel>[];
  bool _isLoading = false;
  bool _hasLoaded = false;
  bool _hasLoadError = false;

  @override
  void initState() {
    super.initState();
    _selectedTab = PesananTabController.selectedTab.value;
    PesananTabController.selectedTab.addListener(_onTabControllerChange);
    PesananTabController.refreshTick.addListener(_onRefreshRequested);
    NavbarController.tabIndex.addListener(_onNavbarChange);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadOrders());
  }

  @override
  void dispose() {
    PesananTabController.selectedTab.removeListener(_onTabControllerChange);
    PesananTabController.refreshTick.removeListener(_onRefreshRequested);
    NavbarController.tabIndex.removeListener(_onNavbarChange);
    super.dispose();
  }

  List<AdopterOrderHistoryModel> get _pesananSaya => _orders
      .where((item) => item.shouldAppearInActiveOrders)
      .toList(growable: false);

  List<PesananTerakhirItem> get _pesananTerakhir => _orders
      .where((item) => item.shouldAppearInHistory)
      .map((item) => item.toPesananTerakhirItem())
      .toList(growable: false);

  void _onTabControllerChange() {
    if (!mounted) {
      return;
    }
    setState(() => _selectedTab = PesananTabController.selectedTab.value);
  }

  void _onRefreshRequested() {
    _loadOrders(force: true);
  }

  void _onNavbarChange() {
    if (NavbarController.tabIndex.value == 2) {
      _loadOrders(force: true);
    }
  }

  Future<void> _loadOrders({bool force = false}) async {
    if (_isLoading || (_hasLoaded && !force) || !mounted) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final items = await AdopterOrderService.instance.getOrders();
      if (!mounted) {
        return;
      }

      setState(() {
        _orders = items;
        _hasLoaded = true;
        _hasLoadError = false;
      });
    } catch (error) {
      if (!mounted || _isUnauthorized(error)) {
        return;
      }

      setState(() {
        _orders = const <AdopterOrderHistoryModel>[];
        _hasLoaded = true;
        _hasLoadError = true;
      });

      AppSnackbar.show(
        context,
        message: _resolveErrorMessage(error),
        type: _resolveErrorType(error),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      } else {
        _isLoading = false;
      }
    }
  }

  bool _isUnauthorized(Object error) {
    return error is ApiException && error.isUnauthorized;
  }

  String _resolveErrorMessage(Object error) {
    if (error is ApiException) {
      return error.message;
    }
    return 'Gagal memuat data pesanan.';
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
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 10.h),
              child: Center(
                child: Text(
                  'Pesanan',
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            PesananTabSwitcher(
              selectedIndex: _selectedTab,
              onTabChanged: (int index) {
                setState(() => _selectedTab = index);
                PesananTabController.selectedTab.value = index;
              },
            ),
            SizedBox(height: 20.h),
            if (_isLoading && _hasLoaded)
              const LinearProgressIndicator(
                minHeight: 2,
                color: Color(0xFFF87537),
                backgroundColor: Color(0xFFFFE3D6),
              ),
            Expanded(
              child: _selectedTab == 0
                  ? _buildPesananSayaTab()
                  : _buildPesananTerakhirTab(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPesananSayaTab() {
    if (_isLoading && !_hasLoaded) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFF87537)),
      );
    }

    if (_hasLoadError && _pesananSaya.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: HomeSectionPlaceholder(
          icon: Icons.receipt_long_rounded,
          title: 'Pesanan aktif belum bisa dimuat.',
          description:
              'Coba lagi untuk mengambil status form dan pembayaran terbaru.',
          onRetry: () => _loadOrders(force: true),
        ),
      );
    }

    if (_pesananSaya.isEmpty) {
      return RefreshIndicator(
        color: const Color(0xFFF87537),
        onRefresh: () => _loadOrders(force: true),
        child: const SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: 520,
            child: PesananEmptyState(
              title: 'Belum ada pesanan aktif',
              description:
                  'Pesanan yang masih menunggu persetujuan atau pembayaran akan muncul di sini.',
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      color: const Color(0xFFF87537),
      onRefresh: () => _loadOrders(force: true),
      child: ListView.separated(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        padding: EdgeInsets.only(bottom: 28.h),
        itemCount: _pesananSaya.length,
        separatorBuilder: (_, _) => SizedBox(height: 16.h),
        itemBuilder: (BuildContext context, int index) {
          return PesananSayaCard(item: _pesananSaya[index]);
        },
      ),
    );
  }

  Widget _buildPesananTerakhirTab() {
    if (_isLoading && !_hasLoaded) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFF87537)),
      );
    }

    if (_hasLoadError && _pesananTerakhir.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: HomeSectionPlaceholder(
          icon: Icons.inventory_2_outlined,
          title: 'Riwayat pesanan belum bisa dimuat.',
          description:
              'Coba lagi untuk mengambil pesanan berhasil atau gagal terbaru.',
          onRetry: () => _loadOrders(force: true),
        ),
      );
    }

    if (_pesananTerakhir.isEmpty) {
      return RefreshIndicator(
        color: const Color(0xFFF87537),
        onRefresh: () => _loadOrders(force: true),
        child: const SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: 520,
            child: PesananEmptyState(
              title: 'Belum ada riwayat pesanan',
              description:
                  'Riwayat dengan pembayaran berhasil, pembayaran gagal, atau form yang ditolak akan muncul di sini.',
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      color: const Color(0xFFF87537),
      onRefresh: () => _loadOrders(force: true),
      child: ListView.separated(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        padding: EdgeInsets.only(bottom: 28.h),
        itemCount: _pesananTerakhir.length,
        separatorBuilder: (_, _) => SizedBox(height: 20.h),
        itemBuilder: (BuildContext context, int index) => PesananTerakhirCard(
          item: _pesananTerakhir[index],
          onRatingTap: _pesananTerakhir[index].canReview
              ? () async {
                  final item = _pesananTerakhir[index];
                  final submitted = await RatingUlasanDialog.show(
                    context,
                    orderId: item.orderId,
                    animalId: item.animalId,
                    animalName: item.animalName,
                    namaShelter: item.namaShelter,
                  );
                  if (submitted == true && mounted) {
                    await _loadOrders(force: true);
                  }
                }
              : null,
        ),
      ),
    );
  }
}
