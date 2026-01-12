import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_wise/app/modules/accounts/controllers/accounts_controller.dart';
import 'package:expense_wise/app/routes/app_pages.dart';
import 'package:intl/intl.dart';

class AccountsView extends GetView<AccountsController> {
  const AccountsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Accounts'), centerTitle: true),
      body: Obx(() {
        return Column(
          children: [
            _buildTotalBalanceCard(context),
            const SizedBox(height: 20),
            Expanded(
              child: controller.accounts.isEmpty
                  ? Center(
                      child: Text(
                        'No accounts added yet',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    )
                  : ListView.builder(
                      itemCount: controller.accounts.length,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemBuilder: (context, index) {
                        final account = controller.accounts[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: account.colorHex != null
                                      ? Color(int.parse(account.colorHex!))
                                      : Theme.of(context).primaryColor,
                                  child: Icon(
                                    account.iconCodePoint != null
                                        ? IconData(
                                            account.iconCodePoint!,
                                            fontFamily: 'MaterialIcons',
                                          )
                                        : Icons.account_balance_wallet,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(
                                  account.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  account.type.name.capitalizeFirst ?? '',
                                ),
                                trailing: Text(
                                  NumberFormat.currency(
                                    symbol: '\$',
                                  ).format(account.balance),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // Toggle Show on Home
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                    ),
                                    child: Row(
                                      children: [
                                        const Text(
                                          'Show on Home',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        Checkbox(
                                          value: account.showOnHome,
                                          onChanged: (val) => controller
                                              .toggleShowOnHome(account),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Toggle Include in Total
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                    ),
                                    child: Row(
                                      children: [
                                        const Text(
                                          'Include in Total',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        Checkbox(
                                          value: !account.excludeFromTotal,
                                          onChanged: (val) => controller
                                              .toggleExcludeFromTotal(account),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.ADD_ACCOUNT),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTotalBalanceCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Total Balance',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            NumberFormat.currency(
              symbol: '\$',
            ).format(controller.totalBalance.value),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
