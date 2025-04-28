import 'package:flutter/material.dart';
import 'package:movie_obs/data/vos/season_vo.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:movie_obs/widgets/cache_image.dart';

Widget recommendedMovieListItem(SeasonVO data) {
  return Container(
    margin: EdgeInsets.only(right: 10),
    height: 163,
    width: 100,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(kMargin10),
    ),
    child: Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(kMargin10),
            child: cacheImage(data.bannerImageUrl ?? ''),
          ),
        ),
        Text(
          data.name ?? '',
          softWrap: true,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    ),
  );
}
