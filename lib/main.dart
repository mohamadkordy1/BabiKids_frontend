import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'Routes/AppRoute.dart';
import 'Routes/AppPage.dart';
void main() {
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