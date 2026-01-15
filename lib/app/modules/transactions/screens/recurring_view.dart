import 'package:expense_wise/app/data/models/recurring_transaction.dart';
import 'package:expense_wise/app/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:isar_community/isar.dart';

class RecurringTransactionsController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  var recurringTransactions = <RecurringTransaction>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadRecurringTransactions();
  }

  void loadRecurringTransactions() async {
    final txs = await _storageService.db.recurringTransactions
        .filter()
        .isActiveEqualTo(true)
        .findAll();
    recurringTransactions.assignAll(txs);
  }

  void deleteRecurringTransaction(RecurringTransaction tx) async {
    await _storageService.db.writeTxn(() async {
      await _storageService.db.recurringTransactions.delete(tx.id);
    });
    loadRecurringTransactions();
  }
}

class RecurringTransactionsView extends StatelessWidget {
  const RecurringTransactionsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RecurringTransactionsController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recurring Transactions'),
        backgroundColor: const Color(0xFFF7B500),
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.recurringTransactions.isEmpty) {
          return const Center(child: Text('No active recurring transactions'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.recurringTransactions.length,
          itemBuilder: (context, index) {
            final tx = controller.recurringTransactions[index];
            final cat = tx.category.value;
            final color = cat?.colorHex != null
                ? Color(int.parse(cat!.colorHex!))
                : Colors.grey;

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    IconData(
                      cat?.iconCodePoint ?? Icons.question_mark.codePoint,
                      fontFamily: 'MaterialIcons',
                    ),
                    color: color,
                  ),
                ),
                title: Text(tx.note ?? cat?.name ?? 'Recurring'),
                subtitle: Text(
                  '${tx.interval.name.capitalizeFirst} • Next: ${DateFormat('MMM d').format(tx.nextRunDate)}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${Get.find<StorageService>().currencySymbol.value}${tx.amount.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () =>
                          controller.deleteRecurringTransaction(tx),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
