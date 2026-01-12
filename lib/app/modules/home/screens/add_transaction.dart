import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionController extends GetxController
    with GetTickerProviderStateMixin {
  var selectedType = 'Expense'.obs;
  var selectedCategory = 'food'.obs;
  var amountText = ''.obs;
  var descriptionText = ''.obs;
  var selectedDate = DateTime.now().obs;
  var isSaving = false.obs;

  late AnimationController headerAnimationController;
  late AnimationController contentAnimationController;
  late AnimationController categoryAnimationController;

  late Animation<Offset> headerSlideAnimation;
  late Animation<double> headerFadeAnimation;
  late Animation<Offset> contentSlideAnimation;
  late Animation<double> contentFadeAnimation;
  late Animation<double> categoryFadeAnimation;

  final List<Map<String, String>> categories = [
    {'id': 'food', 'icon': '🍕', 'label': 'Food'},
    {'id': 'transport', 'icon': '🚗', 'label': 'Transport'},
    {'id': 'shopping', 'icon': '🛒', 'label': 'Shopping'},
    {'id': 'entertainment', 'icon': '🎬', 'label': 'Fun'},
    {'id': 'health', 'icon': '💊', 'label': 'Health'},
    {'id': 'bills', 'icon': '💡', 'label': 'Bills'},
    {'id': 'travel', 'icon': '✈️', 'label': 'Travel'},
    {'id': 'other', 'icon': '📦', 'label': 'Other'},
  ];

  @override
  void onInit() {
    super.onInit();
    setupAnimations();
    startAnimations();
  }

  void setupAnimations() {
    headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    contentAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    categoryAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    headerSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: headerAnimationController,
      curve: Curves.easeOut,
    ));

    headerFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(headerAnimationController);

    contentSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: contentAnimationController,
      curve: Curves.easeOut,
    ));

    contentFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(contentAnimationController);

    categoryFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: categoryAnimationController,
      curve: Curves.easeOut,
    ));
  }

  void startAnimations() {
    headerAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      contentAnimationController.forward();
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      categoryAnimationController.forward();
    });
  }

  void selectType(String type) {
    selectedType.value = type;
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  void updateAmount(String value) {
    // Format amount input like the HTML version
    String cleanValue = value.replaceAll(RegExp(r'[^\d.]'), '');
    List<String> parts = cleanValue.split('.');
    if (parts.length > 2) {
      cleanValue = parts[0] + '.' + parts.sublist(1).join('');
    }
    if (parts.length == 2 && parts[1].length > 2) {
      cleanValue = parts[0] + '.' + parts[1].substring(0, 2);
    }
    amountText.value = cleanValue;
  }

  void saveTransaction() async {
    isSaving.value = true;
    await Future.delayed(const Duration(milliseconds: 500));
    isSaving.value = false;
    Get.snackbar(
      'Success',
      'Transaction saved successfully!',
      backgroundColor: const Color(0xFFF7B500),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  }

  @override
  void onClose() {
    headerAnimationController.dispose();
    contentAnimationController.dispose();
    categoryAnimationController.dispose();
    super.onClose();
  }
}

class AddTransactionScreen extends StatelessWidget {
  const AddTransactionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TransactionController());

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF5C842), Color(0xFFF7B500)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              SlideTransition(
                position: controller.headerSlideAnimation,
                child: FadeTransition(
                  opacity: controller.headerFadeAnimation,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Add Transaction',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Transaction Type Buttons
              SlideTransition(
                position: controller.headerSlideAnimation,
                child: FadeTransition(
                  opacity: controller.headerFadeAnimation,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                    child: Obx(() => Row(
                          children: [
                            Expanded(
                              child: _buildTypeButton('Expense', controller),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildTypeButton('Income', controller),
                            ),
                          ],
                        )),
                  ),
                ),
              ),

              // Content Area
              Expanded(
                child: SlideTransition(
                  position: controller.contentSlideAnimation,
                  child: FadeTransition(
                    opacity: controller.contentFadeAnimation,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Amount Section
                            _buildAmountSection(controller),
                            const SizedBox(height: 32),

                            // Description
                            _buildDescriptionSection(controller),
                            const SizedBox(height: 24),

                            // Category
                            _buildCategorySection(controller),
                            const SizedBox(height: 24),

                            // Date
                            _buildDateSection(controller),
                            const SizedBox(height: 24),

                            // Save Button
                            _buildSaveButton(controller),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeButton(String type, TransactionController controller) {
    return GestureDetector(
      onTap: () => controller.selectType(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: controller.selectedType.value == type
              ? Colors.white.withOpacity(0.9)
              : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          type,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: controller.selectedType.value == type
                ? const Color(0xFFF7B500)
                : Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildAmountSection(TransactionController controller) {
    return Column(
      children: [
        const Text(
          '\$',
          style: TextStyle(
            fontSize: 24,
            color: Color(0xFFF7B500),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w800,
            color: Color(0xFF333333),
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: '0.00',
            hintStyle: TextStyle(color: Color(0xFFCCCCCC)),
          ),
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          onChanged: controller.updateAmount,
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(TransactionController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: 'What did you spend on?',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFF5F5F5), width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFF5F5F5), width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFF7B500), width: 2),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
          onChanged: (value) => controller.descriptionText.value = value,
        ),
      ],
    );
  }

  Widget _buildCategorySection(TransactionController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Category',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        FadeTransition(
          opacity: controller.categoryFadeAnimation,
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.9, // Taller items
            ),
            itemCount: controller.categories.length,
            itemBuilder: (context, index) {
              final category = controller.categories[index];
              return _buildCategoryItem(category, controller, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(Map<String, String> category,
      TransactionController controller, int index) {
    return Obx(() => GestureDetector(
          onTap: () => controller.selectCategory(category['id']!),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
            decoration: BoxDecoration(
              border: Border.all(
                color: controller.selectedCategory.value == category['id']
                    ? const Color(0xFFF7B500)
                    : const Color(0xFFF5F5F5),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
              color: controller.selectedCategory.value == category['id']
                  ? const Color(0xFFF7B500).withOpacity(0.1)
                  : Colors.transparent,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  category['icon']!,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: Text(
                    category['label']!,
                    style: const TextStyle(
                      fontSize: 11, // Slightly smaller font
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildDateSection(TransactionController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Date',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final date = await showDatePicker(
              context: Get.context!,
              initialDate: controller.selectedDate.value,
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            );
            if (date != null) {
              controller.selectedDate.value = date;
            }
          },
          child: Obx(() => Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFF5F5F5), width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${controller.selectedDate.value.year}-${controller.selectedDate.value.month.toString().padLeft(2, '0')}-${controller.selectedDate.value.day.toString().padLeft(2, '0')}',
                  style: const TextStyle(fontSize: 16),
                ),
              )),
        ),
      ],
    );
  }

  Widget _buildSaveButton(TransactionController controller) {
    return Obx(() => GestureDetector(
          onTap: controller.isSaving.value ? null : controller.saveTransaction,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFF7B500),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              controller.isSaving.value ? 'Saving...' : 'Save Transaction',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ));
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ExpenseWise',
      home: const AddTransactionScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
