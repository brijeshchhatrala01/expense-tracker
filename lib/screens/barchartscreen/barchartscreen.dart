import 'package:expence_tracker/constant/colorsfile.dart';
import 'package:fl_chart/fl_chart.dart';
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Time Filter Tabs
              Obx(
                    () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: ['Day', 'Week', 'Month', 'Year'].map((filter) {
                    return _timeTab(
                      filter,
                      controller.selectedTimeFilter.value == filter,
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
        
              /// Expense / Income Dropdown
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
                      items: ['Expense', 'Income'].map((e) {
                        return DropdownMenuItem(
                          value: e,
                          child: Text(
                            e,
                            style: const TextStyle(
                              fontFamily: 'Montserrat-Regular',
                              fontSize: 14,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) controller.setType(value);
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
        
              /// ✅ Graph Container Only
              Obx(() {
                final barGroups =
                controller.getBarChartData(controller.filteredTransactions);
        
                return Container(
                  height: 250,
                  decoration: BoxDecoration(
                    color: kBlackColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(12),
        
                  /// 🔹 Wrap with InteractiveViewer for scroll + zoom
                  child: InteractiveViewer(
                    panEnabled: true, // allow drag
                    scaleEnabled: true, // allow pinch zoom
                    minScale: 0.8,
                    maxScale: 3.0,
                    boundaryMargin: const EdgeInsets.all(20), // allow dragging outside bounds
                    child: SizedBox(
                      width: barGroups.length * 60, // dynamic width per bar group
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceBetween,
                            maxY: controller.maxYValue,
                            barGroups: barGroups,
                            gridData: FlGridData(show: true,),
                            borderData: FlBorderData(show: false),
        
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  maxIncluded: true,
                                  reservedSize: 30,
                                  getTitlesWidget: (value, meta) {
                                    const monthsShort = [
                                      "Jan","Feb","Mar","Apr","May","Jun",
                                      "Jul","Aug","Sep","Oct","Nov","Dec"
                                    ];
                                    final index = value.toInt();
                                    if (index >= 0 && index < 12) {
                                      return SideTitleWidget(
                                        meta: meta,
                                        child: Text(
                                          monthsShort[index],
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                      );
                                    }
                                    return const SizedBox();
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  interval: (controller.maxYValue / 5).ceilToDouble(),
                                  getTitlesWidget: (value, meta) {
                                    return SideTitleWidget(
                                      meta: meta,
                                      child: Text(
                                        value.toInt().toString(),
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            ),
        
                            extraLinesData: ExtraLinesData(horizontalLines: []),
                            baselineY: 0,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
        
        
              const SizedBox(height: 30),
        
              /// ✅ Top Spending / Income
              /// ✅ Top Spending / Income
              Obx(() {
                final topTx = controller.getTopTransactions(limit: 5);
        
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.selectedType.value == "Expense"
                          ? "Top Spending"
                          : "Top Income",
                      style: const TextStyle(
                        fontFamily: 'Montserrat-SemiBold',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: kBlackColor,
                      ),
                    ),
                    const SizedBox(height: 10),
        
                    if (topTx.isEmpty)
                      const Text("No data available"),
                    ...topTx.map((tx) => ListTile(
                      dense: true,
                      leading: CircleAvatar(
                        backgroundColor: controller.selectedType.value == "Expense"
                            ? Colors.red.withOpacity(0.2)
                            : Colors.blue.withOpacity(0.2),
                        child: Icon(
                          controller.selectedType.value == "Expense"
                              ? Icons.arrow_downward
                              : Icons.arrow_upward,
                          color: controller.selectedType.value == "Expense"
                              ? Colors.red
                              : Colors.blue,
                        ),
                      ),
                      title: Text(tx.category),
                      subtitle: Text(
                        "${tx.date}", // you can format with intl: DateFormat('dd MMM').format(tx.date)
                        style: const TextStyle(fontSize: 12),
                      ),
                      trailing: Text(
                        "₹${tx.amount.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    )),
                  ],
                );
              }),
        
            ],
          ),
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
}
