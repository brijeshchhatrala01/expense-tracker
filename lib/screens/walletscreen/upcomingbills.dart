import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expence_tracker/constant/colorsfile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/upcomingbillcontroller.dart';
import '../../widgets/customcontainerbutton.dart';

class UpcomingBillsScreen extends StatelessWidget {
  UpcomingBillsScreen({super.key});

  final UpcomingBillsController controller = Get.put(UpcomingBillsController());

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
      errorStyle: const TextStyle(
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
          icon: const Icon(CupertinoIcons.back, color: Colors.white),
        ),
        title: const Text(
          'Upcoming Bills',
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
          key: controller.formKey,
          child: Column(
            children: [
              // Add Bill Card
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
                      // Title
                      TextFormField(
                        controller: controller.titleController,
                        cursorColor: kBlackColor,
                        decoration: _inputDecoration(
                          "Bill Title",
                          icon: CupertinoIcons.doc_text,
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? "Enter title"
                            : null,
                      ),
                      const SizedBox(height: 16),

                      // Amount
                      TextFormField(
                        controller: controller.amountController,
                        cursorColor: kBlackColor,
                        keyboardType: TextInputType.number,
                        decoration: _inputDecoration(
                          "Amount",
                          icon: Icons.currency_rupee,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty)
                            return "Enter amount";
                          if (double.tryParse(value.trim()) == null)
                            return "Enter valid number";
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Due Date
                      TextFormField(
                        controller: controller.dateController,
                        cursorColor: kBlackColor,
                        readOnly: true,
                        decoration: _inputDecoration(
                          "Due Date",
                          icon: CupertinoIcons.calendar,
                        ),
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: kBlackColor,
                                    // Header background color
                                    onPrimary: Colors.white,
                                    // Header text color
                                    onSurface:
                                        kBlackColor, // Calendar day text color
                                  ),
                                  dialogBackgroundColor: Colors
                                      .white, // Background of the calendar
                                ),
                                child: child!,
                              );
                            },
                          );

                          if (picked != null) {
                            controller.dateController.text =
                                "${picked.day}/${picked.month}/${picked.year}";
                          }
                        },
                        validator: (value) => value == null || value.isEmpty
                            ? "Select date"
                            : null,
                      ),
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
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Upcoming Bills List
              const Text(
                "Upcoming Bills List",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: "Montserrat-Regular",
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              Obx(() {
                if (controller.bills.isEmpty) {
                  return const Text("No upcoming bills found");
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.bills.length,
                  itemBuilder: (context, index) {
                    final bill = controller.bills[index];
                    final dueDate = (bill["dueDate"] as Timestamp).toDate();
                    return Card(
                      color: kWhiteColor,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: const Icon(CupertinoIcons.doc_text),
                        title: Text(bill["title"] ?? "No title"),
                        subtitle: Text(
                          "Due: ${controller.formatDate(dueDate)}\n${bill["note"] ?? ""}",
                        ),
                        trailing: Text("₹ ${bill["amount"] ?? 0}"),
                      ),
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomContainerButton(
          onPressed: () {
            if (controller.formKey.currentState!.validate()) {
              controller.saveBill();
            }
          },
          buttonHeight: 60,
          buttonWidth: double.infinity,
          buttonColor: kBlackColor,
          // Different from Income
          buttonRadius: 12,
          buttonText: 'Add Bill',
          buttonTextFontWeight: FontWeight.w600,
          buttonTextFontFamily: 'Montserrat-Regular',
          buttonTextFontSize: 16,
          buttonTextColor: kWhiteColor,
        ),
      ),
    );
  }
}
