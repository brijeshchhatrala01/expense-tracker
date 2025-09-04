import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constant/colorsfile.dart';

class AddIncomeController extends GetxController {
  final amountController = TextEditingController();
  final noteController = TextEditingController();
  final dateController = TextEditingController();

  var selectedCategory = "".obs;
  var selectedDate = DateTime.now().obs;

  final uid = FirebaseAuth.instance.currentUser?.uid;

  /// Pick Date
  Future<void> pickDate(BuildContext context, Color primaryColor) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor, // header, selected date, buttons
              onPrimary: Colors.white,
              onSurface: kBlackColor,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      selectedDate.value = picked;
      dateController.text =
      "${picked.day}/${picked.month}/${picked.year}"; // show in textfield
    }
  }

  /// Save Income to Firestore
  Future<void> saveIncome() async {
    // Validation
    if (amountController.text.isEmpty ||
        selectedCategory.value.isEmpty ||
        dateController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill all fields",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      double amount = double.parse(amountController.text);

      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("income")
          .add({
        "amount": amount,
        "category": selectedCategory.value,
        "note": noteController.text,
        "date": selectedDate.value,
        "timestamp": FieldValue.serverTimestamp(),
      });

      Get.snackbar(
        "Success",
        "Income added successfully!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      // Clear fields
      amountController.clear();
      noteController.clear();
      dateController.clear();
      selectedCategory.value = "";
      selectedDate.value = DateTime.now();

      Get.back(); // go back after saving
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
