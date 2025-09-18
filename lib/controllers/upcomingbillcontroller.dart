import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class UpcomingBillsController extends GetxController {
  final formKey = GlobalKey<FormState>();

  // Controllers
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final noteController = TextEditingController();
  final dateController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // Reactive bills list
  var bills = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initNotifications();
    fetchBills();
  }

  // ========== Init Notifications ==========
  Future<void> _initNotifications() async {
    const AndroidInitializationSettings androidInit =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
    InitializationSettings(android: androidInit);

    await _notificationsPlugin.initialize(initSettings);
  }

  // ========== Save Bill ==========
  Future<void> saveBill() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Get.snackbar("Error", "User not logged in");
        return;
      }

      double amount = double.tryParse(amountController.text.trim()) ?? 0.0;
      String title = titleController.text.trim();
      String note = noteController.text.trim();
      String dateStr = dateController.text.trim();

      if (title.isEmpty || dateStr.isEmpty) {
        Get.snackbar("Error", "Title & Date required");
        return;
      }

      // Parse date (dd/MM/yyyy)
      List<String> parts = dateStr.split("/");
      DateTime dueDate = DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );

      // Save to Firestore
      DocumentReference docRef = await _firestore
          .collection("users")
          .doc(user.uid)
          .collection("bills")
          .add({
        "title": title,
        "amount": amount,
        "note": note,
        "dueDate": dueDate,
        "timestamp": FieldValue.serverTimestamp(),
      });

      // Request permission and schedule notification
      await _requestAndScheduleNotification(docRef.id, title, dueDate);

      Get.back();
      Get.snackbar("Success", "Bill added successfully!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blueAccent.withOpacity(0.9),
          colorText: Colors.white);

      clearFields();
    } catch (e) {
      print("Error ${e.toString()}");
      Get.snackbar("Error", "Failed to save bill: $e");
    }
  }

  // ========== Request Permission & Schedule Notification ==========
  Future<void> _requestAndScheduleNotification(
      String id, String title, DateTime dueDate) async {
    if (await Permission.scheduleExactAlarm.request().isGranted) {
      // Permission granted
      await _scheduleBillNotification(id, title, dueDate);
    } else {
      // Permission denied
      Get.snackbar(
        "Permission Required",
        "Enable exact alarms to receive notifications at the correct time.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orangeAccent.withOpacity(0.9),
        colorText: Colors.white,
      );
    }
  }

  // ========== Schedule Notification ==========
  Future<void> _scheduleBillNotification(
      String id, String title, DateTime dueDate) async {
    final scheduledTime = tz.TZDateTime(
      tz.local,
      dueDate.year,
      dueDate.month,
      dueDate.day,
      8,
      0,
    );

    if (scheduledTime.isBefore(DateTime.now())) return;

    await _notificationsPlugin.zonedSchedule(
      id.hashCode,
      "Bill Reminder",
      "Your bill '$title' is due today!",
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          "bills_channel",
          "Bills Reminders",
          channelDescription: "Reminders for upcoming bills",
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );

    // 🔹 Save notification info in Firestore
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .collection("notifications")
          .add({
        "title": "Bill Reminder",
        "body": "Your bill '$title' is due today!",
        "scheduledTime": scheduledTime,
        "createdAt": FieldValue.serverTimestamp(),
        "type": "bill",
        "relatedBillId": id,
      });
    }
  }


  // ========== Fetch Bills (Live) ==========
  void fetchBills() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    _firestore
        .collection("users")
        .doc(user.uid)
        .collection("bills")
        .orderBy("dueDate", descending: false)
        .snapshots()
        .listen((snapshot) {
      bills.value =
          snapshot.docs.map((doc) => {"id": doc.id, ...doc.data()}).toList();
    });
  }

  // ========== Helpers ==========
  void clearFields() {
    titleController.clear();
    amountController.clear();
    noteController.clear();
    dateController.clear();
  }

  String formatDate(DateTime date) {
    return DateFormat("dd/MM/yyyy").format(date);
  }
}
