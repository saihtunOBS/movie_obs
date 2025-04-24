import 'package:flutter/material.dart';
import 'package:movie_obs/utils/images.dart';

Widget castListItem() {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    spacing: 10,
    children: [
      Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey.withValues(alpha: 0.2),
        ),
        child: Center(child: Image.asset(kUserIcon,width: 32,height: 32,)),
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 3,
        children: [Text('Name'), Text('Movie\'s Actor name')]),
    ],
  );
}
