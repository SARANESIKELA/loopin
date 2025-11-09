import 'package:flutter/material.dart';
import 'package:loopin/core/constants/app_theme.dart';
import 'package:loopin/presentation/screens/splash/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:loopin/providers/post_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => PostProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PostProvider(),
      child: MaterialApp(
        title: 'Loopin Demo',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.buildLightTheme(),
        home: SplashScreen(),
      ),
    );
  }
}
