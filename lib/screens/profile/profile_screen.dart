import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/extension/page_navigator.dart';
import 'package:movie_obs/screens/profile/promotion_screen.dart';
import 'package:movie_obs/screens/profile/user_profile_screen.dart';
import 'package:movie_obs/screens/profile/watch_list_screen.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/images.dart';
import 'package:movie_obs/widgets/custom_button.dart';

import '../../utils/dimens.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

var titleArray = [
  'Profile',
  'Promotion',
  'Watchlist',
  'History',
  'FAQ',
  'Terms & Condition',
  'Privacy Policy',
  'Delete Account',
];
List<Widget> iconArray = [
  Icon(CupertinoIcons.person_fill, size: 20, color: kBlackColor),
  Image.asset(kPromotionIcon),
  Icon(CupertinoIcons.bookmark_fill, size: 20, color: kBlackColor),
  Icon(CupertinoIcons.arrow_clockwise, size: 20, color: kBlackColor),
  Image.asset(kFaqIcon),
  Image.asset(kTermIcon),
  Image.asset(kPrivacyIcon),
  Icon(CupertinoIcons.trash, size: 20, color: kBlackColor),
];

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      extendBody: true,
      body: Column(
        children: [
          _buildAppBar(),
          Expanded(
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Column(
                children: [
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: titleArray.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return _buidProfileListItem(
                        titleArray[index],
                        iconArray[index],
                        titleArray[index] == 'Delete Account' ? true : false,
                        onPress: () {
                          switch (index) {
                            case 0:
                              PageNavigator(
                                ctx: context,
                              ).nextPage(page: UserProfileScreen());
                            case 1:
                              PageNavigator(
                                ctx: context,
                              ).nextPage(page: PromotionScreen());
                            case 2:
                              PageNavigator(
                                ctx: context,
                              ).nextPage(page: WatchListScreen());
                            case 7:
                              showDialog(
                                useRootNavigator: true,
                                context: context,
                                builder:
                                    (builder) => Dialog(child: _buildAlert()),
                              );
                              break;
                            default:
                          }
                        },
                      );
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal:
                          getDeviceType() == 'phone'
                              ? kMarginMedium2
                              : MediaQuery.of(context).size.width * 0.15,
                      vertical: kMarginMedium2,
                    ),
                    child: customButton(
                      onPress: () {},
                      context: context,
                      backgroundColor: kBlackColor,
                      title: 'Logout',
                      textColor: kWhiteColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
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
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(kMarginMedium + 8),
                ),
                child: Center(
                  child: Icon(CupertinoIcons.person_fill, color: kWhiteColor),
                ),
              ),
              Text(
                'Username',
                style: TextStyle(
                  color: kWhiteColor,
                  fontSize: kTextRegular18,
                  fontWeight: FontWeight.w700,
                ),
              ),

              Spacer(),
              Container(
                height: 40,
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.withValues(alpha: 0.3),
                ),
                child: Center(
                  child: Text(
                    'Upgrade Premium',
                    style: TextStyle(
                      color: kWhiteColor,
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

  Widget _buidProfileListItem(
    String name,
    Widget icon,
    bool? isLastRow, {
    VoidCallback? onPress,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPress,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal:
              getDeviceType() == 'phone'
                  ? kMarginMedium2
                  : MediaQuery.of(context).size.width * 0.15,
        ),
        padding: EdgeInsets.symmetric(vertical: 3),
        child: Column(
          spacing: 5,
          children: [
            Row(
              spacing: 10,
              children: [
                SizedBox(
                  width: 36,
                  height: 36,
                  child: CircleAvatar(
                    backgroundColor: Colors.black12,
                    child: Padding(
                      padding: const EdgeInsets.all(7),
                      child: icon,
                    ),
                  ),
                ),
                Text(name, style: TextStyle(fontSize: kTextRegular2x)),
              ],
            ),
            Divider(
              color: isLastRow ?? true ? Colors.transparent : Colors.grey,
              thickness: 0.5,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlert() {
    return Container(
      height: null,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: kWhiteColor,
      ),
      padding: EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          spacing: 30,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: kBlackColor,
              child: Icon(
                CupertinoIcons.delete_simple,
                size: 26,
                color: kWhiteColor,
              ),
            ),
            Text(
              'Are you sure you want to delete your account permanently?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: kTextRegular2x),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: [
                Expanded(
                  child: customButton(
                    height: 35,
                    onPress: () {
                      if (mounted) {
                        Navigator.of(context, rootNavigator: true).pop();
                      }
                    },
                    borderColor: kBlackColor,
                    context: context,
                    backgroundColor: Colors.transparent,
                    title: 'No',
                  ),
                ),
                Expanded(
                  child: customButton(
                    height: 35,
                    onPress: () {},
                    context: context,
                    backgroundColor: kBlackColor,
                    title: 'Yes',
                    textColor: kWhiteColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
