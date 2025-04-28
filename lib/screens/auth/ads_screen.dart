import 'package:flutter/material.dart';
import 'package:movie_obs/data/persistence/persistence_data.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/extension/page_navigator.dart';
import 'package:movie_obs/screens/auth/splash_screen.dart';
import 'package:movie_obs/screens/bottom_nav/bottom_nav_screen.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';

class AdsScreen extends StatelessWidget {
  const AdsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal:getDeviceType() == 'phone' ? kMarginMedium2 : MediaQuery.of(context).size.width * 0.15),
        child: Column(
          spacing: 15,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                height: 30,
                width: 80,
                decoration: BoxDecoration(
                  color: kBlackColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text('Ads', style: TextStyle(color: kWhiteColor)),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                if(PersistenceData.shared.getToken() != ''){
                  PageNavigator(ctx: context).nextPageOnly(page: BottomNavScreen());
                }else {
                  PageNavigator(ctx: context).nextPageOnly(page: SplashScreen());
                }
                
              },
              child: Container(
                height: MediaQuery.sizeOf(context).height * 0.6,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: kWhiteColor,
                  borderRadius: BorderRadiusDirectional.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
