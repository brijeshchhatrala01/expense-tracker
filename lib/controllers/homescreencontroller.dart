import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeController extends GetxController {
  var greeting = "".obs;
  var userName = "".obs;
  var totalBalance = 0.0.obs;
  var income = 0.0.obs;
  var expenses = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    setGreeting();
    fetchUserData();
  }

  /// Set greeting based on device time
  void setGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      greeting.value = "Good Morning,";
    } else if (hour < 17) {
      greeting.value = "Good Afternoon,";
    } else {
      greeting.value = "Good Evening,";
    }
  }

  /// Fetch user data from Firestore
  void fetchUserData() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .get();

        if (snapshot.exists) {
          userName.value = snapshot["name"] ?? "User";
          totalBalance.value = (snapshot["balance"] ?? 0).toDouble();
          income.value = (snapshot["income"] ?? 0).toDouble();
          expenses.value = (snapshot["expenses"] ?? 0).toDouble();
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }
}
