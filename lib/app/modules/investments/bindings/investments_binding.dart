import 'package:expense_wise/app/modules/investments/controllers/investments_controller.dart';
import 'package:expense_wise/app/services/investment_service.dart';
import 'package:get/get.dart';

class InvestmentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InvestmentService>(() => InvestmentService());
    Get.lazyPut<InvestmentsController>(() => InvestmentsController());
  }
}
