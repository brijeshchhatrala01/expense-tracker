import 'package:expence_tracker/constant/colorsfile.dart';
import 'package:expence_tracker/firebase_service/firebase_auth/authentication_service.dart';
import 'package:expence_tracker/screens/notification/notificationlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../controllers/profilecontroller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Expense-Tracker',
          style: TextStyle(
            fontFamily: 'Montserrat-Regular',
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: double.infinity,
                  height: 214,
                  decoration: const BoxDecoration(
                    color: kBlackColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(100),
                      bottomRight: Radius.circular(100),
                    ),
                  ),
                ),
                const Positioned(
                  top: 20,
                  left: 150,
                  child: Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Montserrat-SemiBold',
                      color: kWhiteColor,
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  right: 20,
                  child: InkWell(
                    onTap: () {
                      Get.to(()=> NotificationListScreen());
                    },
                    child: SvgPicture.asset(
                      'assets/svgIcons/notification.svg',
                      height: 40,
                      width: 40,
                    ),
                  ),
                ),
                Positioned(
                  top: 144,
                  left: MediaQuery.of(context).size.width / 2 - 45,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: controller.photoUrl.value.isNotEmpty
                        ? NetworkImage(
                            controller.photoUrl.value,
                          ) // Google/Firestore photo
                        : const AssetImage('assets/profile.png')
                              as ImageProvider, // fallback                  ),
                  ),
                ),
              ],
            ),
            110.verticalSpace,
            Text(
              controller.name.value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400,
                fontFamily: 'Montserrat-SemiBold',
                color: kBlackColor,
              ),
            ),
            10.verticalSpace,
            Text(
              controller.email.value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                fontFamily: 'Montserrat-Regular',
                color: kBlackColor,
              ),
            ),

            60.verticalSpace,
            ProfileRow(
              svgAsset: 'assets/svgIcons/user-square.svg',
              title: 'Account info',
            ),
            10.verticalSpace,
            ProfileRow(
              svgAsset: 'assets/svgIcons/customer-support.svg',
              title: 'Help & Support',
            ),
            10.verticalSpace,
            ProfileRow(
              svgAsset: 'assets/svgIcons/customer-support.svg',
              title: 'Logout',
              onTap: () {
                AuthenticationService().logoutUser();
              },
            ),
            20.verticalSpace,
          ],
        );
      }),
    );
  }
}

class ProfileRow extends StatelessWidget {
  final String title;
  final String svgAsset;
  final VoidCallback? onTap; // ✅ added callback

  const ProfileRow({
    super.key,
    required this.title,
    required this.svgAsset,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
      child: InkWell(
        onTap: onTap, // ✅ trigger callback on tap
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: kBlackColor,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                svgAsset,
                height: 24,
                width: 24,
              ),
              const SizedBox(width: 16), // spacing between icon & text
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Montserrat-SemiBold',
                    color: kBlackColor,
                  ),
                ),
              ),
              // Optional: you can add an arrow icon at end if needed
              // Icon(Icons.arrow_forward_ios, size: 16, color: kBlackColor),
            ],
          ),
        ),
      ),
    );
  }
}
