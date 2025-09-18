import 'package:expence_tracker/constant/colorsfile.dart';
import 'package:expence_tracker/screens/splashscreen/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/standalone.dart' as tz;

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Kolkata')); // 👈 set your default
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1080, 1920),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Expense Tracker App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: kWhiteColor,
            appBarTheme: AppBarTheme(
              backgroundColor: kBlackColor,
              titleTextStyle: TextStyle(
                fontFamily: 'Montserrat-Regular',
                fontWeight: FontWeight.w600,
                color: kWhiteColor,
                fontSize: 22,
              ),
            )
          ),
          home: SplashScreen(),
        );
      },
    );
  }
}
