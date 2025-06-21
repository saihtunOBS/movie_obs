import 'dart:async';
import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/ads_bloc.dart';
import 'package:movie_obs/data/persistence/persistence_data.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/extension/page_navigator.dart';
import 'package:movie_obs/screens/auth/auth_screen.dart';
import 'package:movie_obs/screens/bottom_nav/bottom_nav_screen.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:movie_obs/widgets/ads_image_animation.dart';
import 'package:provider/provider.dart';

import '../../network/notification_service/notification_service.dart';

class AdsScreen extends StatefulWidget {
  const AdsScreen({super.key});

  @override
  State<AdsScreen> createState() => _AdsScreenState();
}

class _AdsScreenState extends State<AdsScreen> {
  int _secondsLeft = 6;
  Timer? _timer;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationService(context).requestPermission();
    });

    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsLeft > 1) {
        setState(() {
          _secondsLeft--;
        });
      } else {
        _timer?.cancel();
        _navigateNext();
      }
    });
  }

  void _navigateNext() {
    if (PersistenceData.shared.getToken() != '') {
      PageNavigator(ctx: context).nextPageOnly(page: BottomNavScreen());
    } else {
      PageNavigator(ctx: context).nextPageOnly(page: AuthScreen());
    }
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdsBloc(),
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal:
                getDeviceType() == 'phone'
                    ? kMarginMedium2
                    : MediaQuery.of(context).size.width * 0.15,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _navigateNext,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    height: 30,
                    width: 80,
                    decoration: BoxDecoration(
                      color: kWhiteColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        'Ads | ${_secondsLeft}s',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Container(
                height: MediaQuery.sizeOf(context).height * 0.6,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: AdsImageAnimation(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
