import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialty_with_firebase/business_logic/cubit/chat/chat_cubit.dart';
import 'package:socialty_with_firebase/presentation/splash/splash_view.dart';
import 'package:socialty_with_firebase/shared/cache_helper.dart';
import 'package:socialty_with_firebase/shared/observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  CacheHelper.init();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatCubit(),
      child: MaterialApp(
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            color: Colors.black,
          ),
        ),
        debugShowCheckedModeBanner: false,
        title: 'Scoiality',
        home: const SplashView(),
      ),
    );
  }
}
