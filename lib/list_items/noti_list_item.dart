import 'package:flutter/material.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/utils/dimens.dart';

Widget notiListItem(bool isLast) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      5.vGap,
      Text(
        'Your account have been created successfully',
        style: TextStyle(fontSize: kTextRegular2x ,fontWeight: FontWeight.w600),
      ),
      10.vGap,
      Text('1 Jan, 2025'),
      5.vGap,
      isLast ? SizedBox.shrink() : Divider(color: Colors.grey, thickness: 0.5),
    ],
  );
}
