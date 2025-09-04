import 'package:expence_tracker/constant/colorsfile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/addexpensecontroller.dart';
import '../../widgets/customcontainerbutton.dart';

class AddExpenseScreen extends StatelessWidget {
  AddExpenseScreen({super.key});

  final controller = Get.put(AddExpenseController());
  final _formKey = GlobalKey<FormState>();

  // Reusable Input Decoration
  InputDecoration _inputDecoration(String label, {IconData? icon}) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        fontFamily: 'Montserrat-Regular',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: kBlackColor.withOpacity(0.8),
      ),
      hintStyle: TextStyle(
        fontFamily: 'Montserrat-Regular',
        fontSize: 13,
        color: kBlackColor.withOpacity(0.6),
      ),
      errorStyle: TextStyle(
        fontFamily: 'Montserrat-Regular',
        fontSize: 12,
        color: Colors.red,
      ),
      prefixIcon: icon != null ? Icon(icon, color: kBlackColor) : null,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: kBlackColor, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: kBlackColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            CupertinoIcons.back,
            color: Colors.black,
          ),
        ),
        title: const Text(
          'Add Expense',
          style: TextStyle(
            fontFamily: 'Montserrat-Regular',
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      // Amount
                      TextFormField(
                        controller: controller.amountController,
                        keyboardType: TextInputType.number,
                        cursorColor: kBlackColor,
                        decoration: _inputDecoration(
                          "Amount",
                          icon: Icons.currency_rupee,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Enter amount";
                          }
                          if (double.tryParse(value.trim()) == null) {
                            return "Enter valid number";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Category
                      Obx(() => DropdownButtonFormField<String>(
                        decoration: _inputDecoration("Category", icon: CupertinoIcons.list_bullet),
                        value: controller.selectedCategory.value.isEmpty
                            ? null
                            : controller.selectedCategory.value,
                        items: const [
                          DropdownMenuItem(value: "Home", child: Text("🏠 Home")),
                          DropdownMenuItem(value: "Utilities", child: Text("💡 Utilities")),
                          DropdownMenuItem(value: "Groceries", child: Text("🛒 Groceries")),
                          DropdownMenuItem(value: "Maintenance", child: Text("🛠 Maintenance")),
                          DropdownMenuItem(value: "Furniture", child: Text("🪑 Furniture")),
                          DropdownMenuItem(value: "Appliances", child: Text("📺 Appliances")),
                          DropdownMenuItem(value: "Cleaning", child: Text("🧹 Cleaning")),
                          DropdownMenuItem(value: "Internet", child: Text("🌐 Internet")),
                          DropdownMenuItem(value: "Water Bill", child: Text("🚰 Water Bill")),
                          DropdownMenuItem(value: "Gas Bill", child: Text("⛽ Gas Bill")),
                        ],
                        onChanged: (value) {
                          controller.selectedCategory.value = value ?? "";
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Select category";
                          }
                          return null;
                        },
                      )),
                      const SizedBox(height: 16),

                      // Payment Method
                      Obx(() => DropdownButtonFormField<String>(
                        decoration: _inputDecoration("Payment Method", icon: CupertinoIcons.creditcard),
                        value: controller.selectedPayment.value.isEmpty
                            ? null
                            : controller.selectedPayment.value,
                        items: const [
                          DropdownMenuItem(value: "Cash", child: Text("💵 Cash")),
                          DropdownMenuItem(value: "UPI", child: Text("📱 UPI")),
                          DropdownMenuItem(value: "Card", child: Text("💳 Card")),
                        ],
                        onChanged: (value) {
                          controller.selectedPayment.value = value ?? "";
                        },
                      )),
                      const SizedBox(height: 16),

                      // Note
                      TextFormField(
                        controller: controller.noteController,
                        cursorColor: kBlackColor,
                        maxLines: 2,
                        decoration: _inputDecoration(
                          "Note",
                          icon: CupertinoIcons.pencil,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Date
                      TextFormField(
                        controller: controller.dateController,
                        readOnly: true,
                        cursorColor: kBlackColor,
                        decoration: _inputDecoration(
                          "Date",
                          icon: CupertinoIcons.calendar,
                        ),
                        onTap: () =>
                            controller.pickDate(context, kBlackColor),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Select date";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // Save Button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomContainerButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              controller.saveExpense();
            }
          },
          buttonHeight: 60,
          buttonWidth: double.infinity,
          buttonColor: Colors.redAccent, // Different from Income
          buttonRadius: 12,
          buttonText: 'Add Expense',
          buttonTextFontWeight: FontWeight.w600,
          buttonTextFontFamily: 'Montserrat-Regular',
          buttonTextFontSize: 16,
          buttonTextColor: kWhiteColor,
        ),
      ),
    );
  }
}
