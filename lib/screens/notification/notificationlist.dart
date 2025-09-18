import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expence_tracker/constant/colorsfile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/notificationcontroller.dart';

class NotificationListScreen extends StatelessWidget {
  final controller = Get.put(NotificationController());

   NotificationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(CupertinoIcons.back, color: kWhiteColor),
        ),
        title: const Text("Notifications"),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.notifications.isEmpty) {
          return const Center(child: Text("No notifications yet"));
        }

        return ListView.builder(
          itemCount: controller.notifications.length,
          itemBuilder: (context, index) {
            final notif = controller.notifications[index];
            final scheduledTime = (notif["scheduledTime"] as Timestamp?)
                ?.toDate();

            return Card(
              color: kWhiteColor,
              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              child: ListTile(
                leading: const Icon(Icons.notifications),
                title: Text(notif["title"] ?? ""),
                subtitle: Text(notif["body"] ?? ""),
                trailing: scheduledTime != null
                    ? Text(
                        "${scheduledTime.day}/${scheduledTime.month}/${scheduledTime.year} ${scheduledTime.hour}:${scheduledTime.minute.toString().padLeft(2, '0')}",
                      )
                    : null,
              ),
            );
          },
        );
      }),
    );
  }
}
