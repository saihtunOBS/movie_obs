import 'package:flutter/material.dart';
import 'package:movie_obs/network/responses/movie_detail_response.dart';
import 'package:movie_obs/widgets/cache_image.dart';

Widget castListItem({ActorVO? actor}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    spacing: 10,
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.2)),
          child: Center(
            child: cacheImage(actor?.cast?.profilePictureUrl ?? ''),
          ),
        ),
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 3,
        children: [
          Text(actor?.cast?.name ?? ''),
          Text(actor?.characterName ?? ''),
        ],
      ),
    ],
  );
}
