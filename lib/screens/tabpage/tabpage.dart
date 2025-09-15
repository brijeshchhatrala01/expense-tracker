import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../constant/icons.dart';
import '../../controllers/navcontroller.dart';
import '../../widgets/custombottomnav.dart';
import '../barchartscreen/barchartscreen.dart';
import '../homescreen/homescreen.dart';
import '../profilescreen/profilescreen.dart';
import '../walletscreen/walletscreen.dart';

class TabPage extends StatelessWidget {
   TabPage({super.key});
  final tabControllerX = Get.put(TabControllerX());

  final List<Widget> _pages = [
    HomeScreen(),
    BarChartScreen(),
    WalletScreen(),
    ProfileScreen(),
  ];



  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      body: _pages[tabControllerX.selectedIndex.value],
      bottomNavigationBar: CustomBottomNavBar(
        icons: iconsList,
        selectedIndex: tabControllerX.selectedIndex.value,
        onTap: tabControllerX.changeTab,
      ),
    ));
  }
}
