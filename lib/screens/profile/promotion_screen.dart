import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/list_items/promotion_list_items.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/images.dart';

import '../../extension/extension.dart';
import '../../utils/dimens.dart';

class PromotionScreen extends StatelessWidget {
  const PromotionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Column(
        children: [
          _buildAppBar(context),
          Expanded(child: _buildListView(context)),
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
          padding: EdgeInsets.only(top: getDeviceType() == 'phone' ? 80 : 60, left: 30, right: 30),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              spacing: 8,
              children: [
                Text(
                  'Special Promotion',
                  style: TextStyle(
                    color: kWhiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: kTextRegular3x,
                  ),
                ),
                Text(
                  'Unlock exclusive benefits with our limited-time promotion package!',
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

  Widget _buildListView(BuildContext context) {
    return ListView.builder(
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
      itemCount: 3,
      itemBuilder: (context, index) {
        return promotionListItem(index == 2 ? true : false, context);
      },
    );
  }
}
