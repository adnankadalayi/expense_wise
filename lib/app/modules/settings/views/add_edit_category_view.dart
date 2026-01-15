import 'package:expense_wise/app/data/models/category.dart';
import 'package:expense_wise/app/modules/settings/controllers/categories_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddEditCategoryView extends StatefulWidget {
  final Category? category; // If null, adding new category

  const AddEditCategoryView({super.key, this.category});

  @override
  State<AddEditCategoryView> createState() => _AddEditCategoryViewState();
}

class _AddEditCategoryViewState extends State<AddEditCategoryView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late CategoryType _selectedType;
  late String _selectedColor;
  late int _selectedIcon;
  final List<String> _subCategories = [];
  final TextEditingController _subCatController = TextEditingController();

  final List<String> _colors = [
    '0xFFF44336', // Red
    '0xFFE91E63', // Pink
    '0xFF9C27B0', // Purple
    '0xFF673AB7', // Deep Purple
    '0xFF3F51B5', // Indigo
    '0xFF2196F3', // Blue
    '0xFF03A9F4', // Light Blue
    '0xFF00BCD4', // Cyan
    '0xFF009688', // Teal
    '0xFF4CAF50', // Green
    '0xFF8BC34A', // Light Green
    '0xFFCDDC39', // Lime
    '0xFFFFEB3B', // Yellow
    '0xFFFFC107', // Amber
    '0xFFFF9800', // Orange
    '0xFFFF5722', // Deep Orange
    '0xFF795548', // Brown
    '0xFF9E9E9E', // Grey
    '0xFF607D8B', // Blue Grey
    '0xFF000000', // Black
  ];

  final List<int> _icons = [
    Icons.shopping_cart.codePoint,
    Icons.restaurant.codePoint,
    Icons.directions_car.codePoint,
    Icons.home.codePoint,
    Icons.local_hospital.codePoint,
    Icons.school.codePoint,
    Icons.movie.codePoint,
    Icons.flight.codePoint,
    Icons.pets.codePoint,
    Icons.work.codePoint,
    Icons.build.codePoint,
    Icons.card_giftcard.codePoint,
    Icons.sports_esports.codePoint,
    Icons.fitness_center.codePoint,
    Icons.local_cafe.codePoint,
    Icons.local_grocery_store.codePoint,
    Icons.attach_money.codePoint,
    Icons.account_balance.codePoint,
    Icons.trending_up.codePoint,
    Icons.category.codePoint,
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.name ?? '');

    _selectedType = widget.category?.type ?? CategoryType.expense;
    _selectedColor = widget.category?.colorHex ?? _colors.first;
    _selectedIcon = widget.category?.iconCodePoint ?? _icons.first;

    if (widget.category?.subCategories != null) {
      _subCategories.addAll(widget.category!.subCategories!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category == null ? 'Add Category' : 'Edit Category',
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        actions: [
          TextButton(
            onPressed: _saveCategory,
            child: const Text('Save', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('Category Name'),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Enter category name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              if (widget.category == null) ...[
                _buildLabel('Type'),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() {
                          _selectedType = CategoryType.expense;
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _selectedType == CategoryType.expense
                                ? Colors.redAccent
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Expense',
                            style: TextStyle(
                              color: _selectedType == CategoryType.expense
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() {
                          _selectedType = CategoryType.income;
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _selectedType == CategoryType.income
                                ? Colors.green
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Income',
                            style: TextStyle(
                              color: _selectedType == CategoryType.income
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],

              _buildLabel('Color'),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _colors.map((color) {
                  final isSelected = _selectedColor == color;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = color),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(int.parse(color)),
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: Colors.black, width: 2)
                            : null,
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, color: Colors.white)
                          : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              _buildLabel('Icon'),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _icons.map((codePoint) {
                  final isSelected = _selectedIcon == codePoint;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedIcon = codePoint),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Color(int.parse(_selectedColor)).withOpacity(0.2)
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: isSelected
                            ? Border.all(
                                color: Color(int.parse(_selectedColor)),
                              )
                            : null,
                      ),
                      child: Icon(
                        IconData(codePoint, fontFamily: 'MaterialIcons'),
                        color: isSelected
                            ? Color(int.parse(_selectedColor))
                            : Colors.grey,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              _buildLabel('Subcategories'),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _subCatController,
                      decoration: InputDecoration(
                        hintText: 'Add subcategory',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _addSubCategory,
                    icon: const Icon(Icons.add_circle, size: 32),
                    color: Color(int.parse(_selectedColor)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _subCategories.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _subCategories[index],
                          style: const TextStyle(fontSize: 16),
                        ),
                        InkWell(
                          onTap: () => setState(() {
                            _subCategories.removeAt(index);
                          }),
                          child: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  void _addSubCategory() {
    if (_subCatController.text.trim().isNotEmpty) {
      setState(() {
        _subCategories.add(_subCatController.text.trim());
        _subCatController.clear();
      });
    }
  }

  void _saveCategory() {
    if (_formKey.currentState!.validate()) {
      final controller = Get.find<CategoriesController>();

      if (widget.category == null) {
        controller.addCategory(
          name: _nameController.text.trim(),
          type: _selectedType,
          colorHex: _selectedColor,
          iconCodePoint: _selectedIcon,
          subCategories: _subCategories,
        );
      } else {
        controller.updateCategory(
          widget.category!,
          name: _nameController.text.trim(),
          colorHex: _selectedColor,
          iconCodePoint: _selectedIcon,
          subCategories: _subCategories,
        );
      }
      Get.back();
    }
  }
}
