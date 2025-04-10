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
          _buildUserInfo('Username', 'Username'),
          10.vGap,
          _buildUserInfo('Phone Number', '+95 0976666677'),
          10.vGap,
          _buildUserInfo('Email Address', 'user@gmail.com', isLast: true),
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
                    child: Icon(CupertinoIcons.arrow_left, color: kWhiteColor),
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
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                Container(
                  height: 26,
                  width: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.withValues(alpha: 0.3),
                  ),
                  child: Center(
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
        ),
      ],
    );
  }

  Widget _buildUserInfo(String title, String name, {bool? isLast}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kMarginMedium2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.grey)),
          5.vGap,
          Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
          10.vGap,
          isLast ?? false
              ? SizedBox()
              : Divider(color: Colors.grey, thickness: 0.5),
        ],
      ),
    );
  }
}
