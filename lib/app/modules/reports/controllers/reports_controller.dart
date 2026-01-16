import 'package:expense_wise/app/data/models/report_data.dart';
import 'package:expense_wise/app/services/pdf_service.dart';
import 'package:expense_wise/app/services/report_service.dart';
import 'package:get/get.dart';

class ReportsController extends GetxController {
  final ReportService _reportService = Get.find<ReportService>();
  final PdfService _pdfService = Get.find<PdfService>();

  final selectedPreset = DateRangePreset.thisMonth.obs;
  final startDate = Rxn<DateTime>();
  final endDate = Rxn<DateTime>();
  final reportData = Rxn<ReportData>();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _setDateRangeFromPreset(DateRangePreset.thisMonth);
    generateReport();
  }

  void selectPreset(DateRangePreset preset) {
    selectedPreset.value = preset;
    if (preset != DateRangePreset.custom) {
      _setDateRangeFromPreset(preset);
      generateReport();
    }
  }

  void _setDateRangeFromPreset(DateRangePreset preset) {
    final range = _reportService.getDateRangeFromPreset(preset);
    startDate.value = range['start'];
    endDate.value = range['end'];
  }

  void setCustomDateRange(DateTime start, DateTime end) {
    selectedPreset.value = DateRangePreset.custom;
    startDate.value = start;
    endDate.value = end;
    generateReport();
  }

  Future<void> generateReport() async {
    if (startDate.value == null || endDate.value == null) return;

    isLoading.value = true;
    try {
      final data = await _reportService.generateReport(
        startDate: startDate.value!,
        endDate: endDate.value!,
      );
      reportData.value = data;
    } catch (e) {
      Get.snackbar('Error', 'Failed to generate report: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> exportToPDF() async {
    if (reportData.value == null) {
      Get.snackbar('Error', 'No report data available');
      return;
    }

    try {
      await _pdfService.generateDetailedReport(
        startDate: startDate.value!,
        endDate: endDate.value!,
        reportData: reportData.value!,
      );
      Get.snackbar('Success', 'Report exported successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to export PDF: $e');
    }
  }

  String getPresetLabel(DateRangePreset preset) {
    switch (preset) {
      case DateRangePreset.thisMonth:
        return 'This Month';
      case DateRangePreset.lastMonth:
        return 'Last Month';
      case DateRangePreset.last3Months:
        return 'Last 3 Months';
      case DateRangePreset.last6Months:
        return 'Last 6 Months';
      case DateRangePreset.thisYear:
        return 'This Year';
      case DateRangePreset.lastYear:
        return 'Last Year';
      case DateRangePreset.custom:
        return 'Custom Range';
    }
  }
}
