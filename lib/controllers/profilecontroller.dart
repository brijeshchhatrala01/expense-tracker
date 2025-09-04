import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileController extends GetxController {
  var name = ''.obs;
  var email = ''.obs;
  var photoUrl = ''.obs; // 👈 added photo
  var isLoading = true.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      isLoading.value = true;

      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot doc =
        await _firestore.collection('users').doc(user.uid).get();

        if (doc.exists) {
          name.value = doc['name'] ?? '';
          email.value = doc['email'] ?? '';
          photoUrl.value = doc['photoUrl'] ?? ''; // 👈 fetch photoUrl
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
