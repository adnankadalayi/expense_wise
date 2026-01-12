import 'package:get/get.dart';
import 'package:expense_wise/app/modules/accounts/controllers/accounts_controller.dart';

class AccountsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountsController>(() => AccountsController());
  }
}
