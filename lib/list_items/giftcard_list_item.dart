import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:movie_obs/widgets/toast_service.dart';

Widget giftCardListItem() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10),
    height: 108,
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      color: Colors.grey.withValues(alpha: 0.2),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Gift Name',
              style: TextStyle(
                fontSize: kTextRegular18,
                color: kWhiteColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: kSecondaryColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                'Unused',
                style: TextStyle(
                  color: kWhiteColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        5.vGap,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('122-112-333', style: TextStyle(fontSize: 13)),
            GestureDetector(
              onTap: () {
                ToastService.successToast('Copied success!');
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Icon(Icons.copy, size: 17),
              ),
            ),
          ],
        ),
        8.vGap,
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            'Valid before 06/05/2025',
            style: TextStyle(
              color: kWhiteColor,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ),
      ],
    ),
  );
}
