import 'package:expense_wise/app/modules/reports/controllers/reports_controller.dart';
import 'package:expense_wise/app/services/report_service.dart';
import 'package:get/get.dart';

class ReportsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportService>(() => ReportService());
    Get.lazyPut<ReportsController>(() => ReportsController());
  }
}
