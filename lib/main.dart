import 'package:fabric_form_flutter/app_colors.dart';
import 'package:fabric_form_flutter/pages/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fabric Dyanmic Form',
      theme: ThemeData(
          appBarTheme: AppBarTheme(brightness: Brightness.light),
          primarySwatch: Colors.blue,
          accentColor: AppColors.blue,
          primaryColor: AppColors.white),
      home: HomePage(),
    );
  }
}
