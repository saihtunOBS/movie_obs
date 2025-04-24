import 'package:flutter/material.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';

Widget promotionListItem(bool isPremium, BuildContext context) {
  return Container(
    margin: EdgeInsets.only(bottom: 40),
    padding: EdgeInsets.symmetric(horizontal: 20),
    decoration: BoxDecoration(
      color: Colors.grey.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: Colors.grey, width: 0.3),
    ),
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: 0,
          top: -15,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: kSecondaryColor,
            ),
            child: Text(
              'Thingyan Festival',
              style: TextStyle(color: kWhiteColor, fontSize: 13),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            20.vGap,
            Row(
              spacing: 30,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 5,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Basic Plan',
                            style: TextStyle(
                              fontSize: kTextRegular18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '+ 10 days',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        spacing: isPremium ? 5 : 0,
                        children: [
                          isPremium
                              ? Container(
                                margin: EdgeInsets.only(top: 2),
                                height: 5,
                                width: 5,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: kBlackColor,
                                ),
                              )
                              : SizedBox.shrink(),
                          Text(
                            'Essentials features, limited access',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  spacing: 5,
                  children: [
                    Text(
                      '10,000 Ks',
                      style: TextStyle(
                        fontSize: kTextRegular2x,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('/ for 30 days', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.withValues(alpha: 0.2),
              ),
              child: Text(
                'Within April 1, 2025 - April 5, 2025',
                style: TextStyle(color: kThirdColor),
                textAlign: TextAlign.justify,
              ),
            ),
            5.vGap,
          ],
        ),
      ],
    ),
  );
}
