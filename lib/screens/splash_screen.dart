import 'package:dog_or_cat/screens/home_screen.dart';
import 'package:dog_or_cat/utils/assets.dart';
import 'package:dog_or_cat/utils/size_config.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 2),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Hero(
          tag: "logo",
          child: Image.asset(
            AppAssets.appLogo,
            height: getProportionateScreenHeight(200),
            width: getProportionateScreenHeight(200),
          ),
        ),
      ),
    );
  }
}
