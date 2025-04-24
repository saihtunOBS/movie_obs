import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/extension/page_navigator.dart';
import 'package:movie_obs/screens/auth/change_language_screen.dart';
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
  'Language',
  'FAQ',
  'Terms & Condition',
  'Privacy Policy',
  'Delete Account',
];
List<Widget> iconArray = [
  Icon(CupertinoIcons.person_fill, size: 20, color: kWhiteColor),
  Image.asset(kPromotionIcon, color: kWhiteColor),
  Icon(CupertinoIcons.bookmark_fill, size: 20, color: kWhiteColor),
  Icon(CupertinoIcons.arrow_clockwise, size: 20, color: kWhiteColor),
  Icon(Icons.language, color: kWhiteColor),
  Image.asset(kFaqIcon, color: kWhiteColor),
  Image.asset(kTermIcon, color: kWhiteColor),
  Image.asset(kPrivacyIcon, color: kWhiteColor),
  Icon(CupertinoIcons.trash, size: 20, color: kWhiteColor),
];

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        toolbarHeight: 75,
        title: _buildAppBar(),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          children: [
            30.vGap,
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
                      case 4:
                        PageNavigator(
                          ctx: context,
                        ).nextPage(page: ChangeLanguageScreen());
                      case 7:
                        showDialog(
                          useRootNavigator: true,
                          context: context,
                          builder: (builder) => Dialog(child: _buildAlert()),
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
                backgroundColor: kSecondaryColor,
                title: 'Logout',
                textColor: kWhiteColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Column(
      children: [
        Row(
          spacing: 10,
          children: [
            InkWell(
              onTap:
                  () => PageNavigator(
                    ctx: context,
                  ).nextPage(page: UserProfileScreen()),
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
                      child: Icon(
                        CupertinoIcons.person_fill,
                        color: kWhiteColor,
                      ),
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
                ],
              ),
            ),

            Spacer(),
            InkWell(
              onTap:
                  () => PageNavigator(
                    ctx: context,
                  ).nextPage(page: PromotionScreen()),
              child: Container(
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
                      fontSize: kTextRegular,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        10.vGap,
        Image.asset(kShadowImage),
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
                    backgroundColor: Colors.grey.withValues(alpha: 0.2),
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
        color: Colors.grey.withValues(alpha: 0.2),
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
                    borderColor: kWhiteColor,
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
                    backgroundColor: kSecondaryColor,
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
