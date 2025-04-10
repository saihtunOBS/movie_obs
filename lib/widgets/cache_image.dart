import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:shimmer/shimmer.dart';

Widget cacheImage(
  String url,
) {
  return CachedNetworkImage(
    imageUrl: url,
    fit: BoxFit.cover,
    placeholder: (context, url) => Shimmer.fromColors(
        direction: ShimmerDirection.ltr,
        baseColor: Colors.black12,
        highlightColor: kWhiteColor,
        child: Container(
          color: Colors.black12,
        )),
    errorWidget: (context, url, error) => CachedNetworkImage(
      imageUrl: 'https://avatar.iran.liara.run/public/1',
      fit: BoxFit.cover,
    ),
  );
}