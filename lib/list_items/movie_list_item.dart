import 'package:flutter/material.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';

Widget movieListItem({bool? isMovieScreen}) {
  return Container(
    height: 220,
    margin: EdgeInsets.only(right: isMovieScreen == true ? 0 : kMarginMedium),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(kMargin10),
      color: kWhiteColor,
    ),
    child: Stack(
      children: [
        Positioned(
          left: 10,
          top: 10,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            child: Center(child: Text('Movie')),
          ),
        ),
      ],
    ),
  );
}
