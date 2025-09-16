// controllers/barchartscreencontroller.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/transactionmodel.dart';

class BarChartController extends GetxController {
  RxList<TransactionModel> allTransactions = <TransactionModel>[].obs;
  RxList<TransactionModel> filteredTransactions = <TransactionModel>[].obs;
  RxList<String> months = <String>[].obs; // store sorted months for labels

  RxString selectedTimeFilter = 'Month'.obs;
  RxString selectedType = 'Expense'.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchTransactions();
  }

  /// 🔹 Get top N transactions based on current filter & type
  List<TransactionModel> getTopTransactions({int limit = 5}) {
    // Filter only the selected type (Expense or Income)
    final typeFiltered = filteredTransactions
        .where((tx) => tx.type.toLowerCase() == selectedType.value.toLowerCase())
        .toList();

    // Sort by amount (highest first)
    typeFiltered.sort((a, b) => b.amount.compareTo(a.amount));

    // Return top N
    return typeFiltered.take(limit).toList();
  }


  void fetchTransactions() async {
    final userId = "nseamSbRYxW680v6vZSq7UBNzoL2";
    // Replace with dynamic user UID

    print("UID in FT : ${userId}");
    List<TransactionModel> temp = [];

    // Fetch expenses
    final transactionsSnap = await _firestore
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .get();

    print(transactionsSnap.docs.toString());
    temp.addAll(transactionsSnap.docs.map((doc) {
      return TransactionModel.fromFirestore(doc); // already has type = "expense"
    }));

    // Fetch incomes (force type = "income")
    final incomeSnap = await _firestore
        .collection('users')
        .doc(userId)
        .collection('income')
        .get();

    temp.addAll(incomeSnap.docs.map((doc) {
      final model = TransactionModel.fromFirestore(doc);
      return TransactionModel(
        amount: model.amount,
        category: model.category,
        note: model.note,
        type: "income", // ✅ force income
        paymentMethod: model.paymentMethod,
        date: model.date,
        timestamp: model.timestamp,
      );
    }));

    allTransactions.value = temp;
    applyFilters();
  }

  void setTimeFilter(String filter) {
    selectedTimeFilter.value = filter;
    applyFilters();
  }

  void setType(String type) {
    selectedType.value = type;
    applyFilters();
  }

  double get maxYValue {
    if (filteredTransactions.isEmpty) return 2000;

    final maxAmount = filteredTransactions
        .map((e) => e.amount)
        .reduce((a, b) => a > b ? a : b);

    // Round up to nearest 1000
    final rounded = ((maxAmount / 1000).ceil()) * 2000;

    return rounded.toDouble();
  }



  /// 🔹 Generate grouped bars (Revenue + Expenses) per month
  List<BarChartGroupData> getBarChartData(List<TransactionModel> transactions) {
    Map<int, double> incomeByMonth = {};
    Map<int, double> expenseByMonth = {};

    for (var tx in transactions) {
      int month = tx.timestamp.toDate().month;

      if (tx.type.toLowerCase() == "income") {
        incomeByMonth[month] = (incomeByMonth[month] ?? 0) + tx.amount;
      } else if (tx.type.toLowerCase() == "expense") {
        expenseByMonth[month] = (expenseByMonth[month] ?? 0) + tx.amount;
      }
    }

    // Always show all 12 months
    months.value = List.generate(12, (i) => "${DateTime.now().year}-${i + 1}");

    return List.generate(12, (index) {
      final monthIndex = index + 1; // 1–12
      final income = incomeByMonth[monthIndex] ?? 0;
      final expense = expenseByMonth[monthIndex] ?? 0;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: income,
            color: Colors.blue, // Income
            width: 14,
            borderRadius: BorderRadius.circular(4),
          ),
          BarChartRodData(
            toY: expense,
            color: Colors.red, // Expense
            width: 14,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
        barsSpace: 6,
      );
    });
  }

  /// 🔹 Filter data based on Day / Week / Month / Year
  void applyFilters() {
    DateTime now = DateTime.now();
    DateTime startDate;

    switch (selectedTimeFilter.value) {
      case 'Day':
        startDate = DateTime(now.year, now.month, now.day);
        break;
      case 'Week':
        startDate = now.subtract(Duration(days: now.weekday - 1));
        break;
      case 'Month':
        startDate = DateTime(now.year, now.month);
        break;
      case 'Year':
        startDate = DateTime(now.year);
        break;
      default:
        startDate = DateTime(now.year, now.month);
    }

    filteredTransactions.value = allTransactions.where((tx) {
      final inRange = tx.timestamp.toDate().isAfter(startDate);
      return inRange; // no type filter here, we want both income & expense
    }).toList();
  }
}
