import 'package:flutter/material.dart';
import 'package:movie_obs/data/vos/notification_vo.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/utils/date_formatter.dart';
import 'package:movie_obs/utils/dimens.dart';

Widget notiListItem(bool isLast, NotificationVo data) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      5.vGap,
      Text(
        data.title ?? '',
        style: TextStyle(fontSize: kTextRegular2x, fontWeight: FontWeight.w600),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      10.vGap,
      Text(DateFormatter.formatDate(data.createdAt ?? DateTime.now())),
      5.vGap,
      isLast ? SizedBox.shrink() : Divider(color: Colors.grey, thickness: 0.5),
    ],
  );
}
