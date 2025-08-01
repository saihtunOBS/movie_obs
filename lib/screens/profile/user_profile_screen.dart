import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/user_bloc.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/extension/page_navigator.dart';
import 'package:movie_obs/screens/profile/edit_profile_screen.dart';
import 'package:movie_obs/screens/profile/promotion_screen.dart';
import 'package:movie_obs/widgets/cache_image.dart';

import '../../utils/colors.dart';
import '../../utils/dimens.dart';
import '../../utils/images.dart';
import 'package:movie_obs/l10n/app_localizations.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,

      body: ValueListenableBuilder(
        valueListenable: userDataListener,
        builder:
            (context, data, child) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppBar(context),
                _buildUserInfo(
                  AppLocalizations.of(context)?.username ?? '',
                  data.name ?? '',
                  context,
                ),
                10.vGap,
                _buildUserInfo(
                  AppLocalizations.of(context)?.phone ?? '',
                  data.phone ?? '',
                  context,
                ),
                10.vGap,
                _buildUserInfo(
                  AppLocalizations.of(context)?.email ?? '',
                  data.email ?? '',
                  context,
                  isLast: true,
                ),
              ],
            ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: userDataListener,
      builder:
          (context, data, child) => Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 56, left: 8, right: 8),
                child: Row(
                  spacing: 10,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            kMarginMedium + 8,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            CupertinoIcons.arrow_left,
                            color: kWhiteColor,
                            size: getDeviceType() == 'phone' ? 20 : 27,
                          ),
                        ),
                      ),
                    ),

                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        PageNavigator(
                          ctx: context,
                        ).nextPage(page: EditProfileScreen(userData: data));
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
                            child: Image.asset(
                              kEditIcon,
                              width: 24,
                              height: 24,
                            ),
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
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(19),
                        child:
                            data.profilePictureUrl == ''
                                ? Image.asset(kProfileCoverIcon)
                                : cacheImage(data.profilePictureUrl ?? ''),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {
                          PageNavigator(
                            ctx: context,
                          ).nextPage(page: PromotionScreen());
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.grey.withValues(alpha: 0.3),
                          ),
                          child: ValueListenableBuilder(
                            valueListenable: userDataListener,
                            builder: (context, userData, child) {
                              return Text(
                                userData.status == 'FREE'
                                    ? 'Upgrade Premium'
                                    : 'View All Plans',
                                style: TextStyle(
                                  color: kWhiteColor,
                                  fontSize: kTextSmall,
                                  fontWeight: FontWeight.w700,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildUserInfo(
    String title,
    String name,
    BuildContext context, {
    bool? isLast,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal:
            getDeviceType() == 'phone'
                ? kMarginMedium2
                : MediaQuery.of(context).size.width * 0.15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.grey, fontSize: kTextRegular),
          ),
          5.vGap,
          Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: kTextRegular2x,
            ),
          ),
          10.vGap,
          isLast ?? false
              ? SizedBox()
              : Divider(color: Colors.grey, thickness: 0.5),
        ],
      ),
    );
  }
}
