import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StatisticsController extends GetxController
    with GetTickerProviderStateMixin {
  var selectedPeriod = 'This Month'.obs;

  late AnimationController headerAnimationController;
  late AnimationController contentAnimationController;
  late AnimationController overviewAnimationController;
  late AnimationController chartAnimationController;
  late AnimationController categoriesAnimationController;

  late Animation<Offset> headerSlideAnimation;
  late Animation<double> headerFadeAnimation;
  late Animation<Offset> contentSlideAnimation;
  late Animation<double> contentFadeAnimation;
  late Animation<Offset> overviewSlideAnimation;
  late Animation<double> overviewFadeAnimation;
  late Animation<Offset> chartSlideAnimation;
  late Animation<double> chartFadeAnimation;
  late Animation<Offset> categoriesSlideAnimation;
  late Animation<double> categoriesFadeAnimation;

  final List<String> periods = ['This Month', 'Last Month', 'This Year'];

  final List<Map<String, dynamic>> categoryData = [
    {
      'name': 'Food & Dining',
      'percentage': '36% of spending',
      'amount': '\$449',
      'color': const Color(0xFFF7B500),
    },
    {
      'name': 'Transportation',
      'percentage': '19% of spending',
      'amount': '\$237',
      'color': const Color(0xFFEF4444),
    },
    {
      'name': 'Shopping',
      'percentage': '12% of spending',
      'amount': '\$150',
      'color': const Color(0xFF22C55E),
    },
    {
      'name': 'Entertainment',
      'percentage': '14% of spending',
      'amount': '\$175',
      'color': const Color(0xFF8B5CF6),
    },
    {
      'name': 'Bills & Utilities',
      'percentage': '19% of spending',
      'amount': '\$236',
      'color': const Color(0xFF06B6D4),
    },
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

    overviewAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    chartAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    categoriesAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    headerSlideAnimation = Tween<Offset>(
      begin: const Offset(-0.5, 0),
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

    overviewSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: overviewAnimationController,
      curve: Curves.easeOut,
    ));

    overviewFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(overviewAnimationController);

    chartSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: chartAnimationController,
      curve: Curves.easeOut,
    ));

    chartFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(chartAnimationController);

    categoriesSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: categoriesAnimationController,
      curve: Curves.easeOut,
    ));

    categoriesFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(categoriesAnimationController);
  }

  void startAnimations() {
    headerAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      contentAnimationController.forward();
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      overviewAnimationController.forward();
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      chartAnimationController.forward();
    });
    Future.delayed(const Duration(milliseconds: 1000), () {
      categoriesAnimationController.forward();
    });
  }

  void selectPeriod(String period) {
    selectedPeriod.value = period;
  }

  @override
  void onClose() {
    headerAnimationController.dispose();
    contentAnimationController.dispose();
    overviewAnimationController.dispose();
    chartAnimationController.dispose();
    categoriesAnimationController.dispose();
    super.onClose();
  }
}
