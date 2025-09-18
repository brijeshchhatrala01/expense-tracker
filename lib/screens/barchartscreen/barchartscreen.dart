import 'package:expence_tracker/constant/colorsfile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
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

              /// ✅ Graph Container Only
              /// 🔹 Syncfusion Line Chart
              Obx(() {
                final transactions = controller.filteredTransactions;

                List<_ChartData> incomeData = [];
                List<_ChartData> expenseData = [];

                switch (controller.selectedTimeFilter.value) {
                  case 'Day': // 0–23 hours
                    for (int i = 0; i < 24; i++) {
                      final income = transactions
                          .where(
                            (tx) =>
                                tx.type.toLowerCase() == "income" &&
                                tx.timestamp.toDate().hour == i,
                          )
                          .fold(0.0, (sum, tx) => sum + tx.amount);
                      final expense = transactions
                          .where(
                            (tx) =>
                                tx.type.toLowerCase() == "expense" &&
                                tx.timestamp.toDate().hour == i,
                          )
                          .fold(0.0, (sum, tx) => sum + tx.amount);

                      incomeData.add(_ChartData("$i:00", income));
                      expenseData.add(_ChartData("$i:00", expense));
                    }
                    break;

                  case 'Week': // Mon–Sun
                    const days = [
                      "Mon",
                      "Tue",
                      "Wed",
                      "Thu",
                      "Fri",
                      "Sat",
                      "Sun",
                    ];
                    for (int i = 0; i < 7; i++) {
                      final income = transactions
                          .where(
                            (tx) =>
                                tx.type.toLowerCase() == "income" &&
                                tx.timestamp.toDate().weekday == i + 1,
                          )
                          .fold(0.0, (sum, tx) => sum + tx.amount);
                      final expense = transactions
                          .where(
                            (tx) =>
                                tx.type.toLowerCase() == "expense" &&
                                tx.timestamp.toDate().weekday == i + 1,
                          )
                          .fold(0.0, (sum, tx) => sum + tx.amount);

                      incomeData.add(_ChartData(days[i], income));
                      expenseData.add(_ChartData(days[i], expense));
                    }
                    break;

                  case 'Month': // Jan–Dec
                    const months = [
                      "Jan",
                      "Feb",
                      "Mar",
                      "Apr",
                      "May",
                      "Jun",
                      "Jul",
                      "Aug",
                      "Sep",
                      "Oct",
                      "Nov",
                      "Dec",
                    ];
                    for (int i = 1; i <= 12; i++) {
                      final income = transactions
                          .where(
                            (tx) =>
                                tx.type.toLowerCase() == "income" &&
                                tx.timestamp.toDate().month == i,
                          )
                          .fold(0.0, (sum, tx) => sum + tx.amount);
                      final expense = transactions
                          .where(
                            (tx) =>
                                tx.type.toLowerCase() == "expense" &&
                                tx.timestamp.toDate().month == i,
                          )
                          .fold(0.0, (sum, tx) => sum + tx.amount);

                      incomeData.add(_ChartData(months[i - 1], income));
                      expenseData.add(_ChartData(months[i - 1], expense));
                    }
                    break;

                  case 'Year': // show prev, current, next year
                    final currentYear = DateTime.now().year;
                    final years = [
                      currentYear - 1,
                      currentYear,
                      currentYear + 1,
                    ];

                    for (var year in years) {
                      final income = transactions
                          .where(
                            (tx) =>
                                tx.type.toLowerCase() == "income" &&
                                tx.timestamp.toDate().year == year,
                          )
                          .fold(0.0, (sum, tx) => sum + tx.amount);
                      final expense = transactions
                          .where(
                            (tx) =>
                                tx.type.toLowerCase() == "expense" &&
                                tx.timestamp.toDate().year == year,
                          )
                          .fold(0.0, (sum, tx) => sum + tx.amount);

                      incomeData.add(_ChartData(year.toString(), income));
                      expenseData.add(_ChartData(year.toString(), expense));
                    }
                    break;
                }

                return Container(
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: SfCartesianChart(
                    title: ChartTitle(text: "Income vs Expense"),
                    legend: Legend(
                      isVisible: true,
                      position: LegendPosition.bottom,
                    ),
                    primaryXAxis: CategoryAxis(
                      title: AxisTitle(
                        text: controller.selectedTimeFilter.value,
                      ),
                      labelStyle: const TextStyle(fontSize: 10),
                      interval: 1,
                    ),
                    primaryYAxis: NumericAxis(
                      title: AxisTitle(text: "Amount"),
                      interval: (controller.maxYValue / 5).ceilToDouble(),
                    ),
                    tooltipBehavior: TooltipBehavior(enable: true),
                    zoomPanBehavior: ZoomPanBehavior(
                      enablePinching: true,
                      enablePanning: true,
                      zoomMode: ZoomMode.x,
                    ),
                    series: <CartesianSeries<_ChartData, String>>[
                      SplineAreaSeries<_ChartData, String>(
                        name: 'Income',
                        dataSource: incomeData,
                        xValueMapper: (data, _) => data.label,
                        yValueMapper: (data, _) => data.amount,
                        color: Colors.blue.withOpacity(0.6), // fill color
                        borderColor: Colors.blue,           // border line
                        borderWidth: 2,
                      ),
                      SplineAreaSeries<_ChartData, String>(
                        name: 'Expense',
                        dataSource: expenseData,
                        xValueMapper: (data, _) => data.label,
                        yValueMapper: (data, _) => data.amount,
                        color: Colors.red.withOpacity(0.6), // fill color
                        borderColor: Colors.red,           // border line
                        borderWidth: 2,
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 30),

              /// Expense / Income Dropdown
              Align(
                alignment: Alignment.centerRight,
                child: Obx(
                  () => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: DropdownButtonFormField<String>(
                      value: controller.selectedType.value.isEmpty
                          ? null
                          : controller.selectedType.value,
                      items: const [
                        DropdownMenuItem(
                          value: "Expense",
                          child: Text("Expense"),
                        ),
                        DropdownMenuItem(
                          value: "Income",
                          child: Text("Income"),
                        ),
                      ],
                      onChanged: (value) {
                        controller.selectedType.value = value ?? "";
                      },
                      decoration: InputDecoration(
                        labelText: "Transaction Type",
                        labelStyle: const TextStyle(
                          fontFamily: 'Montserrat-Regular',
                          color: kBlackColor,
                          fontSize: 14,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: kBlackColor.withOpacity(0.3),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: kBlackColor.withOpacity(0.3),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: kBlackColor),
                        ),
                      ),
                      dropdownColor: kWhiteColor,
                      style: const TextStyle(
                        fontFamily: 'Montserrat-Regular',
                        fontSize: 14,
                        color: kBlackColor,
                        fontWeight: FontWeight.w500,
                      ),
                      // Added: dropdown menu decoration with rounded corners
                      menuMaxHeight: 200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

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

                    if (topTx.isEmpty) const Text("No data available"),
                    ...topTx.map(
                      (tx) => ListTile(
                        dense: true,
                        leading: CircleAvatar(
                          backgroundColor:
                              controller.selectedType.value == "Expense"
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
                          "${tx.date}",
                          // you can format with intl: DateFormat('dd MMM').format(tx.date)
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing: Text(
                          "₹${tx.amount.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
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

class _ChartData {
  final String label; // can be day, month, or year
  final double amount;

  _ChartData(this.label, this.amount);
}
