import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blueAccent,
        title: const Text("Expense Tracker"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Balance Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Total Balance",
                      style: TextStyle(color: Colors.white70, fontSize: 16)),
                  SizedBox(height: 8),
                  Text("₹12,000",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Income & Expense Row
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Income",
                            style: TextStyle(color: Colors.green, fontSize: 16)),
                        SizedBox(height: 8),
                        Text("₹20,000",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Expense",
                            style: TextStyle(color: Colors.red, fontSize: 16)),
                        SizedBox(height: 8),
                        Text("₹8,000",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Recent Transactions
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Recent Transactions",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 12),

            // Transaction List
            Column(
              children: const [
                TransactionTile(
                    icon: Icons.fastfood,
                    color: Colors.orange,
                    title: "Food",
                    amount: "- ₹200",
                    date: "2 Sep"),
                TransactionTile(
                    icon: Icons.directions_car,
                    color: Colors.blue,
                    title: "Travel",
                    amount: "- ₹500",
                    date: "1 Sep"),
                TransactionTile(
                    icon: Icons.shopping_bag,
                    color: Colors.purple,
                    title: "Shopping",
                    amount: "- ₹1200",
                    date: "31 Aug"),
              ],
            )
          ],
        ),
      ),

      // Floating Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Add Expense Screen
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, size: 28),
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

  const TransactionTile(
      {super.key,
        required this.icon,
        required this.color,
        required this.title,
        required this.amount,
        required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 6,
              offset: const Offset(0, 4))
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
                Text(title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
                Text(date, style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ),
          Text(amount,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: amount.contains("-") ? Colors.red : Colors.green)),
        ],
      ),
    );
  }
}
