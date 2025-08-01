import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/data/vos/episode_vo.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/utils/calculate_time.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:movie_obs/widgets/cache_image.dart';

import '../utils/colors.dart';

Widget episodeListItem({
  bool? isSeries,
  EpisodeVO? data,
  bool? isLast,
  Color? color,
  String? imageUrl,
}) {
  return Column(
    spacing: 2,
    children: [
      Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: 80,
                width: 120,
                child: Stack(
                  fit: StackFit.passthrough,
                  children: [
                    cacheImage(imageUrl),
                    Center(
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black45,
                        ),
                        child: Center(
                          child: Icon(
                            CupertinoIcons.play,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Column(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data?.name ?? '',
                    style: TextStyle(
                      fontSize: kTextRegular2x,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      Visibility(
                        visible: isSeries == false,
                        child: Row(
                          spacing: 10,
                          children: [
                            Container(
                              height: 23,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: kSecondaryColor.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  data?.plan ?? '',
                                  style: TextStyle(
                                    color: kPrimaryColor,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                              height: 5,
                              child: CircleAvatar(backgroundColor: Colors.grey),
                            ),
                            1.hGap,
                          ],
                        ),
                      ),

                      Text(
                        isSeries == false
                            ? formatMinutesToHoursAndMinutes(
                              data?.duration ?? 0,
                            )
                            : '25 Episodes',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                      10.hGap,
                      SizedBox(
                        width: 5,
                        height: 5,
                        child: CircleAvatar(backgroundColor: Colors.grey),
                      ),
                      10.hGap,
                      Row(
                        spacing: kMargin5,
                        children: [
                          Icon(
                            CupertinoIcons.eye,
                            size: 20,
                            color: Colors.grey,
                          ),
                          Text(
                            formatViewCount(data?.viewCount ?? 0),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      isLast == true ? SizedBox.shrink() : Divider(thickness: 0.5),
    ],
  );
}
