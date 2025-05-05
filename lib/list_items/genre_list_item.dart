import 'package:flutter/material.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/widgets/cache_image.dart';

import '../data/vos/genre_vo.dart' show GenreVO;

Widget genreListItem(GenreVO data) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: Colors.grey.withValues(alpha: 0.2),
    ),
    child: Row(
      spacing: 10,
      children: [
        1.hGap,
        Container(
          height: 35,
          width: 35,
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: kSecondaryColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: cacheImage(''),
        ),
        Text( 'hello', style: TextStyle(fontWeight: FontWeight.w700)),
      ],
    ),
  );
}
