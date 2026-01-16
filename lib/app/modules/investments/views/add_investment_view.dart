import 'package:expense_wise/app/data/models/investment.dart';
import 'package:expense_wise/app/services/investment_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddInvestmentView extends StatefulWidget {
  const AddInvestmentView({super.key});

  @override
  State<AddInvestmentView> createState() => _AddInvestmentViewState();
}

class _AddInvestmentViewState extends State<AddInvestmentView> {
  final InvestmentService _investmentService = Get.find<InvestmentService>();
  final _formKey = GlobalKey<FormState>();

  late Investment _investment;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args is Investment) {
      _investment = args;
      _isEditing = true;
    } else {
      _investment = Investment()
        ..name = ''
        ..symbol = ''
        ..type = InvestmentType.stock
        ..quantity = 0
        ..purchasePrice = 0
        ..currentPrice = 0
        ..purchaseDate = DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF002E6E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          _isEditing ? 'Edit Investment' : 'Add Investment',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _buildTextField(
              label: 'Investment Name',
              initialValue: _investment.name,
              onChanged: (value) => _investment.name = value,
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Symbol/Ticker',
              initialValue: _investment.symbol,
              onChanged: (value) => _investment.symbol = value.toUpperCase(),
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            _buildTypeSelector(),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Quantity',
              initialValue: _investment.quantity.toString(),
              keyboardType: TextInputType.number,
              onChanged: (value) =>
                  _investment.quantity = double.tryParse(value) ?? 0,
              validator: (value) {
                final num = double.tryParse(value ?? '');
                return num == null || num <= 0 ? 'Invalid quantity' : null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Purchase Price',
              initialValue: _investment.purchasePrice.toString(),
              keyboardType: TextInputType.number,
              onChanged: (value) =>
                  _investment.purchasePrice = double.tryParse(value) ?? 0,
              validator: (value) {
                final num = double.tryParse(value ?? '');
                return num == null || num <= 0 ? 'Invalid price' : null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Current Price',
              initialValue: _investment.currentPrice.toString(),
              keyboardType: TextInputType.number,
              onChanged: (value) =>
                  _investment.currentPrice = double.tryParse(value) ?? 0,
              validator: (value) {
                final num = double.tryParse(value ?? '');
                return num == null || num <= 0 ? 'Invalid price' : null;
              },
            ),
            const SizedBox(height: 16),
            _buildDatePicker(),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Notes (Optional)',
              initialValue: _investment.notes ?? '',
              maxLines: 3,
              onChanged: (value) =>
                  _investment.notes = value.isEmpty ? null : value,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveInvestment,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00BAF2),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                _isEditing ? 'Update Investment' : 'Add Investment',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String initialValue,
    required Function(String) onChanged,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      onChanged: onChanged,
      validator: validator,
    );
  }

  Widget _buildTypeSelector() {
    return DropdownButtonFormField<InvestmentType>(
      initialValue: _investment.type,
      decoration: InputDecoration(
        labelText: 'Investment Type',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      items: InvestmentType.values.map((type) {
        return DropdownMenuItem(
          value: type,
          child: Text('${type.icon} ${type.displayName}'),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _investment.type = value;
          });
        }
      },
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _investment.purchaseDate,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );
        if (date != null) {
          setState(() {
            _investment.purchaseDate = date;
          });
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Purchase Date',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_investment.purchaseDate.day}/${_investment.purchaseDate.month}/${_investment.purchaseDate.year}',
            ),
            const Icon(CupertinoIcons.calendar),
          ],
        ),
      ),
    );
  }

  Future<void> _saveInvestment() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      if (_isEditing) {
        await _investmentService.updateInvestment(_investment);
        Get.back();
        Get.snackbar('Success', 'Investment updated');
      } else {
        await _investmentService.addInvestment(_investment);
        Get.back();
        Get.snackbar('Success', 'Investment added');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to save investment: $e');
    }
  }
}
