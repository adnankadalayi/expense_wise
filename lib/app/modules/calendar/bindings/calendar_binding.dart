import 'package:expense_wise/app/modules/calendar/controllers/calendar_controller.dart';
import 'package:get/get.dart';

class CalendarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CalendarController>(() => CalendarController());
  }
}
