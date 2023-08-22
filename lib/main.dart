import 'package:dog_or_cat/screens/splash_screen.dart';
import 'package:dog_or_cat/utils/colors.dart';
import 'package:dog_or_cat/utils/size_config.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: AppColors.primaryColor,
        appBarTheme: AppBarTheme(
            backgroundColor: AppColors.primaryColor,
            centerTitle: false,
            titleTextStyle: Theme.of(context).textTheme.titleLarge!),
        buttonTheme: const ButtonThemeData(
          buttonColor: AppColors.primaryColor,
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
