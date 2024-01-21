import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:socialty_with_firebase/constants/assets.dart';

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
        seconds: 5,
      ),
    ).then(
      (value) => null,
    );
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
