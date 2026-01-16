import 'package:expense_wise/app/services/transfer_service.dart';
import 'package:get/get.dart';

class TransfersController extends GetxController {
  final TransferService _transferService = Get.find<TransferService>();

  final transfers = <TransferPair>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadTransfers();
  }

  Future<void> loadTransfers() async {
    isLoading.value = true;
    try {
      transfers.value = await _transferService.getTransferHistory();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load transfers: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteTransfer(TransferPair transfer) async {
    try {
      await _transferService.deleteTransfer(transfer.sourceTransaction.id);
      await loadTransfers();
      Get.snackbar('Success', 'Transfer deleted');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete transfer: $e');
    }
  }
}
