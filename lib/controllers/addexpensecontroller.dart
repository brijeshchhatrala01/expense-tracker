import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'walletcontroller.dart';

class AddExpenseController extends GetxController {
  // Form key
  final formKey = GlobalKey<FormState>();

  // Controllers
  final amountController = TextEditingController();
  final noteController = TextEditingController();
  final dateController = TextEditingController();

  // Reactive values
  var selectedCategory = "".obs;
  var selectedPayment = "".obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var categories = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories(); // fetch when screen opens
  }


  // ========== Category Management ==========
  Future<void> fetchCategories() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await _firestore
        .collection("users")
        .doc(user.uid)
        .collection("categories")
        .get();

    categories.value = snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<void> addCategory(String name, String emoji) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await _firestore
        .collection("users")
        .doc(user.uid)
        .collection("categories")
        .add({
      "name": name,
      "emoji": emoji,
    });

    await fetchCategories();
  }

  // ========== Date Picker ==========
  Future<void> pickDate(BuildContext context, Color primaryColor) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      dateController.text = "${picked.day}/${picked.month}/${picked.year}";
    }
  }

  // ========== Expense Save ==========
  Future<void> saveExpense() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Get.snackbar("Error", "User not logged in");
        return;
      }

      // if (!formKey.currentState!.validate()) return;

      double amount = double.tryParse(amountController.text.trim()) ?? 0.0;
      String category = selectedCategory.value;
      String paymentMethod = selectedPayment.value;
      String note = noteController.text.trim();
      String date = dateController.text.trim();
      // Timestamp timestamp = Timestamp.now(); // temp until server sets it

      // /// 🔹 Print all values before saving
      // print("======== EXPENSE DEBUG ========");
      // print("User ID       : ${user.uid}");
      // print("Type          : expense");
      // print("Amount        : $amount");
      // print("Category      : $category");
      // print("PaymentMethod : $paymentMethod");
      // print("Note          : $note");
      // print("Date (string) : $date");
      // print("Timestamp     : $timestamp (will be serverTimestamp)");
      // print("================================");
      //
      await _firestore
          .collection("users")
          .doc(user.uid)
          .collection("transactions")
          .add({
        "type": "expense",
        "amount": amount,
        "category": category,
        "paymentMethod": paymentMethod,
        "note": note,
        "date": date,
        "timestamp": FieldValue.serverTimestamp(),
      });

      // Wallet update
      final walletController = Get.find<WalletController>();
      walletController.totalBalance.value -= amount;

      Get.back();
      // Success
      Get.snackbar(
        "Success",
        "Expense added successfully!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.9),
        colorText: Colors.white,
      );

      clearFields();

    } catch (e) {
      Get.snackbar("Error", "Failed to save expense: $e");
    }
  }

  // ========== Helpers ==========
  void clearFields() {
    amountController.clear();
    noteController.clear();
    dateController.clear();
    selectedCategory.value = "";
    selectedPayment.value = "";
  }

  InputDecoration inputDecoration(String label, {IconData? icon, Color color = Colors.black}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon != null ? Icon(icon, color: color) : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
