import 'package:flutter/material.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';

Widget movieFilterSheet() {
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
        _buildMovieSession(),
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

Widget _buildMovieSession() {
  return SizedBox(
    height: 70,
    child: Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: kMargin10,
          children: [
            Icon(Icons.tv),
            Text(
              'Movies',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: kTextRegular2x,
              ),
            ),
          ],
        ),
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

Widget buildTypeSession() {
  return SizedBox(
    height: 70,
    child: Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: kMargin10,
          children: [
            Icon(Icons.tv),
            Text(
              'Types',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: kTextRegular2x,
              ),
            ),
          ],
        ),
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

Widget buildGenreSession() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: 12,
    children: [
      SizedBox(
        height: 20,
        child: Row(
          spacing: kMargin10,
          children: [
            Icon(Icons.tv),
            Text(
              'Genre',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: kTextRegular2x,
              ),
            ),
          ],
        ),
      ),
      Wrap(
        spacing: kMarginMedium,
        runSpacing: kMarginMedium,
        alignment: WrapAlignment.start,
        children: [
          Chip(
            label: Text('hello'),
            backgroundColor: kWhiteColor,
            side: BorderSide(color: kBlackColor),
          ),
          Chip(
            label: Text('hello'),
            backgroundColor: kWhiteColor,
            side: BorderSide(color: kBlackColor),
          ),
        ],
      ),
    ],
  );
}
