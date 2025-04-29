import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/images.dart';
import 'package:shimmer/shimmer.dart';

Widget cacheImage(String url, {BoxFit? boxFit}) {
  return CachedNetworkImage(
    imageUrl: url,
    fit: boxFit ?? BoxFit.cover,
    placeholder:
        (context, url) => Shimmer.fromColors(
          direction: ShimmerDirection.ltr,
          baseColor: kSecondaryColor.withValues(alpha: 0.3),
          highlightColor: kBlackColor,
          child: Container(color: kBlackColor),
        ),
    errorWidget:
        (context, url, error) => Container(
          padding: EdgeInsets.all(10),
          color: kSecondaryColor.withValues(alpha: 0.2),
          child: Image.asset(kAppIcon, fit: BoxFit.contain),
        ),
  );
}
