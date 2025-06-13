import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/network/responses/gift_data_response.dart';
import 'package:movie_obs/utils/calculate_time.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/date_formatter.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:movie_obs/widgets/toast_service.dart';

Widget giftCardListItem(GiftVO data) {
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
              data.plan?.name ?? '',
              style: TextStyle(
                fontSize: kTextRegular18,
                color: kWhiteColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color:
                    data.status == 'ACTIVE'
                        ? kSecondaryColor
                        : data.status == 'PENDING'
                        ? Colors.orange
                        : Colors.red,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                data.status ?? '',
                style: TextStyle(
                  color: kWhiteColor,
                  fontSize: kTextSmall,
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
            Text(
              formatWithDashes(data.code ?? ''),
              style: TextStyle(fontSize: 13),
            ),
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: data.code ?? ''));
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
            'Valid before ${DateFormatter.formatDate(data.expiresAt ?? DateTime.now())}',
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
