import 'package:expense_wise/app/data/models/fire_data.dart';
import 'package:expense_wise/app/services/fire_service.dart';
import 'package:get/get.dart';

class FireController extends GetxController {
  final FireService _fireService = Get.find<FireService>();

  final currentAge = 30.obs;
  final targetRetirementAge = 65.obs;
  final expectedReturnRate = 7.0.obs; // Percentage
  final safeWithdrawalRate = 4.0.obs; // Percentage

  final fireData = Rxn<FireData>();
  final isLoading = false.obs;
  final projections = <ProjectionPoint>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadSettings();
    calculateFire();
  }

  Future<void> loadSettings() async {
    final settings = await _fireService.loadFireSettings();
    currentAge.value = settings['currentAge'];
    targetRetirementAge.value = settings['targetRetirementAge'];
    expectedReturnRate.value = (settings['expectedReturnRate'] * 100);
    safeWithdrawalRate.value = (settings['safeWithdrawalRate'] * 100);
  }

  Future<void> calculateFire() async {
    isLoading.value = true;
    try {
      final data = await _fireService.getCurrentFireData(
        currentAge: currentAge.value,
        targetRetirementAge: targetRetirementAge.value,
      );

      if (data != null) {
        // Update with custom rates
        fireData.value = FireData(
          currentAge: data.currentAge,
          targetRetirementAge: data.targetRetirementAge,
          currentNetWorth: data.currentNetWorth,
          monthlyExpenses: data.monthlyExpenses,
          monthlySavings: data.monthlySavings,
          expectedReturnRate: expectedReturnRate.value / 100,
          safeWithdrawalRate: safeWithdrawalRate.value / 100,
        );

        // Calculate projections
        final years = fireData.value!.yearsToFire.isFinite
            ? fireData.value!.yearsToFire.ceil()
            : 30;

        projections.value = _fireService.calculateNetWorthProjection(
          currentNetWorth: data.currentNetWorth,
          annualSavings: data.annualSavings,
          returnRate: expectedReturnRate.value / 100,
          years: years > 50 ? 50 : years,
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to calculate FIRE: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveSettings() async {
    await _fireService.saveFireSettings(
      currentAge: currentAge.value,
      targetRetirementAge: targetRetirementAge.value,
      expectedReturnRate: expectedReturnRate.value / 100,
      safeWithdrawalRate: safeWithdrawalRate.value / 100,
    );

    await calculateFire();
    Get.snackbar('Success', 'FIRE settings saved');
  }

  void updateAge(int age) {
    currentAge.value = age;
  }

  void updateTargetAge(int age) {
    targetRetirementAge.value = age;
  }

  void updateReturnRate(double rate) {
    expectedReturnRate.value = rate;
  }

  void updateWithdrawalRate(double rate) {
    safeWithdrawalRate.value = rate;
  }
}
