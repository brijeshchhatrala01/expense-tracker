// controllers/barchartscreencontroller.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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


  void fetchTransactions() {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    _firestore
        .collection('users')
        .doc(uid)
        .collection('transactions')
        .snapshots()
        .listen((transactionsSnap) {
      final temp = transactionsSnap.docs
          .map((doc) => TransactionModel.fromFirestore(doc))
          .toList();

      allTransactions.value = temp;
      applyFilters();
    });

    _firestore
        .collection('users')
        .doc(uid)
        .collection('income')
        .snapshots()
        .listen((incomeSnap) {
      final incomeList = incomeSnap.docs.map((doc) {
        final model = TransactionModel.fromFirestore(doc);
        return TransactionModel(
          amount: model.amount,
          category: model.category,
          note: model.note,
          type: "income",
          paymentMethod: model.paymentMethod,
          date: model.date,
          timestamp: model.timestamp,
        );
      }).toList();

      allTransactions.addAll(incomeList);
      applyFilters();
    });
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
  /// 🔹 Prepare line chart data based on selected filter
  /// 🔹 Generate line chart data based on selected filter
  Map<String, List<_ChartData>> getLineChartData() {
    Map<int, double> incomeMap = {};
    Map<int, double> expenseMap = {};

    for (var tx in filteredTransactions) {
      DateTime date = tx.timestamp.toDate();
      int keyIndex;

      switch (selectedTimeFilter.value) {
        case 'Day':
          keyIndex = date.hour; // 0–23
          break;
        case 'Week':
          keyIndex = date.weekday; // 1–7 (Mon=1, Sun=7)
          break;
        case 'Month':
          keyIndex = date.month; // 1–12 (Jan=1, Dec=12)
          break;
        case 'Year':
          keyIndex = date.year; // group by year
          break;
        default:
          keyIndex = date.month;
      }

      if (tx.type.toLowerCase() == "income") {
        incomeMap[keyIndex] = (incomeMap[keyIndex] ?? 0) + tx.amount;
      } else if (tx.type.toLowerCase() == "expense") {
        expenseMap[keyIndex] = (expenseMap[keyIndex] ?? 0) + tx.amount;
      }
    }

    // 🔹 Generate full ranges depending on filter
    int rangeCount;
    switch (selectedTimeFilter.value) {
      case 'Day':
        rangeCount = 24; // 24 hours
        break;
      case 'Week':
        rangeCount = 7; // 7 days
        break;
      case 'Month':
        rangeCount = 12; // 12 months
        break;
      case 'Year':
      // dynamic years based on data
        final years = allTransactions.map((e) => e.timestamp.toDate().year).toSet().toList()..sort();
        rangeCount = years.length;
        break;
      default:
        rangeCount = 12;
    }

    final incomeData = List.generate(rangeCount, (i) {
      int key = (selectedTimeFilter.value == 'Year')
          ? allTransactions.map((e) => e.timestamp.toDate().year).toSet().toList()[i]
          : i + (selectedTimeFilter.value == 'Day' ? 0 : 1);
      return _ChartData(key, incomeMap[key] ?? 0);
    });

    final expenseData = List.generate(rangeCount, (i) {
      int key = (selectedTimeFilter.value == 'Year')
          ? allTransactions.map((e) => e.timestamp.toDate().year).toSet().toList()[i]
          : i + (selectedTimeFilter.value == 'Day' ? 0 : 1);
      return _ChartData(key, expenseMap[key] ?? 0);
    });

    return {
      "income": incomeData,
      "expense": expenseData,
    };
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
class _ChartData {
  final int index; // x-axis position
  final double amount;
  _ChartData(this.index, this.amount);
}
