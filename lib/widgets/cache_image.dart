import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/images.dart';
import 'package:shimmer/shimmer.dart';

Widget cacheImage(String? url, {BoxFit? boxFit}) {
  if (url == null || url.isEmpty || !url.startsWith('http')) {
    // Return a fallback image or asset when URL is invalid
    return Container(
      padding: EdgeInsets.all(10),
      color: kSecondaryColor.withValues(alpha: 0.2),
      child: Image.asset(kAppIcon, fit: BoxFit.contain),
    );
  }

  return CachedNetworkImage(
    imageUrl: url,
    fit: boxFit ?? BoxFit.cover,
    placeholder: (context, url) => Shimmer.fromColors(
      direction: ShimmerDirection.ltr,
      baseColor: kSecondaryColor.withValues(alpha: 0.5),
      highlightColor: kBlackColor.withValues(alpha: 0.2),
      child: Container(color: kBlackColor.withValues(alpha: 0.2)),
    ),
    errorWidget: (context, url, error) => Container(
      padding: EdgeInsets.all(10),
      color: kSecondaryColor.withValues(alpha: 0.2),
      child: Image.asset(kAppIcon, fit: BoxFit.contain),
    ),
  );
}

