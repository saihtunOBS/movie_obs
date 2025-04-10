import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/widgets/custom_button.dart';
import 'package:movie_obs/widgets/custom_textfield.dart';

import '../../utils/colors.dart';
import '../../utils/dimens.dart';
import '../../utils/images.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

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
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(
          horizontal: kMarginMedium2,
          vertical: kMarginMedium2 + 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            Expanded(
              child: customButton(
                onPress: () {
                  Navigator.pop(context);
                },
                borderColor: kBlackColor,
                context: context,
                backgroundColor: Colors.transparent,
                title: 'Cancel',
              ),
            ),
            Expanded(
              child: customButton(
                onPress: () {},
                context: context,
                backgroundColor: kBlackColor,
                title: 'Save',
                textColor: kWhiteColor,
              ),
            ),
          ],
        ),
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
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(top: 70),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Stack(
                children: [
                  Container(
                    height: 74,
                    width: 74,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.3),
                    ),
                    child: Center(
                      child: Image.asset(kUserIcon, width: 44, height: 44),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 3),
                      color: Colors.black26,
                      child: Icon(
                        CupertinoIcons.camera_fill,
                        color: kWhiteColor,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
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
          Text(title, style: TextStyle(fontWeight: FontWeight.w700)),
          5.vGap,
          CustomTextfield(hint: title),
          10.vGap,
        ],
      ),
    );
  }
}
