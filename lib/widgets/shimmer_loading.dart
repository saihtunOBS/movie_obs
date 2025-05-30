import 'package:flutter/material.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:shimmer/shimmer.dart';

Widget shimmerLoading({bool? isVertical}) {
  return GridView.builder(
    itemCount: 10,
    padding: EdgeInsets.symmetric(
      horizontal: kMarginMedium2,
      vertical: isVertical == true ? 0 : 10,
    ),
    itemBuilder:
        (context, index) => Shimmer.fromColors(
          direction: ShimmerDirection.ltr,
          baseColor: Colors.grey,
          highlightColor: kSecondaryColor,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kMargin10),
              color: Colors.grey.withValues(alpha: 0.2),
            ),
          ),
        ),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisExtent: 200,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
    ),
  );
}

Widget homeShimmerLoading({bool? isVertical}) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        15.vGap,
        Shimmer.fromColors(
          direction: ShimmerDirection.ltr,
          baseColor: Colors.grey,
          highlightColor: kSecondaryColor,
          child: Container(
            height: getDeviceType() == 'phone' ? 220 : 350,
            color: Colors.grey.withValues(alpha: 0.2),
          ),
        ),
        kMarginMedium2.vGap,
        SizedBox(
          height: 100,
          child: ListView.builder(
            itemCount: 3,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                direction: ShimmerDirection.ltr,
                baseColor: Colors.grey,
                highlightColor: kSecondaryColor,
                child: SizedBox(
                  width: 70,
                  child: Column(
                    spacing: 10,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: Colors.grey.withValues(alpha: 0.2),
                        ),
                        height: 10,
                        width: 40,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        Shimmer.fromColors(
          direction: ShimmerDirection.ltr,
          baseColor: Colors.grey,
          highlightColor: kSecondaryColor,
          child: Container(
            margin: EdgeInsets.only(left: kMarginMedium2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.grey.withValues(alpha: 0.2),
            ),
            height: 25,
            width: 100,
          ),
        ),

        10.vGap,
        SizedBox(
          height: 180,
          child: ListView.builder(
            itemCount: 10,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: kMarginMedium2),
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                direction: ShimmerDirection.ltr,
                baseColor: Colors.grey,
                highlightColor: kSecondaryColor,
                child: Container(
                  height: 220,
                  width: 140,
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(kMargin10),
                    color: Colors.grey.withValues(alpha: 0.2),
                  ),
                ),
              );
            },
          ),
        ),
        20.vGap,
        Shimmer.fromColors(
          direction: ShimmerDirection.ltr,
          baseColor: Colors.grey,
          highlightColor: kSecondaryColor,
          child: Container(
            margin: EdgeInsets.only(left: kMarginMedium2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.grey.withValues(alpha: 0.2),
            ),
            height: 25,
            width: 100,
          ),
        ),
        GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 5,
          padding: EdgeInsets.symmetric(
            horizontal: kMarginMedium2,
            vertical: 10,
          ),
          itemBuilder:
              (context, index) => Shimmer.fromColors(
                direction: ShimmerDirection.ltr,
                baseColor: Colors.grey,
                highlightColor: kSecondaryColor,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(kMargin10),
                    color: Colors.grey.withValues(alpha: 0.2),
                  ),
                ),
              ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 200,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
        ),
      ],
    ),
  );
}
