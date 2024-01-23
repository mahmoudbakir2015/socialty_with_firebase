import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:socialty_with_firebase/presentation/splash/splash_view.dart';
import 'package:socialty_with_firebase/shared/cache_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  CacheHelper.init();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Scoiality',
      home: SplashView(),
    );
  }
}
