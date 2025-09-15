import 'package:expence_tracker/constant/colorsfile.dart';
import 'package:expence_tracker/screens/homescreen/homescreen.dart';
import 'package:expence_tracker/screens/loginscreen/loginscreen.dart';
import 'package:expence_tracker/screens/splashscreen/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
              backgroundColor: kWhiteColor
            )
          ),
          home: SplashScreen(),
        );
      },
    );
  }
}
