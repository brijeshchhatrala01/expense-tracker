import 'package:expence_tracker/controllers/navcontroller.dart';
import 'package:expence_tracker/controllers/walletcontroller.dart';
import 'package:expence_tracker/constant/colorsfile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/homescreencontroller.dart';

class HomeScreen extends StatelessWidget {
   HomeScreen({super.key});

  final WalletController walletController = Get.put(WalletController());

  final controller = Get.put(HomeController());

 // Inject Controller
  final navController = Get.find<TabControllerX>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // AppBar with rounded bottom
          SliverAppBar(
            backgroundColor: kWhiteColor,
            elevation: 0,
            expandedHeight: 310,
            floating: false,
            pinned: true,
            centerTitle: true,
            title: const Text(
              'Expense-Tracker',
              style: TextStyle(
                fontFamily: 'Montserrat-Regular',
                fontWeight: FontWeight.w600,
                fontSize: 22,
                color: kWhiteColor,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax, // ✅ prevent collapsing
              background: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                  color: kBlackColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 45,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(
                            () => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.greeting.value,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  controller.userName.value,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.notifications, color: Colors.white),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // ✅ Balance card
                      Obx(
                        () => Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: kWhiteColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Total Balance",
                                style: TextStyle(
                                  color: kBlackColor,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Montserrat-Regular',
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                "₹ ${walletController.totalBalance.value.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  color: kBlackColor,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Montserrat-Regular',
                                  fontSize: 28,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.arrow_downward,
                                        color: Colors.green,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 6),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Income",
                                            style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 12,
                                            ),
                                          ),
                                          Text(
                                            "₹ ${walletController.lastIncome.toStringAsFixed(2)}",
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.arrow_upward,
                                        color: Colors.red,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 6),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Expenses",
                                            style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 12,
                                            ),
                                          ),
                                          Text(
                                            "₹ ${walletController.lastExpense.toStringAsFixed(2)}",
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Body content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Transactions Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Transactions History",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          navController.changeTab(2);
                        },
                        child: const Text(
                          "See all",
                          style: TextStyle(color: Colors.teal),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // ✅ Dynamic Transactions List
                  Obx(() {
                    if (walletController.transactions.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text("No transactions yet"),
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: walletController.transactions.length,
                      itemBuilder: (context, index) {
                        final tx = walletController.transactions[index];
                        final isIncome =
                            tx["type"].toString().toLowerCase() == "income";

                        return TransactionTile(
                          icon: isIncome
                              ? Icons.arrow_downward
                              : Icons.arrow_upward,
                          color: isIncome ? Colors.green : Colors.red,
                          title: tx["category"],
                          amount:
                              "${isIncome ? "+" : "-"} ₹${tx["amount"].toStringAsFixed(2)}",
                          date:
                              "${tx["date"].day}/${tx["date"].month}/${tx["date"].year}",
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Transaction List Item
class TransactionTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String amount;
  final String date;

  const TransactionTile({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.amount,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(date, style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: amount.contains("-") ? Colors.red : Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
