import 'package:expense_wise/app/data/models/transaction.dart';
import 'package:expense_wise/app/modules/calendar/controllers/calendar_controller.dart';
import 'package:expense_wise/app/services/storage_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CalendarView extends GetView<CalendarController> {
  const CalendarView({super.key});

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
        title: const Text('Calendar', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.today, color: Colors.white),
            onPressed: controller.goToToday,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            _buildMonthSummary(),
            _buildCalendar(),
            if (controller.selectedDay.value != null) ...[
              const Divider(),
              Expanded(child: _buildDayDetails()),
            ],
          ],
        );
      }),
    );
  }

  Widget _buildMonthSummary() {
    final currencySymbol = Get.find<StorageService>().currencySymbol.value;

    return Obx(
      () => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF002E6E), Color(0xFF00BAF2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildSummaryItem(
              'Income',
              '$currencySymbol${controller.monthIncome.value.toStringAsFixed(0)}',
              Colors.greenAccent,
            ),
            _buildSummaryItem(
              'Expense',
              '$currencySymbol${controller.monthExpense.value.toStringAsFixed(0)}',
              Colors.redAccent,
            ),
            _buildSummaryItem(
              'Net',
              '$currencySymbol${(controller.monthIncome.value - controller.monthExpense.value).toStringAsFixed(0)}',
              Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildCalendar() {
    return Obx(
      () => TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: controller.focusedDay.value,
        selectedDayPredicate: (day) {
          return isSameDay(controller.selectedDay.value, day);
        },
        calendarFormat: controller.calendarFormat.value,
        onDaySelected: controller.onDaySelected,
        onPageChanged: controller.onPageChanged,
        eventLoader: controller.getEventsForDay,
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: const Color(0xFF00BAF2).withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          selectedDecoration: const BoxDecoration(
            color: Color(0xFF00BAF2),
            shape: BoxShape.circle,
          ),
          markerDecoration: const BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
        ),
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, day, events) {
            if (events.isEmpty) return null;

            final dayData = controller.getDayData(day);
            if (dayData == null) return null;

            Color markerColor;
            if (dayData.hasIncome && dayData.hasExpense) {
              markerColor = Colors.blue;
            } else if (dayData.hasIncome) {
              markerColor = Colors.green;
            } else {
              markerColor = Colors.red;
            }

            return Positioned(
              bottom: 1,
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: markerColor,
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDayDetails() {
    return Obx(() {
      final selectedDate = controller.selectedDay.value;
      if (selectedDate == null) return const SizedBox();

      final dayData = controller.getDayData(selectedDate);
      final transactions = controller.dayTransactions;
      final currencySymbol = Get.find<StorageService>().currencySymbol.value;

      return Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('EEEE, MMM d, yyyy').format(selectedDate),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  icon: const Icon(CupertinoIcons.add_circled_solid),
                  color: const Color(0xFF00BAF2),
                  onPressed: () {
                    // Navigate to add transaction with pre-filled date
                    Get.toNamed('/add-transaction', arguments: selectedDate);
                  },
                ),
              ],
            ),
            if (dayData != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildDayStat(
                    'Income',
                    dayData.income,
                    Colors.green,
                    currencySymbol,
                  ),
                  const SizedBox(width: 16),
                  _buildDayStat(
                    'Expense',
                    dayData.expense,
                    Colors.red,
                    currencySymbol,
                  ),
                  const SizedBox(width: 16),
                  _buildDayStat(
                    'Net',
                    dayData.net,
                    dayData.net >= 0 ? Colors.green : Colors.red,
                    currencySymbol,
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            if (transactions.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'No transactions on this day',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final tx = transactions[index];
                    return _buildTransactionTile(tx);
                  },
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildDayStat(
    String label,
    double value,
    Color color,
    String currency,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$currency${value.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionTile(Transaction tx) {
    final currencySymbol = Get.find<StorageService>().currencySymbol.value;
    final category = tx.category.value;
    final isExpense = tx.type == TransactionType.expense;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: category?.colorHex != null
                  ? Color(int.parse(category!.colorHex!)).withOpacity(0.2)
                  : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              category?.iconCodePoint != null
                  ? IconData(
                      category!.iconCodePoint!,
                      fontFamily: 'CupertinoIcons',
                      fontPackage: 'cupertino_icons',
                    )
                  : CupertinoIcons.square_grid_2x2,
              color: category?.colorHex != null
                  ? Color(int.parse(category!.colorHex!))
                  : Colors.grey,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category?.name ?? 'Uncategorized',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                if (tx.note != null && tx.note!.isNotEmpty)
                  Text(
                    tx.note!,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          Text(
            '${isExpense ? "-" : "+"}$currencySymbol${tx.amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isExpense ? Colors.red : Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
