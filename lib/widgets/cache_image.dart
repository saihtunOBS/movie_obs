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
          baseColor: Colors.grey.withValues(alpha: 0.8),
          highlightColor: kBlackColor,
          child: Container(color: Colors.black26),
        ),
    errorWidget:
        (context, url, error) => CachedNetworkImage(
          imageUrl: 'https://avatar.iran.liara.run/public/1',
          fit: BoxFit.cover,
        ),
  );
}
