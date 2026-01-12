import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_wise/app/modules/accounts/controllers/accounts_controller.dart';
import 'package:expense_wise/app/data/models/account.dart';

class AddAccountView extends GetView<AccountsController> {
  AddAccountView({super.key});

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
  final _selectedType = AccountType.bank.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Account')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Account Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.label),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Obx(
                () => DropdownButtonFormField<AccountType>(
                  initialValue: _selectedType.value,
                  decoration: const InputDecoration(
                    labelText: 'Account Type',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category),
                  ),
                  items: AccountType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type.name.capitalizeFirst!),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) _selectedType.value = value;
                  },
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _balanceController,
                decoration: const InputDecoration(
                  labelText: 'Current Balance',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a balance';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Save Account',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      controller.addAccount(
        name: _nameController.text,
        type: _selectedType.value,
        balance: double.parse(_balanceController.text),
        currency: 'USD',
        // Default color for now, can be enhanced with color picker
        colorHex: '0xFF2196F3',
        iconCodePoint: Icons.account_balance.codePoint,
      );
      Get.back();
      Get.snackbar(
        'Success',
        'Account added successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
