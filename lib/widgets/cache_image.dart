import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:shimmer/shimmer.dart';

Widget cacheImage(String url, {BoxFit? boxFit}) {
  return CachedNetworkImage(
    imageUrl: url,
    fit: boxFit ?? BoxFit.cover,
    placeholder:
        (context, url) => Shimmer.fromColors(
          direction: ShimmerDirection.ltr,
          baseColor: kBlackColor,
          highlightColor: kBlackColor,
          child: Container(color: kBlackColor),
        ),
    errorWidget:
        (context, url, error) => CachedNetworkImage(
          imageUrl: 'https://avatar.iran.liara.run/public/1',
          fit: BoxFit.cover,
        ),
  );
}
