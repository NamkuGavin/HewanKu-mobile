import '../../models/api/api_response_model.dart';
import '../../models/order/adopter_order_form_data_model.dart';
import '../../models/order/adopter_order_history_model.dart';
import '../../modules/adopter/adopsi/widgets/hewan_model.dart';
import '../../modules/adopter/pesanan/model/pesanan_terakhir_item.dart';
import '../api/api_client.dart';
import '../api/api_endpoints.dart';
import 'adopter_payment_session_service.dart';
import 'adopter_review_state_service.dart';

class AdopterOrderService {
  AdopterOrderService._();

  static final AdopterOrderService instance = AdopterOrderService._();

  Future<ApiResponseModel<Object?>> createOrder({
    required HewanModel hewan,
    required AdopterOrderFormDataModel formData,
  }) {
    return ApiClient.instance.post<Object?>(
      path: ApiEndpoints.adopterCreateOrder(hewan.id),
      body: formData.toCreateOrderJson(hewan: hewan),
      requiresAuth: true,
      dataParser: (rawData) => rawData,
    );
  }

  Future<List<AdopterOrderHistoryModel>> getOrders() async {
    final response = await ApiClient.instance
        .get<List<AdopterOrderHistoryModel>>(
          path: ApiEndpoints.adopterOrderHistory,
          requiresAuth: true,
          dataParser: (rawData) => AdopterOrderHistoryModel.parseList(rawData),
        );

    final items = response.data ?? const <AdopterOrderHistoryModel>[];
    if (items.isEmpty) {
      return items;
    }

    final sessions = await AdopterPaymentSessionService.instance
        .getAllSessions();
    final reviewedOrderIds = await AdopterReviewStateService.instance
        .getReviewedOrderIds();
    final mergedItems = <AdopterOrderHistoryModel>[];

    for (final item in items) {
      final session = sessions[item.id];
      final merged = item.copyWith(
        paymentSession: session,
        isReviewed: reviewedOrderIds.contains(item.id),
      );

      if (merged.shouldClearLocalPaymentSession) {
        await AdopterPaymentSessionService.instance.clearSession(item.id);
        mergedItems.add(merged.copyWith(clearPaymentSession: true));
        continue;
      }

      mergedItems.add(merged);
    }

    return mergedItems;
  }

  Future<AdopterOrderHistoryModel?> getOrderById(int id) async {
    final items = await getOrders();
    for (final item in items) {
      if (item.id == id) {
        return item;
      }
    }
    return null;
  }

  Future<List<PesananTerakhirItem>> getOrderHistory() async {
    final items = await getOrders();
    return items
        .where((item) => item.shouldAppearInHistory)
        .map((item) => item.toPesananTerakhirItem())
        .toList(growable: false);
  }
}
