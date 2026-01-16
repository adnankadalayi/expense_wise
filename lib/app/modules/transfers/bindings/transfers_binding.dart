import 'package:expense_wise/app/modules/transfers/controllers/transfers_controller.dart';
import 'package:expense_wise/app/services/transfer_service.dart';
import 'package:get/get.dart';

class TransfersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransferService>(() => TransferService());
    Get.lazyPut<TransfersController>(() => TransfersController());
  }
}
