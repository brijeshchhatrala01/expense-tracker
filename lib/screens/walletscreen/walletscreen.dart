import 'package:expence_tracker/screens/walletscreen/addexpensescreen.dart';
import 'package:expence_tracker/screens/walletscreen/upcomingbills.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../constant/colorsfile.dart';
import '../../controllers/walletcontroller.dart';
import 'addincomescreen.dart';

class WalletScreen extends StatelessWidget {
  WalletScreen({super.key});

  final WalletController controller = Get.put(WalletController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Balance Card
            Container(
              height: 170,
              width: double.infinity,
              decoration: BoxDecoration(
                color: kBlackColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(
                    () => Text(
                      'Total Balance : ₹${controller.totalBalance.value.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: kWhiteColor,
                        fontFamily: 'Montserrat-Regular',
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  20.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.to(() => AddIncomeScreen());
                        },
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              'assets/svgIcons/add.svg',
                              height: 50,
                              width: 50,
                              color: kWhiteColor,
                            ),
                            10.verticalSpace,
                            Text(
                              'Income',
                              style: TextStyle(
                                color: kWhiteColor,
                                fontFamily: 'Montserrat-Regular',
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(() => AddExpenseScreen());
                        },
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              'assets/svgIcons/send.svg',
                              height: 50,
                              width: 50,
                              color: kWhiteColor,
                            ),
                            10.verticalSpace,
                            Text(
                              'Expense',
                              style: TextStyle(
                                color: kWhiteColor,
                                fontFamily: 'Montserrat-Regular',
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(() => UpcomingBillsScreen());
                        },
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              'assets/svgIcons/upcoming.svg',
                              // <- add a calendar or reminder icon in assets/svgIcons
                              height: 50,
                              width: 50,
                              color: kWhiteColor,
                            ),
                            10.verticalSpace,
                            Text(
                              'Bills',
                              style: TextStyle(
                                color: kWhiteColor,
                                fontFamily: 'Montserrat-Regular',
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            30.verticalSpace,

            // Segmented Control
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  _buildTabButton("Transactions", 0),
                  _buildTabButton("Upcoming Bills", 1),
                ],
              ),
            ),
            20.verticalSpace,

            // List Content
            Expanded(
              child: Obx(() {
                if (controller.selectedIndex.value == 0) {
                  // 🔹 Transactions Tab
                  if (controller.transactions.isEmpty) {
                    return Center(
                      child: Text(
                        "No transactions yet",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Montserrat-Regular',
                          fontWeight: FontWeight.w500,
                          color: kBlackColor,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: controller.transactions.length,
                    itemBuilder: (context, index) {
                      final tx = controller.transactions[index];
                      bool isIncome =
                          (tx["type"].toString().toLowerCase() == "income");

                      return Card(
                        color: kWhiteColor,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isIncome
                                ? Colors.green
                                : Colors.red,
                            child: Icon(
                              isIncome
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(tx["category"]),
                          subtitle: Text(
                            "${tx["date"].day}/${tx["date"].month}/${tx["date"].year}\n${tx["note"]} (${tx["paymentMethod"]})",
                          ),
                          trailing: Text(
                            "₹${tx["amount"].toStringAsFixed(2)}",
                            style: TextStyle(
                              color: isIncome ? Colors.green : Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  // 🔹 Upcoming Bills Tab
                  if (controller.upcomingBills.isEmpty) {
                    return Center(
                      child: Text(
                        "No upcoming bills",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Montserrat-Regular',
                          fontWeight: FontWeight.w500,
                          color: kBlackColor,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: controller.upcomingBills.length,
                    itemBuilder: (context, index) {
                      final bill = controller.upcomingBills[index];
                      final dueDate = bill["dueDate"] as DateTime;

                      return Card(
                        color: kWhiteColor,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: const Icon(
                            Icons.calendar_today,
                            color: Colors.orange,
                          ),
                          title: Text(bill["title"] ?? "No Title"),
                          subtitle: Text(
                            "Due: ${dueDate.day}/${dueDate.month}/${dueDate.year}\n${bill["note"] ?? ""}",
                          ),
                          trailing: Text(
                            "₹${bill["amount"].toStringAsFixed(2)}",
                            style: const TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  // Custom Tab Button
  Expanded _buildTabButton(String text, int index) {
    return Expanded(
      child: Obx(() {
        bool isSelected = controller.selectedIndex.value == index;
        return GestureDetector(
          onTap: () => controller.changeTab(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            decoration: BoxDecoration(
              color: isSelected ? kBlackColor : Colors.transparent,
              borderRadius: BorderRadius.circular(30),
            ),
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 14,
                fontFamily: 'Montserrat-Regular',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }),
    );
  }
}
