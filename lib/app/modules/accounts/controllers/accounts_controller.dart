import 'package:get/get.dart';
import 'package:isar_community/isar.dart';
import 'package:expense_wise/app/data/models/account.dart';
import 'package:expense_wise/app/services/storage_service.dart';

class AccountsController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();

  final accounts = <Account>[].obs;
  final totalBalance = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadAccounts();
  }

  Future<void> loadAccounts() async {
    final allAccounts = await _storageService.db.accounts.where().findAll();
    accounts.assignAll(allAccounts);
    calculateTotalBalance();
  }

  void calculateTotalBalance() {
    var total = 0.0;
    for (var account in accounts) {
      if (!account.excludeFromTotal) {
        total += account.balance;
      }
    }
    totalBalance.value = total;
  }

  Future<void> addAccount({
    required String name,
    required AccountType type,
    required double balance,
    required String currency,
    String? colorHex,
    int? iconCodePoint,
  }) async {
    final newAccount = Account()
      ..name = name
      ..type = type
      ..balance = balance
      ..currency = currency
      ..colorHex = colorHex
      ..iconCodePoint = iconCodePoint
      ..showOnHome = true
      ..excludeFromTotal = false;

    await _storageService.db.writeTxn(() async {
      await _storageService.db.accounts.put(newAccount);
    });

    await loadAccounts();
  }

  Future<void> toggleShowOnHome(Account account) async {
    // Limit check: if turning ON, check if we already have 4
    if (!account.showOnHome) {
      final count = accounts.where((a) => a.showOnHome).length;
      if (count >= 4) {
        Get.snackbar(
          'Limit Reached',
          'You can only show up to 4 accounts on Home screen.',
        );
        return;
      }
    }

    account.showOnHome = !account.showOnHome;
    await _storageService.db.writeTxn(() async {
      await _storageService.db.accounts.put(account);
    });
    accounts.refresh();
  }

  Future<void> toggleExcludeFromTotal(Account account) async {
    account.excludeFromTotal = !account.excludeFromTotal;
    await _storageService.db.writeTxn(() async {
      await _storageService.db.accounts.put(account);
    });
    accounts.refresh();
    calculateTotalBalance();
  }
}
