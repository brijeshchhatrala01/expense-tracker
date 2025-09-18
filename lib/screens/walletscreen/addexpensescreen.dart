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
            color: Colors.white,
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
                color: kWhiteColor,
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
                    Obx(() {
                      final categoryItems = controller.categories
                          .map((cat) => DropdownMenuItem<String>(
                        value: cat["name"].toString(),
                        child: Text("${cat["emoji"]} ${cat["name"]}"),
                      ))
                          .toList();

                      categoryItems.add(
                        const DropdownMenuItem<String>(
                          value: "add_new",
                          child: Text("➕ Add New Category"),
                        ),
                      );

                      final selectedValue = controller.selectedCategory.value;
                      final isValidValue = categoryItems.any((item) => item.value == selectedValue);

                      return DropdownButtonFormField<String>(
                        value: isValidValue ? selectedValue : null,
                        items: categoryItems,
                        onChanged: (value) {
                          if (value == "add_new") {
                            _showAddCategoryDialog(context, controller);
                          } else {
                            controller.selectedCategory.value = value ?? "";
                          }
                        },
                        decoration: _inputDecoration("Category", icon: CupertinoIcons.list_bullet),
                        dropdownColor: kWhiteColor,
                        borderRadius: BorderRadius.circular(12),
                        style: const TextStyle(
                          fontFamily: 'Montserrat-Regular',
                          fontSize: 14,
                          color: kBlackColor,
                          fontWeight: FontWeight.w500,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return "Select category";
                          return null;
                        },
                      );
                    }),

                    const SizedBox(height: 16),

                      // Payment Method
                    Obx(() {
                      return DropdownButtonFormField<String>(
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
                        decoration: _inputDecoration("Payment Method", icon: CupertinoIcons.creditcard),
                        dropdownColor: kWhiteColor,
                        borderRadius: BorderRadius.circular(12),
                        style: const TextStyle(
                          fontFamily: 'Montserrat-Regular',
                          fontSize: 14,
                          color: kBlackColor,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }),
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
              print('Form Validate');
              controller.saveExpense();
            }
          },
          buttonHeight: 60,
          buttonWidth: double.infinity,
          buttonColor: kBlackColor, // Different from Income
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

  void _showAddCategoryDialog(BuildContext context, AddExpenseController controller) {
    final nameController = TextEditingController();
    final emojiController = TextEditingController();

    InputDecoration _dialogInputDecoration(String label) {
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

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: kWhiteColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Add New Category",
                    style: TextStyle(
                      fontFamily: 'Montserrat-Regular',
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Emoji Field
                  TextField(
                    controller: emojiController,
                    cursorColor: kBlackColor,
                    decoration: _dialogInputDecoration("Emoji (e.g., 🛍)"),
                  ),
                  const SizedBox(height: 12),

                  // Name Field
                  TextField(
                    controller: nameController,
                    cursorColor: kBlackColor,
                    decoration: _dialogInputDecoration("Category Name"),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel",style: TextStyle(color: kBlackColor),),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kBlackColor,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          if (nameController.text.trim().isNotEmpty) {
                            await controller.addCategory(
                              nameController.text.trim(),
                              emojiController.text.trim().isEmpty ? "📂" : emojiController.text.trim(),
                            );
                            Navigator.pop(context);
                          }
                        },
                        child: const Text(
                          "Save",
                          style: TextStyle(
                            fontFamily: 'Montserrat-Regular',
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
