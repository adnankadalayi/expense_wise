import 'package:expense_wise/app/data/models/account.dart';
import 'package:expense_wise/app/data/models/transaction.dart';
import 'package:expense_wise/app/services/storage_service.dart';
import 'package:get/get.dart';
import 'package:isar_community/isar.dart';

class TransferService extends GetxService {
  final StorageService _storageService = Get.find<StorageService>();

  /// Create a transfer between two accounts with dual-entry accounting
  Future<void> createTransfer({
    required Account fromAccount,
    required Account toAccount,
    required double amount,
    double transferFee = 0,
    String? note,
    DateTime? date,
  }) async {
    // Validation
    if (fromAccount.id == toAccount.id) {
      throw Exception('Cannot transfer to the same account');
    }

    if (amount <= 0) {
      throw Exception('Transfer amount must be greater than zero');
    }

    if (transferFee < 0) {
      throw Exception('Transfer fee cannot be negative');
    }

    final totalDeduction = amount + transferFee;
    if (fromAccount.balance < totalDeduction) {
      throw Exception('Insufficient balance in source account');
    }

    final db = _storageService.db;
    final transferDate = date ?? DateTime.now();

    await db.writeTxn(() async {
      // Create expense transaction from source account
      final expenseTransaction = Transaction()
        ..type = TransactionType.expense
        ..amount = totalDeduction
        ..date = transferDate
        ..note = note ?? 'Transfer to ${toAccount.name}'
        ..transferFee = transferFee;

      await db.transactions.put(expenseTransaction);
      expenseTransaction.account.value = fromAccount;
      await expenseTransaction.account.save();

      // Create income transaction to destination account
      final incomeTransaction = Transaction()
        ..type = TransactionType.income
        ..amount = amount
        ..date = transferDate
        ..note = note ?? 'Transfer from ${fromAccount.name}'
        ..linkedTransactionId = expenseTransaction.id;

      await db.transactions.put(incomeTransaction);
      incomeTransaction.account.value = toAccount;
      await incomeTransaction.account.save();

      // Link the transactions
      expenseTransaction.linkedTransactionId = incomeTransaction.id;
      await db.transactions.put(expenseTransaction);

      // Update account balances
      fromAccount.balance -= totalDeduction;
      toAccount.balance += amount;

      await db.accounts.put(fromAccount);
      await db.accounts.put(toAccount);
    });
  }

  /// Get all transfers (returns pairs of linked transactions)
  Future<List<TransferPair>> getTransferHistory() async {
    final db = _storageService.db;
    final allTransactions = await db.transactions.where().findAll();

    // Load account links
    for (var tx in allTransactions) {
      await tx.account.load();
    }

    final transfers = <TransferPair>[];
    final processedIds = <int>{};

    for (var tx in allTransactions) {
      if (tx.linkedTransactionId != null && !processedIds.contains(tx.id)) {
        final linkedTx = allTransactions.firstWhereOrNull(
          (t) => t.id == tx.linkedTransactionId,
        );

        if (linkedTx != null) {
          // Determine which is source and which is destination
          final sourceTx = tx.type == TransactionType.expense ? tx : linkedTx;
          final destTx = tx.type == TransactionType.income ? tx : linkedTx;

          transfers.add(
            TransferPair(
              sourceTransaction: sourceTx,
              destinationTransaction: destTx,
              amount: destTx.amount,
              fee: sourceTx.transferFee ?? 0,
              date: sourceTx.date,
            ),
          );

          processedIds.add(tx.id);
          processedIds.add(linkedTx.id);
        }
      }
    }

    // Sort by date descending
    transfers.sort((a, b) => b.date.compareTo(a.date));
    return transfers;
  }

  /// Delete a transfer (both linked transactions)
  Future<void> deleteTransfer(int linkedTransactionId) async {
    final db = _storageService.db;

    await db.writeTxn(() async {
      final transaction = await db.transactions.get(linkedTransactionId);
      if (transaction == null) return;

      final linkedId = transaction.linkedTransactionId;
      if (linkedId == null) return;

      final linkedTransaction = await db.transactions.get(linkedId);
      if (linkedTransaction == null) return;

      // Load accounts
      await transaction.account.load();
      await linkedTransaction.account.load();

      final sourceAccount = transaction.account.value;
      final destAccount = linkedTransaction.account.value;

      if (sourceAccount != null && destAccount != null) {
        // Revert balances
        final sourceTx = transaction.type == TransactionType.expense
            ? transaction
            : linkedTransaction;
        final destTx = transaction.type == TransactionType.income
            ? transaction
            : linkedTransaction;

        sourceAccount.balance += sourceTx.amount;
        destAccount.balance -= destTx.amount;

        await db.accounts.put(sourceAccount);
        await db.accounts.put(destAccount);
      }

      // Delete both transactions
      await db.transactions.delete(transaction.id);
      await db.transactions.delete(linkedId);
    });
  }

  /// Validate transfer before creation
  bool validateTransfer({
    required Account fromAccount,
    required Account toAccount,
    required double amount,
    double transferFee = 0,
  }) {
    if (fromAccount.id == toAccount.id) return false;
    if (amount <= 0) return false;
    if (transferFee < 0) return false;
    if (fromAccount.balance < (amount + transferFee)) return false;
    return true;
  }
}

class TransferPair {
  final Transaction sourceTransaction;
  final Transaction destinationTransaction;
  final double amount;
  final double fee;
  final DateTime date;

  TransferPair({
    required this.sourceTransaction,
    required this.destinationTransaction,
    required this.amount,
    required this.fee,
    required this.date,
  });

  Account? get fromAccount => sourceTransaction.account.value;
  Account? get toAccount => destinationTransaction.account.value;
  String? get note => sourceTransaction.note;
  double get totalDeduction => amount + fee;
}
