import 'package:flutter/material.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:movie_obs/widgets/cache_image.dart';

Widget movieListItem({bool? isMovieScreen}) {
  return Container(
    height: 180,
    margin: EdgeInsets.only(right: isMovieScreen == true ? 0 : kMarginMedium),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(kMargin10),
      color: kWhiteColor,
    ),
    child: Stack(
      fit: StackFit.passthrough,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(kMargin10),
          child: cacheImage(
            'https://artofthemovies.co.uk/cdn/shop/files/IMG_6516.jpg?v=1713258503',
          ),
        ),
        Positioned(
          left: 10,
          top: 10,
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 186, 184, 184).withValues(alpha: 0.8),
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
