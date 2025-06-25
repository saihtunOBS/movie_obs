import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/package_bloc.dart';
import 'package:movie_obs/data/vos/package_vo.dart';
import 'package:movie_obs/extension/page_navigator.dart';
import 'package:movie_obs/list_items/promotion_list_items.dart';
import 'package:movie_obs/screens/profile/payment_method_screen.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/widgets/empty_view.dart';
import 'package:movie_obs/widgets/show_loading.dart';
import 'package:movie_obs/widgets/toast_service.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../extension/extension.dart';
import '../../utils/dimens.dart';
import '../../widgets/custom_button.dart';
import 'package:movie_obs/l10n/app_localizations.dart';

class PromotionScreen extends StatefulWidget {
  const PromotionScreen({super.key});

  @override
  State<PromotionScreen> createState() => _PromotionScreenState();
}

class _PromotionScreenState extends State<PromotionScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PackageBloc(context: context),
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: Consumer<PackageBloc>(
          builder:
              (context, bloc, child) => Column(
                children: [
                  _buildAppBar(context),
                  20.vGap,
                  Expanded(
                    child:
                        bloc.isLoading
                            ? LoadingView()
                            : _buildListView(context, bloc),
                  ),
                ],
              ),
        ),
        bottomNavigationBar: Consumer<PackageBloc>(
          builder:
              (context, bloc, child) => Container(
                height: 100,
                padding: const EdgeInsets.symmetric(horizontal: kMarginMedium2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 10,
                  children: [
                    GestureDetector(
                      onTap: () {
                        bloc.packageId == ''
                            ? ToastService.warningToast(
                              'Please choose package to continue.',
                            )
                            : PageNavigator(ctx: context).nextPage(
                              page: PaymentMethodScreen(
                                isGift: true,
                                plan: bloc.packageId,
                                packageData:
                                    bloc.selectedPackage ?? PackageVO(),
                              ),
                            );
                      },
                      child: Container(
                        height: 49,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: Colors.grey.withValues(alpha: 0.2),
                        ),
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)?.giftNow ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kWhiteColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: customButton(
                        onPress: () {
                          bloc.packageId == ''
                              ? ToastService.warningToast(
                                'Please choose package to continue.',
                              )
                              : PageNavigator(ctx: context).nextPage(
                                page: PaymentMethodScreen(
                                  isGift: false,
                                  plan: bloc.packageId,
                                  packageData:
                                      bloc.selectedPackage ?? PackageVO(),
                                ),
                              );
                        },
                        context: context,
                        backgroundColor: kSecondaryColor,
                        title: 'Continue for Payment',
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

  Widget _buildAppBar(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 40, left: 8, right: 8),
          child: Row(
            spacing: 10,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(kMarginMedium + 8),
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
            ],
          ),
        ),

        Padding(
          padding: EdgeInsets.only(
            top: getDeviceType() == 'phone' ? 70 : 50,
            left: 30,
            right: 30,
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              spacing: 8,
              children: [
                Text(
                  AppLocalizations.of(context)?.specialPromotion ?? '',
                  style: TextStyle(
                    color: kWhiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: kTextRegular3x,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)?.unlockPromotion ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kWhiteColor,
                    fontSize: kTextRegular,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListView(BuildContext context, PackageBloc bloc) {
    return bloc.packages?.isNotEmpty ?? true
        ? ListView.builder(
          physics: ClampingScrollPhysics(),
          padding: EdgeInsets.only(
            top: 0,
            left:
                getDeviceType() == 'phone'
                    ? kMarginMedium2
                    : MediaQuery.of(context).size.width * 0.15,
            right:
                getDeviceType() == 'phone'
                    ? kMarginMedium2
                    : MediaQuery.of(context).size.width * 0.15,
            bottom: kMarginMedium2,
          ),
          itemCount: bloc.packages?.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                bloc.choosePackage(
                  bloc.packages?[index].id ?? '',
                  bloc.packages?[index] ?? PackageVO(),
                );
              },
              child: promotionListItem(
                false,
                context,
                bloc.packages?[index] ?? PackageVO(),
                bloc.packageId == bloc.packages?[index].id,
                bloc.packages?[index].promotion == null ? 13 : 30,
              ),
            );
          },
        )
        : EmptyView(
          reload: () {
            bloc.getPackage();
          },
          title: AppLocalizations.of(context)?.noPromotion ?? '',
        );
  }

  shareGift(dynamic data) {
    SharePlus.instance.share(ShareParams(text: data));
  }

  // Widget _buildAlert() {
  //   return Dialog(
  //     child: Container(
  //       padding: EdgeInsets.all(20),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Icon(CupertinoIcons.gift, size: 24, color: Colors.white),
  //           15.vGap,

  //           Text(
  //             AppLocalizations.of(context)?.giftCard ?? '',
  //             textAlign: TextAlign.center,
  //             style: TextStyle(
  //               fontSize: 15,
  //               color: kWhiteColor,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //           10.vGap,
  //           Row(
  //             children: [
  //               Expanded(
  //                 child: Container(
  //                   height: 38,
  //                   decoration: BoxDecoration(color: kThirdColor),
  //                   child: Center(
  //                     child: Text(
  //                       '098-984-985',
  //                       style: TextStyle(
  //                         color: kBlackColor,
  //                         fontSize: kTextRegular2x,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               GestureDetector(
  //                 onTap: () {
  //                   shareGift('Your gift.....');
  //                 },
  //                 child: Container(
  //                   height: 38,
  //                   width: 44,
  //                   decoration: BoxDecoration(color: kSecondaryColor),
  //                   child: Center(
  //                     child: Icon(
  //                       CupertinoIcons.arrowshape_turn_up_right_fill,
  //                       size: 16,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
