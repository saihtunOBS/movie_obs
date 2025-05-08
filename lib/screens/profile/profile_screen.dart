import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/user_bloc.dart';
import 'package:movie_obs/data/persistence/persistence_data.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/extension/page_navigator.dart';
import 'package:movie_obs/screens/auth/change_language_screen.dart';
import 'package:movie_obs/screens/auth/login_screen.dart';
import 'package:movie_obs/screens/bottom_nav/bottom_nav_screen.dart';
import 'package:movie_obs/screens/profile/faq_screen.dart';
import 'package:movie_obs/screens/profile/promotion_screen.dart';
import 'package:movie_obs/screens/profile/user_profile_screen.dart';
import 'package:movie_obs/screens/profile/watch_list_screen.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/images.dart';
import 'package:movie_obs/widgets/cache_image.dart';
import 'package:movie_obs/widgets/custom_button.dart';
import 'package:provider/provider.dart';

import '../../utils/dimens.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

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
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserBloc>().updateToken();
      context.read<UserBloc>().getUser(context);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var titleArray = [
      AppLocalizations.of(context)?.profile ?? '',
      AppLocalizations.of(context)?.promotion ?? '',
      AppLocalizations.of(context)?.watchlist ?? '',
      AppLocalizations.of(context)?.history ?? '',
      AppLocalizations.of(context)?.language ?? '',
      AppLocalizations.of(context)?.faq ?? '',
      AppLocalizations.of(context)?.term ?? '',
      AppLocalizations.of(context)?.privacy ?? '',
      AppLocalizations.of(context)?.deleteAccount ?? '',
    ];
    return ChangeNotifierProvider(
      create: (_) => UserBloc(context: context),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          toolbarHeight: 90,
          title: Consumer<UserBloc>(
            builder: (context, bloc, child) => _buildAppBar(),
          ),
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
        ),
        body: Consumer<UserBloc>(
          builder:
              (context, bloc, child) => SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Column(
                  children: [
                    10.vGap,
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
                              case 5:
                                PageNavigator(
                                  ctx: context,
                                ).nextPage(page: FaqScreen());
                              case 8:
                                showDialog(
                                  useRootNavigator: true,
                                  context: context,

                                  builder:
                                      (builder) => Dialog(
                                        backgroundColor: kWhiteColor,
                                        insetPadding: const EdgeInsets.all(10),
                                        child: _buildAlert(),
                                      ),
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
                        onPress: () async {
                          tab.value = false;
                          PersistenceData.shared.clearToken();
                          await PageNavigator(
                            ctx: context,
                          ).nextPageOnly(page: LoginScreen());
                        },
                        context: context,
                        backgroundColor: kSecondaryColor,
                        title: 'Logout',
                        textColor: kWhiteColor,
                      ),
                    ),
                  ],
                ),
              ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return ValueListenableBuilder(
      valueListenable: userDataListener,
      builder:
          (context, userData, child) => Column(
            children: [
              Row(
                spacing: 10,
                children: [
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap:
                          () => PageNavigator(
                            ctx: context,
                          ).nextPage(page: UserProfileScreen()),
                      child: Row(
                        spacing: 5,
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.grey.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(
                                kMarginMedium + 8,
                              ),
                            ),
                            child: Center(
                              child:
                                  userData.profilePictureUrl == ''
                                      ? Image.asset(
                                        kAppIcon,
                                        width: 30,
                                        height: 30,
                                      )
                                      : SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          child: cacheImage(
                                            userData.profilePictureUrl,
                                          ),
                                        ),
                                      ),
                            ),
                          ),
                          5.hGap,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 5,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.32,
                                child: Text(
                                  userData.name ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  style: TextStyle(
                                    color: kWhiteColor,
                                    fontSize: kTextRegular18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Container(
                                height: 19,
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(26),
                                ),
                                child: Center(
                                  child: Text(
                                    'Free user',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
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
          ),
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
                Text(
                  name,
                  style: TextStyle(
                    fontSize: kTextRegular2x,
                    color: kWhiteColor,
                  ),
                ),
              ],
            ),
            Divider(
              color: isLastRow ?? true ? Colors.transparent : Colors.grey,
              thickness: 0.3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlert() {
    return Container(
      height: null,
      padding: EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.delete_simple, size: 38, color: Colors.red),
            15.vGap,
            Text(
              'Delete Account?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: kTextRegular2x,
                color: kBlackColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            10.vGap,
            Text(
              'Are you sure you want to delete your account permanently?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: kTextRegular13, color: kBlackColor),
            ),
            20.vGap,
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
                    context: context,
                    backgroundColor: Colors.grey.withValues(alpha: 0.2),
                    title: 'No',
                    textColor: kBlackColor,
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
