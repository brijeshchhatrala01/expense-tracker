
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class BarChartController extends GetxController {
  var transactions = <Map<String, dynamic>>[].obs;
  var filteredTransactions = <Map<String, dynamic>>[].obs;
  var selectedTimeFilter = 'Day'.obs;
  var selectedType = 'Expense'.obs;

  final uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  void onInit() {
    super.onInit();
    fetchTransactions();
  }

  /// Fetch transactions from Firebase
  void fetchTransactions() async {
    if (uid == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('transactions')
        .orderBy('date', descending: true)
        .get();

    transactions.value =
        snapshot.docs.map((doc) => doc.data()..['id'] = doc.id).toList();

    applyFilters();
  }

  /// Apply filters (type + time)
  void applyFilters() {
    DateTime now = DateTime.now();

    filteredTransactions.value = transactions.where((tx) {
      bool typeMatch = tx['type'] == selectedType.value;

      // Safely parse date
      DateTime txDate;
      if (tx['date'] is Timestamp) {
        txDate = (tx['date'] as Timestamp).toDate();
      } else if (tx['date'] is String) {
        txDate = DateTime.tryParse(tx['date']) ?? DateTime.now();
      } else {
        txDate = DateTime.now();
      }

      bool timeMatch = true;

      switch (selectedTimeFilter.value) {
        case 'Day':
          timeMatch = txDate.day == now.day &&
              txDate.month == now.month &&
              txDate.year == now.year;
          break;
        case 'Week':
          var startOfWeek = now.subtract(Duration(days: now.weekday - 1));
          timeMatch = txDate.isAfter(startOfWeek.subtract(const Duration(days: 1)));
          break;
        case 'Month':
          timeMatch = txDate.month == now.month && txDate.year == now.year;
          break;
        case 'Year':
          timeMatch = txDate.year == now.year;
          break;
      }

      return typeMatch && timeMatch;
    }).toList();
  }

  /// Set the selected time filter
  void setTimeFilter(String filter) {
    selectedTimeFilter.value = filter;
    applyFilters();
  }

  /// Set the selected type filter (Income / Expense)
  void setType(String type) {
    selectedType.value = type;
    applyFilters();
  }

  /// Get top spending list (sorted by amount descending)
  List<Map<String, dynamic>> get topSpending {
    var list = List<Map<String, dynamic>>.from(filteredTransactions);
    list.sort((a, b) => (b['amount'] as num).compareTo(a['amount'] as num));
    return list;
  }
}
