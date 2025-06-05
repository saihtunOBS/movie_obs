import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/l10n/app_localizations.dart';
import 'package:movie_obs/list_items/giftcard_list_item.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:movie_obs/widgets/common_dialog.dart';

import '../../widgets/custom_button.dart';

class GiftCartScreen extends StatefulWidget {
  const GiftCartScreen({super.key});

  @override
  State<GiftCartScreen> createState() => _GiftCartScreenState();
}

class _GiftCartScreenState extends State<GiftCartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        surfaceTintColor: kBackgroundColor,
        foregroundColor: kWhiteColor,
        title: Text(AppLocalizations.of(context)?.giftCard ?? ''),
        centerTitle: false,
        actions: [
          GestureDetector(
            onTap: () {
              showCommonDialog(context: context, dialogWidget: _buildAlert());
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: kWhiteColor),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 8,
                ),
                child: Text(
                  AppLocalizations.of(context)?.claim ?? '',
                  style: TextStyle(
                    color: kWhiteColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          10.hGap,
        ],
      ),
      body: ListView.builder(
        itemCount: 3,
        padding: EdgeInsets.only(
          top: 10,
          bottom: 10,
          left: kMarginMedium2,
          right: kMarginMedium2,
        ),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: giftCardListItem(),
          );
        },
      ),
    );
  }

  Widget _buildAlert() {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(CupertinoIcons.gift, size: 24, color: Colors.white),
            15.vGap,

            Text(
              AppLocalizations.of(context)?.usegiftCard ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: kWhiteColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            10.vGap,
            Container(
              height: 40,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.withValues(alpha: 0.1),
              ),
              alignment: Alignment.center,
              child: TextField(
                textAlignVertical: TextAlignVertical.center,

                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: AppLocalizations.of(context)?.enterPint,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  isCollapsed: true,
                ),
              ),
            ),
            20.vGap,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                SizedBox(
                  width: 79,
                  child: customButton(
                    height: 35,
                    onPress: () {
                      if (mounted) {
                        Navigator.of(context, rootNavigator: true).pop();
                      }
                    },
                    context: context,
                    backgroundColor: Colors.transparent,
                    borderColor: kWhiteColor,
                    title: AppLocalizations.of(context)?.cancel,
                    textColor: kWhiteColor,
                    borderRadius: 5,
                  ),
                ),
                10.hGap,
                SizedBox(
                  width: 93,
                  child: customButton(
                    height: 35,
                    onPress: () {},
                    context: context,
                    backgroundColor: kSecondaryColor,
                    title: AppLocalizations.of(context)?.useNow,
                    textColor: kWhiteColor,
                    borderRadius: 5,
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
