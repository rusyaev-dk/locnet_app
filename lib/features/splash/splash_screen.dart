import 'package:flutter/material.dart';
import 'package:locnet_app/gen/assets.gen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Assets.lottie.splash.lottie());
  }
}
