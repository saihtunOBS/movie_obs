import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/extension/page_navigator.dart';
import 'package:movie_obs/screens/profile/edit_profile_screen.dart';

import '../../utils/colors.dart';
import '../../utils/dimens.dart';
import '../../utils/images.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAppBar(context),
          _buildUserInfo('Username', 'Username',context),
          10.vGap,
          _buildUserInfo('Phone Number', '+95 0976666677',context),
          10.vGap,
          _buildUserInfo('Email Address', 'user@gmail.com',context, isLast: true),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 200,
          width: double.infinity,
          child: Image.asset(kBarBackground, fit: BoxFit.fill),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: 60,
            left: kMarginMedium2,
            right: kMarginMedium2,
          ),
          child: Row(
            spacing: 10,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(kMarginMedium + 8),
                  ),
                  child: Center(
                    child: Icon(CupertinoIcons.arrow_left, color: kWhiteColor,size: getDeviceType() == 'phone' ? 20 : 27,),
                  ),
                ),
              ),

              Spacer(),
              GestureDetector(
                onTap: () {
                  PageNavigator(
                    ctx: context,
                  ).nextPage(page: EditProfileScreen());
                },
                child: Hero(
                  tag: 'animate',
                  child: Container(
                    height: 40,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Image.asset(kEditIcon, width: 24, height: 24),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(top: 70),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(19),
                ),
                child: Center(
                  child: Image.asset(kUserIcon, width: 28, height: 28),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  // height: 26,
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey.withValues(alpha: 0.3),
                  ),
                  child: Text(
                    'Upgrade Premium',
                    style: TextStyle(
                      color: kWhiteColor,
                      fontSize: kTextSmall,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfo(String title, String name,BuildContext context, {bool? isLast}) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal:
              getDeviceType() == 'phone'
                  ? kMarginMedium2
                  : MediaQuery.of(context).size.width * 0.15,),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.grey,fontSize: kTextRegular2x)),
          5.vGap,
          Text(name, style: TextStyle(fontWeight: FontWeight.bold,fontSize: kTextRegular2x)),
          10.vGap,
          isLast ?? false
              ? SizedBox()
              : Divider(color: Colors.grey, thickness: 0.5),
        ],
      ),
    );
  }
}
