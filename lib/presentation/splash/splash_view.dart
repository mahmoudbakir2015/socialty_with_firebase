import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:socialty_with_firebase/constants/assets.dart';
import '../../shared/cache_helper.dart';
import '../auth/sign_in/sign_in.dart';
import '../main_screen/main_screen.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    Future.delayed(
      const Duration(
        seconds: 3,
      ),
    ).then((value) {
      if (CacheHelper.getData(key: 'token') != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(
              uid: CacheHelper.getData(key: 'token').toString(),
            ),
          ),
          (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const SignIn(),
          ),
          (route) => false,
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SvgPicture.asset(
          Assets.splashIcon,
          color: Colors.blue,
          width: 100,
        ),
      ),
    );
  }
}
