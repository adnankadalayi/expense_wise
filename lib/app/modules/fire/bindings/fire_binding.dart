import 'package:expense_wise/app/modules/fire/controllers/fire_controller.dart';
import 'package:expense_wise/app/services/fire_service.dart';
import 'package:get/get.dart';

class FireBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FireService>(() => FireService());
    Get.lazyPut<FireController>(() => FireController());
  }
}
