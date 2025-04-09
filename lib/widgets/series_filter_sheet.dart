import 'package:flutter/material.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:movie_obs/widgets/movie_filter_sheet.dart';

Widget seriesFilterSheet() {
  return Container(
    margin: EdgeInsets.symmetric(
      horizontal: kMarginMedium2,
      vertical: kMarginMedium2,
    ),
    child: Column(
      spacing: kMarginMedium2,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //title
        Row(
          children: [
            Text(
              'FILTER',
              style: TextStyle(
                fontSize: kTextRegular22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            Chip(
              label: Text('Filter', style: TextStyle(color: kWhiteColor)),
              backgroundColor: kBlackColor,
            ),
            10.hGap,
            Chip(
              label: Text('Clear', style: TextStyle(color: kBlackColor)),
              backgroundColor: kWhiteColor,
              side: BorderSide(color: kBlackColor),
            ),
          ],
        ),

        //movie session
        _buildSeriesSession(),
        Divider(),

        //type session
        buildTypeSession(),
        Divider(),

        //genre session
        buildGenreSession(),
      ],
    ),
  );
}

Widget _buildSeriesSession() {
  return SizedBox(
    height: 70,
    child: Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(spacing: kMargin10, children: [Icon(Icons.tv), Text('Series',style: TextStyle(fontWeight: FontWeight.bold,fontSize: kTextRegular2x),)]),
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: 1,
            itemBuilder: (context, index) {
              return Chip(
                label: Text('hello'),
                backgroundColor: kWhiteColor,
                side: BorderSide(color: kBlackColor),
              );
            },
          ),
        ),
      ],
    ),
  );
}

