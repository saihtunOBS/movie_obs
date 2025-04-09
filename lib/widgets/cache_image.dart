import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget cacheImage(
  String url,
) {
  return CachedNetworkImage(
    imageUrl: url,
    fit: BoxFit.cover,
    placeholder: (context, url) => Container(
      padding: EdgeInsets.all(3),
      child: CircularProgressIndicator()),
    errorWidget: (context, url, error) => CachedNetworkImage(
      imageUrl: 'https://avatar.iran.liara.run/public/1',
      fit: BoxFit.cover,
    ),
  );
}