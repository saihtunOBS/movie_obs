import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/movie_bloc.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:movie_obs/widgets/movie_filter_sheet.dart';
import 'package:provider/provider.dart';

import '../utils/images.dart';

Widget seriesFilterSheet() {
  return ChangeNotifierProvider(
    create: (context) => MovieBloc(),
    child: Consumer<MovieBloc>(
      builder:
          (context, bloc, child) => Container(
            margin: EdgeInsets.symmetric(
              horizontal: kMarginMedium2,
              vertical: kMarginMedium2,
            ),
            child: Column(
              children: [
                Container(
                  width: 30,
                  height: 3,
                  decoration: BoxDecoration(
                    color: kWhiteColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                15.vGap,
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
                      label: Text(
                        'Filter',
                        style: TextStyle(color: kWhiteColor),
                      ),
                      backgroundColor: kSecondaryColor,
                    ),
                    10.hGap,
                    Chip(
                      label: Text(
                        'Clear',
                        style: TextStyle(color: kWhiteColor),
                      ),
                      backgroundColor: kBlackColor,
                      side: BorderSide(color: kWhiteColor, width: 0.8),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      spacing: 5,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //movie session
                        _buildSeriesSession(),
                        Divider(),

                        //type session
                        buildTypeSession(categoryData: bloc.categoryLists),
                        Divider(),

                        //genre session
                        buildGenreSession(genreData: bloc.genreLists),

                        20.vGap,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
    ),
  );
}

Widget _buildSeriesSession() {
  return Column(
    spacing: 5,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        spacing: kMargin10,
        children: [
          Image.asset(
            kMovieSeriesIcon,
            width: 28,
            height: 28,
            color: kWhiteColor,
          ),
          Text(
            'Series',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: kTextRegular2x,
            ),
          ),
        ],
      ),
      SizedBox(
        height: 50,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: 1,
          itemBuilder: (context, index) {
            return Chip(
              label: Text('Myanmar'),
              backgroundColor: Colors.grey.withValues(alpha: 0.2),
            );
          },
        ),
      ),
    ],
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
