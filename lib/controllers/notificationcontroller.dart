import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  var notifications = <Map<String, dynamic>>[].obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  void fetchNotifications() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    _firestore
        .collection("users")
        .doc(user.uid)
        .collection("notifications")
        .orderBy("scheduledTime", descending: true)
        .snapshots()
        .listen((snapshot) {
      notifications.value =
          snapshot.docs.map((doc) => {"id": doc.id, ...doc.data()}).toList();
    });
  }
}
