import 'package:flutter/material.dart';
import 'package:movie_obs/data/vos/movie_vo.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:movie_obs/widgets/cache_image.dart';

Widget movieListItem({
  bool? isHomeScreen,
  MovieVO? movies,
  bool? isMovieAndSeries,
  double? padding,
  String? type,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: Container(
          height: 180,
          width: double.infinity,
          margin: EdgeInsets.only(right: padding ?? 0.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kMargin10),
            color: Colors.grey.withValues(alpha: 0.2),
          ),
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(kMargin10),
                child: cacheImage(
                  movies?.posterImageUrl ?? '',
                  // boxFit: BoxFit.fill,
                ),
              ),
              Positioned(
                left: 10,
                top: 10,
                child: Container(
                  decoration: BoxDecoration(
                    color: kSecondaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      type == ('PAY_PER_VIEW')
                          ? EdgeInsets.all(3)
                          : EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  child: Center(
                    child:
                        type == ('PAY_PER_VIEW')
                            ? Icon(Icons.lock, size: 15)
                            : Text(
                              type == 'PAID' ? 'Premium' : type ?? '',
                              style: TextStyle(
                                fontSize: kTextSmall,
                                fontWeight: FontWeight.w600,
                                color: kWhiteColor,
                              ),
                            ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      8.vGap,
      isHomeScreen == true
          ? Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Text(
              movies?.name ?? '',
              maxLines: 1,

              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: kWhiteColor, height: 1.7),
            ),
          )
          : SizedBox.shrink(),
    ],
  );
}
