import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/utils/app_navigator.dart';
import '../../../../common/widgets/app_net_image.dart';
import '../../../../common/widgets/app_snackbar.dart';
import '../../../../models/order/adopter_order_history_model.dart';
import '../../../../services/api/api_exception.dart';
import '../../../../services/order/adopter_order_service.dart';
import '../../../../services/order/adopter_payment_session_service.dart';
import 'pesanan_payment_result_view.dart';

class PesananProgressDetailView extends StatefulWidget {
  final int orderId;
  final AdopterOrderHistoryModel initialOrder;

  const PesananProgressDetailView({
    super.key,
    required this.orderId,
    required this.initialOrder,
  });

  @override
  State<PesananProgressDetailView> createState() =>
      _PesananProgressDetailViewState();
}

class _PesananProgressDetailViewState extends State<PesananProgressDetailView>
    with WidgetsBindingObserver {
  late AdopterOrderHistoryModel _order;
  bool _isRefreshing = false;
  bool _hasLoadError = false;
  bool _shouldRefreshOnResume = false;
  bool _hasOpenedPaymentFlow = false;
  bool _resultPresented = false;
  int _activeTab = 0;
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _order = widget.initialOrder;
    WidgetsBinding.instance.addObserver(this);
    _startTicker();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshOrder(showErrorSnackbar: false);
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _shouldRefreshOnResume) {
      _shouldRefreshOnResume = false;
      _refreshOrder(showErrorSnackbar: false);
    }
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) {
        return;
      }

      if (_order.hasPaymentTimer && _order.isPaymentPending) {
        setState(() {});

        if (_order.isPaymentExpiredLocally) {
          _refreshOrder(showErrorSnackbar: false);
        }
      }
    });
  }

  Future<void> _refreshOrder({bool showErrorSnackbar = true}) async {
    if (_isRefreshing) {
      return;
    }

    setState(() => _isRefreshing = true);

    try {
      final latest = await AdopterOrderService.instance.getOrderById(
        widget.orderId,
      );
      if (!mounted) {
        return;
      }

      if (latest == null) {
        setState(() => _hasLoadError = true);
        if (showErrorSnackbar) {
          AppSnackbar.show(
            context,
            message: 'Data pesanan tidak ditemukan.',
            type: AppSnackbarType.warning,
          );
        }
        return;
      }

      setState(() {
        _order = latest;
        _hasLoadError = false;
        if (_activeTab == 1 && !_order.canAccessPaymentTab) {
          _activeTab = 0;
        }
      });

      _maybePresentPaymentResult();
    } catch (error) {
      if (!mounted || _isUnauthorized(error)) {
        return;
      }

      setState(() => _hasLoadError = true);
      if (showErrorSnackbar) {
        AppSnackbar.show(
          context,
          message: _resolveErrorMessage(error),
          type: _resolveErrorType(error),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isRefreshing = false);
      } else {
        _isRefreshing = false;
      }
    }
  }

  void _maybePresentPaymentResult() {
    if (!mounted || _resultPresented || !_hasOpenedPaymentFlow) {
      return;
    }

    if (_order.isPaymentSuccess) {
      _resultPresented = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (_) => PesananPaymentResultView(
              isSuccess: true,
              orderCode: _order.orderCodeLabel,
              title: 'Pembayaran Berhasil',
              description:
                  'Pembayaran Midtrans sudah terverifikasi. Pesanan kamu dipindahkan ke riwayat pesanan terakhir.',
            ),
          ),
        );
      });
      return;
    }

    if (_order.isPaymentExpiredLocally || _order.hasPaymentIssue) {
      _resultPresented = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (_) => PesananPaymentResultView(
              isSuccess: false,
              orderCode: _order.orderCodeLabel,
              title: 'Pembayaran Gagal',
              description: _order.isPaymentExpiredLocally
                  ? 'Waktu pembayaran 15 menit telah habis. Pesanan ini ditutup sebagai gagal.'
                  : 'Status pembayaran dari Midtrans menunjukkan transaksi tidak berhasil diselesaikan.',
            ),
          ),
        );
      });
    }
  }

  bool _isUnauthorized(Object error) {
    return error is ApiException && error.isUnauthorized;
  }

  String _resolveErrorMessage(Object error) {
    if (error is ApiException) {
      return error.message;
    }
    return 'Gagal memuat detail progres pesanan.';
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

  Future<void> _openPaymentLink() async {
    final link = _order.paymentLinkUrl;
    if (link.isEmpty) {
      AppSnackbar.show(
        context,
        message: 'Link pembayaran belum tersedia dari server.',
        type: AppSnackbarType.warning,
      );
      return;
    }

    final uri = Uri.tryParse(link);
    if (uri == null) {
      AppSnackbar.show(
        context,
        message: 'Link pembayaran tidak valid.',
        type: AppSnackbarType.error,
      );
      return;
    }

    await AdopterPaymentSessionService.instance.startSession(
      orderId: _order.id,
    );
    final latest = await AdopterOrderService.instance.getOrderById(_order.id);
    if (mounted && latest != null) {
      setState(() {
        _order = latest;
        _hasOpenedPaymentFlow = true;
        _resultPresented = false;
      });
    } else {
      _hasOpenedPaymentFlow = true;
      _resultPresented = false;
    }

    _shouldRefreshOnResume = true;
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && mounted) {
      _shouldRefreshOnResume = false;
      AppSnackbar.show(
        context,
        message: 'Gagal membuka halaman pembayaran.',
        type: AppSnackbarType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(10.w, 12.h, 18.w, 10.h),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () => AppNavigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      color: const Color(0xFFF87537),
                      size: 24.sp,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Detail Progress Pesanan',
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _isRefreshing ? null : () => _refreshOrder(),
                    icon: Icon(
                      Icons.refresh_rounded,
                      color: const Color(0xFFF87537),
                      size: 22.sp,
                    ),
                  ),
                ],
              ),
            ),
            if (_isRefreshing)
              const LinearProgressIndicator(
                minHeight: 2,
                color: Color(0xFFF87537),
                backgroundColor: Color(0xFFFFE3D6),
              ),
            Expanded(
              child: RefreshIndicator(
                color: const Color(0xFFF87537),
                onRefresh: () => _refreshOrder(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 28.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _OrderSummaryCard(order: _order),
                      if (_hasLoadError) ...<Widget>[
                        SizedBox(height: 12.h),
                        const _InlineWarningCard(
                          message:
                              'Menampilkan data terakhir yang tersedia. Tarik ke bawah untuk mencoba memuat ulang.',
                        ),
                      ],
                      SizedBox(height: 18.h),
                      Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F0F0),
                          borderRadius: BorderRadius.circular(999.r),
                        ),
                        child: Row(
                          children: <Widget>[
                            _DetailTabButton(
                              label: 'Status Form',
                              isActive: _activeTab == 0,
                              isEnabled: true,
                              onTap: () => setState(() => _activeTab = 0),
                            ),
                            _DetailTabButton(
                              label: 'Status Pembayaran',
                              isActive: _activeTab == 1,
                              isEnabled: _order.canAccessPaymentTab,
                              onTap: () => setState(() => _activeTab = 1),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 18.h),
                      if (_activeTab == 0)
                        _FormProgressSection(order: _order)
                      else
                        _PaymentProgressSection(
                          order: _order,
                          onOpenPayment: _openPaymentLink,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderSummaryCard extends StatelessWidget {
  final AdopterOrderHistoryModel order;

  const _OrderSummaryCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final hewan = order.hewanModel;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: SizedBox(
                  width: 88.w,
                  height: 88.h,
                  child: AppNetImage(
                    url: hewan.imageUrl,
                    fallbackColor: Color(hewan.fallbackColorValue),
                  ),
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      hewan.name,
                      style: textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      order.shelterLabel,
                      style: textTheme.labelLarge?.copyWith(
                        color: const Color(0xFF7A7A7A),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: <Widget>[
                        _SummaryChip(
                          label: order.processStatusLabel,
                          foregroundColor: order.processStatusColor,
                          backgroundColor: order.processStatusColor.withValues(
                            alpha: 0.12,
                          ),
                        ),
                        _SummaryChip(
                          label: hewan.kategori ?? '-',
                          foregroundColor: const Color(0xFF555555),
                          backgroundColor: const Color(0xFFF3F3F3),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8F3),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: const Color(0xFFF8D7C5)),
            ),
            child: Wrap(
              runSpacing: 12.h,
              spacing: 12.w,
              children: <Widget>[
                _SummaryInfo(label: 'ID Order', value: order.orderCodeLabel),
                _SummaryInfo(label: 'Tanggal', value: order.orderDateLabel),
                _SummaryInfo(label: 'Total', value: order.totalBiayaLabel),
                _SummaryInfo(
                  label: 'Status Bayar',
                  value: order.paymentStatusLabel,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final String label;
  final Color foregroundColor;
  final Color backgroundColor;

  const _SummaryChip({
    required this.label,
    required this.foregroundColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        label,
        style: textTheme.labelMedium?.copyWith(
          color: foregroundColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _SummaryInfo extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryInfo({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      width: 150.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: textTheme.labelMedium?.copyWith(
              color: const Color(0xFF9E9E9E),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: textTheme.labelLarge?.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailTabButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final bool isEnabled;
  final VoidCallback onTap;

  const _DetailTabButton({
    required this.label,
    required this.isActive,
    required this.isEnabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: GestureDetector(
        onTap: isEnabled ? onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(999.r),
            border: isActive
                ? Border.all(color: const Color(0xFFF87537), width: 1.1)
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: textTheme.labelLarge?.copyWith(
              color: !isEnabled
                  ? const Color(0xFFBDBDBD)
                  : (isActive
                        ? const Color(0xFFF87537)
                        : const Color(0xFF8B8B8B)),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _FormProgressSection extends StatelessWidget {
  final AdopterOrderHistoryModel order;

  const _FormProgressSection({required this.order});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _ProgressCard(
          title: 'Status Form',
          subtitle: 'Progress persetujuan formulir adopsi oleh shelter.',
          steps: order.buildFormSteps(),
        ),
        SizedBox(height: 14.h),
        _ActivityCard(
          title: 'Order Activity',
          activities: order.buildFormActivities(),
        ),
      ],
    );
  }
}

class _PaymentProgressSection extends StatelessWidget {
  final AdopterOrderHistoryModel order;
  final Future<void> Function() onOpenPayment;

  const _PaymentProgressSection({
    required this.order,
    required this.onOpenPayment,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _ProgressCard(
          title: 'Status Pembayaran',
          subtitle: order.canAccessPaymentTab
              ? 'Progress pembayaran akan berubah mengikuti status Midtrans terbaru.'
              : 'Tab ini aktif setelah form adopsi diterima oleh shelter.',
          steps: order.buildPaymentSteps(),
        ),
        SizedBox(height: 14.h),
        _ActivityCard(
          title: 'Order Activity',
          activities: order.buildPaymentActivities(),
          emptyMessage:
              'Aktivitas pembayaran akan muncul setelah form diterima.',
        ),
        SizedBox(height: 14.h),
        _PaymentActionCard(order: order, onOpenPayment: onOpenPayment),
      ],
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<AdopterOrderProgressStepModel> steps;

  const _ProgressCard({
    required this.title,
    required this.subtitle,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 18.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            subtitle,
            style: textTheme.labelLarge?.copyWith(
              color: const Color(0xFF7A7A7A),
              height: 1.5,
            ),
          ),
          SizedBox(height: 16.h),
          ...List<Widget>.generate(steps.length, (int index) {
            return _ProgressStepRow(
              step: steps[index],
              isLast: index == steps.length - 1,
            );
          }),
        ],
      ),
    );
  }
}

class _ProgressStepRow extends StatelessWidget {
  final AdopterOrderProgressStepModel step;
  final bool isLast;

  const _ProgressStepRow({required this.step, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = _stepVisual(step.state);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 28.w,
          child: Column(
            children: <Widget>[
              Container(
                width: 20.w,
                height: 20.h,
                decoration: BoxDecoration(
                  color: scheme.dotColor,
                  shape: BoxShape.circle,
                ),
                child: scheme.icon == null
                    ? null
                    : Icon(scheme.icon, color: Colors.white, size: 11.sp),
              ),
              if (!isLast)
                Container(
                  width: 2.5,
                  height: 44.h,
                  margin: EdgeInsets.symmetric(vertical: 3.h),
                  color: scheme.lineColor,
                ),
            ],
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 1.h, bottom: isLast ? 0 : 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  step.title,
                  style: textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: scheme.textColor,
                  ),
                ),
                if (step.description != null &&
                    step.description!.trim().isNotEmpty) ...<Widget>[
                  SizedBox(height: 4.h),
                  Text(
                    step.description!,
                    style: textTheme.labelMedium?.copyWith(
                      color: const Color(0xFF8A8A8A),
                      height: 1.45,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StepVisualScheme {
  final Color dotColor;
  final Color lineColor;
  final Color textColor;
  final IconData? icon;

  const _StepVisualScheme({
    required this.dotColor,
    required this.lineColor,
    required this.textColor,
    required this.icon,
  });
}

_StepVisualScheme _stepVisual(AdopterOrderProgressState state) {
  switch (state) {
    case AdopterOrderProgressState.completed:
      return const _StepVisualScheme(
        dotColor: Color(0xFFF87537),
        lineColor: Color(0xFFF87537),
        textColor: Colors.black,
        icon: Icons.check,
      );
    case AdopterOrderProgressState.current:
      return const _StepVisualScheme(
        dotColor: Color(0xFFFBA81F),
        lineColor: Color(0xFFE0E0E0),
        textColor: Colors.black,
        icon: Icons.more_horiz_rounded,
      );
    case AdopterOrderProgressState.failed:
      return const _StepVisualScheme(
        dotColor: Color(0xFFE53935),
        lineColor: Color(0xFFE0E0E0),
        textColor: Color(0xFFE53935),
        icon: Icons.close_rounded,
      );
    case AdopterOrderProgressState.upcoming:
      return const _StepVisualScheme(
        dotColor: Color(0xFFD7D7D7),
        lineColor: Color(0xFFE5E5E5),
        textColor: Color(0xFFAAAAAA),
        icon: null,
      );
  }
}

class _ActivityCard extends StatelessWidget {
  final String title;
  final List<AdopterOrderActivityItemModel> activities;
  final String? emptyMessage;

  const _ActivityCard({
    required this.title,
    required this.activities,
    this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 14.h),
          if (activities.isEmpty)
            Text(
              emptyMessage ?? 'Belum ada aktivitas untuk ditampilkan.',
              style: textTheme.labelLarge?.copyWith(
                color: const Color(0xFF8A8A8A),
                height: 1.5,
              ),
            )
          else
            ...List<Widget>.generate(activities.length, (int index) {
              final activity = activities[index];
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == activities.length - 1 ? 0 : 12.h,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 10.w,
                      height: 10.h,
                      margin: EdgeInsets.only(top: 5.h),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF87537),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            activity.title,
                            style: textTheme.labelLarge?.copyWith(
                              color: Colors.black,
                              height: 1.45,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            activity.timestamp,
                            style: textTheme.labelMedium?.copyWith(
                              color: const Color(0xFF9A9A9A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}

class _PaymentActionCard extends StatelessWidget {
  final AdopterOrderHistoryModel order;
  final Future<void> Function() onOpenPayment;

  const _PaymentActionCard({required this.order, required this.onOpenPayment});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    if (!order.canAccessPaymentTab) {
      return const _InlineWarningCard(
        message:
            'Status pembayaran akan terbuka setelah shelter menerima form adopsi kamu.',
      );
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Aksi Pembayaran',
            style: textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            order.isPaymentSuccess
                ? 'Pembayaran sudah berhasil. Pesanan dipindahkan ke riwayat terakhir.'
                : order.isPaymentExpiredLocally
                ? 'Pembayaran sudah melewati batas waktu 15 menit dan dianggap gagal.'
                : 'Gunakan tombol di bawah untuk membuka Midtrans. Timer 15 menit akan mulai saat halaman pembayaran dibuka.',
            style: textTheme.labelLarge?.copyWith(
              color: const Color(0xFF7A7A7A),
              height: 1.5,
            ),
          ),
          if (order.hasPaymentTimer && order.isPaymentPending)
            Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3EC),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: const Color(0xFFF8D7C5)),
                ),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.schedule_rounded,
                      color: const Color(0xFFF87537),
                      size: 18.sp,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        'Sisa waktu pembayaran ${order.paymentCountdownLabel}',
                        style: textTheme.labelLarge?.copyWith(
                          color: const Color(0xFFF87537),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (order.timeLeft.trim().isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: Text(
                'Info backend: ${order.timeLeft.trim()}',
                style: textTheme.labelMedium?.copyWith(
                  color: const Color(0xFF9A9A9A),
                ),
              ),
            ),
          SizedBox(height: 14.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: order.canOpenPayment ? onOpenPayment : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF87537),
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(0xFFE0E0E0),
                disabledForegroundColor: const Color(0xFF9A9A9A),
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999.r),
                ),
                elevation: 0,
              ),
              child: Text(
                order.paymentButtonLabel,
                style: textTheme.labelLarge?.copyWith(
                  color: order.canOpenPayment
                      ? Colors.white
                      : const Color(0xFF8F8F8F),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          if (!order.isPaymentSuccess && order.paymentTokenValue.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: Text(
                'Midtrans token tersedia, tetapi untuk project ini dipakai URL redirect dari backend agar integrasi tetap stabil.',
                style: textTheme.labelMedium?.copyWith(
                  color: const Color(0xFF9A9A9A),
                  height: 1.45,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _InlineWarningCard extends StatelessWidget {
  final String message;

  const _InlineWarningCard({required this.message});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F2),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFF8D7C5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.info_outline_rounded,
            color: const Color(0xFFF87537),
            size: 20.sp,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              message,
              style: textTheme.labelLarge?.copyWith(
                color: const Color(0xFF6F6F6F),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
