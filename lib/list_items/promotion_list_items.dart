import 'package:flutter/material.dart';
import 'package:movie_obs/data/vos/package_vo.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/date_formatter.dart';
import 'package:movie_obs/utils/dimens.dart';

Widget promotionListItem(
  bool isPremium,
  BuildContext context,
  PackageVO data,
  bool isSelected,
  double margin,
) {
  return Container(
    margin: EdgeInsets.only(bottom: margin),
    padding: EdgeInsets.symmetric(horizontal: 20),
    decoration: BoxDecoration(
      color: Colors.grey.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(15),
      border: Border.all(
        color: isSelected ? Colors.white : Colors.transparent,
        width: 1,
      ),
    ),
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: 0,
          top: -15,
          child: Visibility(
            visible: data.promotion != null,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: kSecondaryColor,
              ),
              child: Text(
                data.promotion?.name ?? '',
                style: TextStyle(color: kWhiteColor, fontSize: 13),
              ),
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
                            data.name ?? '',
                            style: TextStyle(
                              fontSize: kTextRegular18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '',
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
                            data.description ?? '',
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
                      '${data.price} ${data.currency}',
                      style: TextStyle(
                        fontSize: kTextRegular2x,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '/ for ${data.duration} days',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            data.promotion == null
                ? SizedBox.shrink()
                : Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.withValues(alpha: 0.2),
                  ),
                  child: Text(
                    'Within ${DateFormatter.formatDate(data.promotion?.startDate ?? DateTime.now())} - ${DateFormatter.formatDate(data.promotion?.endDate ?? DateTime.now())}',
                    style: TextStyle(color: kPrimaryColor),
                    textAlign: TextAlign.justify,
                  ),
                ),
            5.vGap,
          ],
        ),
        // isSelected
        //     ? Positioned(
        //       right: -20,
        //       top: -10,
        //       child: Icon(Icons.check_circle, color: kSecondaryColor),
        //     )
        //     : SizedBox.shrink(),
      ],
    ),
  );
}
