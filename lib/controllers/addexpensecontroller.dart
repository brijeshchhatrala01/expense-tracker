import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../firebase_service/firebase_auth/authentication_service.dart';
import 'walletcontroller.dart';

class AddExpenseController extends GetxController {
  // Controllers
  final amountController = TextEditingController();
  final noteController = TextEditingController();
  final dateController = TextEditingController();

  // Reactive values
  var selectedCategory = "".obs;
  var selectedPayment = "".obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Pick Date
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
              primary: primaryColor, // header, selected date
              onPrimary: Colors.white, // text color on primary
              onSurface: Colors.black, // body text color
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      dateController.text =
      "${picked.day}/${picked.month}/${picked.year}";
    }
  }

  // Save Expense
  Future<void> saveExpense() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Get.snackbar("Error", "User not logged in");
        return;
      }

      double amount = double.tryParse(amountController.text.trim()) ?? 0.0;

      // Save expense to Firestore
      await _firestore
          .collection("users")
          .doc(user.uid)
          .collection("transactions")
          .add({
        "type": "expense",
        "amount": amount,
        "category": selectedCategory.value,
        "paymentMethod": selectedPayment.value,
        "note": noteController.text.trim(),
        "date": dateController.text.trim(),
        "timestamp": FieldValue.serverTimestamp(),
      });

      // Update Wallet balance
      final walletController = Get.find<WalletController>();
      walletController.totalBalance.value -= amount;

      // Success snackbar
      Get.snackbar(
        "Success",
        "Expense added successfully!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.9),
        colorText: Colors.white,
      );

      // Clear fields
      amountController.clear();
      noteController.clear();
      dateController.clear();
      selectedCategory.value = "";
      selectedPayment.value = "";

      // Go back
      Get.back();

    } catch (e) {
      Get.snackbar("Error", "Failed to save expense: $e");
    }
  }
}
