import 'dart:async';

import 'package:boilerplate/constants/assets.dart';
import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/data/sharedpref/constants/preferences.dart';
import 'package:boilerplate/utils/routes/routes.dart';
import 'package:boilerplate/widgets/app_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
          decoration: BoxDecoration(color: AppColors.main[50]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppIconWidget(image: Assets.appLogo)
            ],
          )
      ),
    );
  }

  startTimer() {
    var _duration = Duration(milliseconds: 2000);
    return Timer(_duration, navigate);
  }

  navigate() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getBool(Preferences.is_logged_in) ?? false) {
      print("moved to home");
      Navigator.of(context).pushReplacementNamed(Routes.home);
    } else {
      print("moved to login");
      Navigator.of(context).pushReplacementNamed(Routes.login);
    }
  }
}
