import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart' as rxdart;

class WalletController extends GetxController {
  var totalBalance = 0.0.obs;
  var selectedIndex = 0.obs;
  var transactions = [].obs;

  final uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  void onInit() {
    super.onInit();
    fetchBalance();
    fetchTransactions();
  }

  void changeTab(int index) {
    selectedIndex.value = index;
  }

  /// ✅ Fetch Balance from both collections
  void fetchBalance() {
    if (uid == null) return;

    final incomeStream = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("income")
        .snapshots();

    final expenseStream = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("transactions")
        .snapshots();

    rxdart.Rx.combineLatest2(
      incomeStream,
      expenseStream,
          (QuerySnapshot incomeSnap, QuerySnapshot expenseSnap) {
        double income = 0.0;
        double expense = 0.0;

        for (var doc in incomeSnap.docs) {
          income += (doc["amount"] as num?)?.toDouble() ?? 0.0;
        }
        for (var doc in expenseSnap.docs) {
          expense += (doc["amount"] as num?)?.toDouble() ?? 0.0;
        }

        totalBalance.value = income - expense;
      },
    ).listen((_) {});
  }

  /// ✅ Fetch both Income + Expense and merge into transactions list
  void fetchTransactions() {
    if (uid == null) return;

    final incomeStream = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("income")
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        "id": doc.id,
        "type": "income",
        "amount": (data["amount"] as num?)?.toDouble() ?? 0.0,
        "category": data["category"] ?? "Income",
        "note": data["note"] ?? "",
        "paymentMethod": data["paymentMethod"] ?? "",
        "date": (data["timestamp"] as Timestamp?)?.toDate() ??
            DateTime.now(),
      };
    }).toList());

    final expenseStream = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("transactions")
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        "id": doc.id,
        "type": "expense",
        "amount": (data["amount"] as num?)?.toDouble() ?? 0.0,
        "category": data["category"] ?? "Expense",
        "note": data["note"] ?? "",
        "paymentMethod": data["paymentMethod"] ?? "",
        "date": (data["timestamp"] as Timestamp?)?.toDate() ??
            DateTime.now(),
      };
    }).toList());

    rxdart.Rx.combineLatest2<List<Map<String, dynamic>>,
        List<Map<String, dynamic>>, List<Map<String, dynamic>>>(
      incomeStream,
      expenseStream,
          (income, expense) {
        final all = [...income, ...expense];
        all.sort((a, b) => b["date"].compareTo(a["date"])); // latest first
        return all;
      },
    ).listen((merged) {
      transactions.value = merged;
    });
  }

  double get lastIncome {
    try {
      final incomeTxs = transactions
          .where((tx) => tx["type"].toString().toLowerCase() == "income")
          .toList();

      if (incomeTxs.isEmpty) return 0.0;

      incomeTxs.sort((a, b) => b["date"].compareTo(a["date"])); // latest first
      return incomeTxs.first["amount"];
    } catch (e) {
      return 0.0;
    }
  }

  double get lastExpense {
    try {
      final expenseTxs = transactions
          .where((tx) => tx["type"].toString().toLowerCase() == "expense")
          .toList();

      if (expenseTxs.isEmpty) return 0.0;

      expenseTxs.sort((a, b) => b["date"].compareTo(a["date"])); // latest first
      return expenseTxs.first["amount"];
    } catch (e) {
      return 0.0;
    }
  }
}
