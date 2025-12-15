import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'Controllers/ChildrenController.dart';
import 'Controllers/UserController.dart';
import 'Routes/AppRoute.dart';
import 'Routes/AppPage.dart';
void main() {
  Get.put(UserController());
  Get.put(ChildrenController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp( 
      title: 'BabiKids',
      debugShowCheckedModeBanner: false,
      initialRoute:AppRoute.login, 
      getPages:AppPage.pages,
      );
      }
} 