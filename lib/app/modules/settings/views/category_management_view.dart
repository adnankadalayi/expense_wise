import 'package:expense_wise/app/modules/settings/controllers/settings_categories_controller.dart';
import 'package:expense_wise/app/modules/settings/views/add_edit_category_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_wise/app/data/models/category.dart';

class CategoryManagementView extends StatelessWidget {
  const CategoryManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsCategoriesController());

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFF002E6E),
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            // Gradient Background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF002E6E), Color(0xFF00BAF2)],
                ),
              ),
            ),

            // Main Content
            Column(
              children: [
                // Custom Header
                SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title Row
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                CupertinoIcons.back,
                                color: Colors.white,
                              ),
                              onPressed: () => Get.back(),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Categories',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Modern Tab Selector
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TabBar(
                            indicator: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelColor: const Color(0xFF002E6E),
                            unselectedLabelColor: Colors.white.withOpacity(0.7),
                            labelStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                            unselectedLabelStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            indicatorSize: TabBarIndicatorSize.tab,
                            dividerColor: Colors.transparent,
                            tabs: const [
                              Tab(text: 'Expense'),
                              Tab(text: 'Income'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // White Card Container
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(32),
                      ),
                    ),
                    child: TabBarView(
                      children: [
                        Obx(
                          () => _buildCategoryList(
                            controller,
                            controller.expenseCategories,
                          ),
                        ),
                        Obx(
                          () => _buildCategoryList(
                            controller,
                            controller.incomeCategories,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        floatingActionButton: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00BAF2).withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: () => Get.to(() => const AddEditCategoryView()),
            backgroundColor: const Color(0xFF00BAF2),
            elevation: 0,
            child: const Icon(
              CupertinoIcons.add,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryList(
    SettingsCategoriesController controller,
    List<Category> categories,
  ) {
    if (categories.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Icon(
                CupertinoIcons.square_grid_2x2,
                size: 48,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No categories yet',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap + to create your first category',
              style: TextStyle(color: Colors.grey[400], fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
      itemCount: categories.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final category = categories[index];
        return Dismissible(
          key: Key(category.id.toString()),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red.shade400, Colors.red.shade600],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              CupertinoIcons.delete,
              color: Colors.white,
              size: 24,
            ),
          ),
          confirmDismiss: (direction) async {
            return await Get.dialog<bool>(
              AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: const Text(
                  'Delete Category',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                content: const Text(
                  'Are you sure you want to delete this category? Current transactions will remain but may lose category association.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Get.back(result: false),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Get.back(result: true),
                    child: const Text(
                      'Delete',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          onDismissed: (direction) {
            controller.deleteCategory(category);
          },
          child: GestureDetector(
            onTap: () => Get.to(() => AddEditCategoryView(category: category)),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Icon Container with Gradient
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: category.colorHex != null
                          ? LinearGradient(
                              colors: [
                                Color(
                                  int.parse(category.colorHex!),
                                ).withOpacity(0.15),
                                Color(
                                  int.parse(category.colorHex!),
                                ).withOpacity(0.25),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : LinearGradient(
                              colors: [Colors.grey[200]!, Colors.grey[300]!],
                            ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      IconData(
                        category.iconCodePoint ??
                            CupertinoIcons.square_grid_2x2_fill.codePoint,
                        fontFamily: 'CupertinoIcons',
                        fontPackage: 'cupertino_icons',
                      ),
                      color: category.colorHex != null
                          ? Color(int.parse(category.colorHex!))
                          : Colors.grey[600],
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Category Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A1A),
                            letterSpacing: -0.2,
                          ),
                        ),
                        if (category.subCategories != null &&
                            category.subCategories!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: Text(
                              '${category.subCategories!.length} subcategories',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Chevron
                  Icon(
                    CupertinoIcons.chevron_right,
                    color: Colors.grey[400],
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
