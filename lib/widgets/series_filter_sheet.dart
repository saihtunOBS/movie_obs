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
    height: getDeviceType()  == 'phone' ? 70 : 100,
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

void showSeriesRightSideSheet(BuildContext context) {
  showGeneralDialog(
    useRootNavigator: true,
    context: context,
    barrierDismissible: true,
    barrierLabel: "RightSideSheet",
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, anim1, anim2) {
      return Align(
        alignment: Alignment.centerRight,
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: EdgeInsets.only(top: 60),
            decoration: BoxDecoration(
              color: kWhiteColor,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(30)),
            ),
            width: MediaQuery.of(context).size.width / 2,
            height: double.infinity,
            padding: const EdgeInsets.all(20),
            child: seriesFilterSheet(),
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curvedValue = Curves.easeInOut.transform(animation.value) - 1.0;
      return Transform.translate(
        offset: Offset(curvedValue * -300, 0),
        child: Opacity(opacity: animation.value, child: child),
      );
    },
  );
}
