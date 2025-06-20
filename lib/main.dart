// ignore_for_file: deprecated_member_use
// ignore_for_file: unused_local_variable
// import 'package:flutter/material.dart';
// import 'package:quiz/admin/admin_dashboard.dart';
// import 'package:quiz/model/db_connect.dart';
// import 'package:quiz/model/question_model.dart';
// import 'package:quiz/screen/singinscreen.dart';
// import 'package:quiz/widget/category.dart';
// import "screen/home_screen.dart";
// import 'admin/admin_screen.dart';
// import 'package:get/get.dart';

// void main() {
//   runApp(const myApp());
// }

// // ignore: camel_case_types
// class myApp extends StatelessWidget {
//   const myApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return const GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: LoginScreen(),
//       //home: CategoryScreen(),
//       //home: HomeScreen(),
//       //home: Admin(),
//     );
//   }
// }
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import 'package:quiz/screen/singinscreen.dart';
import 'package:quiz/screen/signupscreen.dart';
import 'package:quiz/widget/category.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quiz App',
      home: LoginScreen(),
      routes: {
        '/home': (context) => const CategoryScreen(),
        '/signup': (context) => SignupScreen(),
      },
    );
  }
}
