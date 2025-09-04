import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expence_tracker/constant/colorsfile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/barchartscreencontroller.dart';

class BarChartScreen extends StatelessWidget {
  BarChartScreen({super.key});
  final BarChartController controller = Get.put(BarChartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Expense-Tracker',
          style: TextStyle(
            fontFamily: 'Montserrat-Regular',
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time Filter Tabs
            Obx(
                  () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: ['Day', 'Week', 'Month', 'Year'].map((filter) {
                  return _timeTab(filter, controller.selectedTimeFilter.value == filter);
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // Expense / Income Dropdown
            Align(
              alignment: Alignment.centerRight,
              child: Obx(
                    () => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: kBlackColor.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButton<String>(
                    value: controller.selectedType.value,
                    underline: const SizedBox(),
                    items: ['Expense', 'Income']
                        .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e,
                        style: const TextStyle(
                          fontFamily: 'Montserrat-Regular',
                          fontSize: 14,
                        ),
                      ),
                    ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) controller.setType(value);
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Graph Placeholder
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: kBlackColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text(
                  'Graph / Line Chart here (You can integrate charts_flutter)',
                  style: TextStyle(
                    fontFamily: 'Montserrat-Regular',
                    fontSize: 16,
                    color: kBlackColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Top Spending
            const Text(
              'Top Spending',
              style: TextStyle(
                fontFamily: 'Montserrat-SemiBold',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: kBlackColor,
              ),
            ),
            const SizedBox(height: 15),

            // List of transactions
            Obx(
                  () => Expanded(
                child: ListView.builder(
                  itemCount: controller.filteredTransactions.length,
                  itemBuilder: (context, index) {
                    final tx = controller.filteredTransactions[index];
                    return _spendingItem(
                      icon: Icons.account_balance_wallet,
                      title: tx['title'] ?? 'No title',
                      date: (tx['date'] as Timestamp).toDate().toString().split(' ')[0],
                      amount: '${tx['type'] == 'Expense' ? '-' : '+'} \$${tx['amount']}',
                      bgColor: tx['type'] == 'Expense' ? kWhiteColor : kBlackColor,
                      textColor: tx['type'] == 'Expense' ? Colors.red : kWhiteColor,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _timeTab(String title, bool selected) {
    return GestureDetector(
      onTap: () => controller.setTimeFilter(title),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? kBlackColor : kBlackColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: selected ? kWhiteColor : kBlackColor,
            fontSize: 14,
            fontFamily: 'Montserrat-SemiBold',
          ),
        ),
      ),
    );
  }

  Widget _spendingItem({
    required IconData icon,
    required String title,
    required String date,
    required String amount,
    required Color bgColor,
    required Color textColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: kBlackColor.withOpacity(0.1),
            child: Icon(icon, color: kBlackColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Montserrat-SemiBold',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textColor == kWhiteColor ? kWhiteColor : kBlackColor,
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(
                    fontFamily: 'Montserrat-Regular',
                    fontSize: 12,
                    color: textColor == kWhiteColor
                        ? kWhiteColor.withOpacity(0.7)
                        : kBlackColor.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontFamily: 'Montserrat-SemiBold',
              fontSize: 16,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
