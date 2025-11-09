import 'package:flutter/material.dart';
import 'package:loopin/core/constants/app_theme.dart';
import 'package:loopin/presentation/screens/Login/login_screen.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.ScaffoldBackGroundColor,
      body: Center(
        child: SizedBox(
          width: 300,
          height: 300,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 30,
                child: Image.asset(
                  'assets/images/logo_bg_remover.png',
                  height: 180,
                  width: 180,
                  fit: BoxFit.contain,
                ),
              ),
              Positioned(
                top: 90,
                child: Lottie.asset(
                  'assets/lottie/Welcome.json',
                  width: 250,
                  height: 250,
                  fit: BoxFit.contain,
                  repeat: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
