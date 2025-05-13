import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/package_bloc.dart';
import 'package:movie_obs/data/vos/package_vo.dart';
import 'package:movie_obs/list_items/promotion_list_items.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/widgets/show_loading.dart';
import 'package:provider/provider.dart';

import '../../extension/extension.dart';
import '../../utils/dimens.dart';
import '../../utils/images.dart';
import '../../widgets/custom_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PromotionScreen extends StatelessWidget {
  const PromotionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PackageBloc(),
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
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: kMarginMedium2,
            vertical: kMarginMedium2 + 5,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 2,
            children: [
              customButton(
                onPress: () {},
                context: context,
                backgroundColor: kSecondaryColor,
                title: 'Continue for Payment',
                textColor: kWhiteColor,
              ),
              Image.asset(kShadowImage),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 57, left: 8, right: 8),
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
    return ListView.builder(
      physics: ClampingScrollPhysics(),
      padding: EdgeInsets.only(
        top: 30,
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
        return promotionListItem(
          false,
          context,
          bloc.packages?[index] ?? PackageVO(),
        );
      },
    );
  }
}
