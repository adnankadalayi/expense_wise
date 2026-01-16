import 'package:expense_wise/app/data/models/investment.dart';
import 'package:expense_wise/app/services/investment_service.dart';
import 'package:get/get.dart';

class InvestmentsController extends GetxController {
  final InvestmentService _investmentService = Get.find<InvestmentService>();

  final investments = <Investment>[].obs;
  final totalPortfolioValue = 0.0.obs;
  final totalInvested = 0.0.obs;
  final totalProfitLoss = 0.0.obs;
  final overallROI = 0.0.obs;
  final portfolioAllocation = <InvestmentType, double>{}.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadInvestments();
  }

  Future<void> loadInvestments() async {
    isLoading.value = true;
    try {
      investments.value = await _investmentService.getAllInvestments();
      totalPortfolioValue.value = await _investmentService
          .getTotalPortfolioValue();
      totalInvested.value = await _investmentService.getTotalInvested();
      totalProfitLoss.value = await _investmentService.getTotalProfitLoss();
      overallROI.value = await _investmentService.getOverallROI();
      portfolioAllocation.value = await _investmentService
          .getPortfolioAllocation();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load investments: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteInvestment(Investment investment) async {
    try {
      await _investmentService.deleteInvestment(investment.id);
      await loadInvestments();
      Get.snackbar('Success', 'Investment deleted');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete investment: $e');
    }
  }

  void navigateToAddInvestment() {
    Get.toNamed('/add-investment')?.then((_) => loadInvestments());
  }

  void navigateToEditInvestment(Investment investment) {
    Get.toNamed(
      '/add-investment',
      arguments: investment,
    )?.then((_) => loadInvestments());
  }
}
