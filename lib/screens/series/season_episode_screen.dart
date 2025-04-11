import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/data/dummy/dummy_data.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/list_items/series_list_item.dart';
import 'package:movie_obs/screens/video_player.dart/video_player_screen.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:movie_obs/widgets/cache_image.dart';

import '../../widgets/expandable_text.dart';

class SeasonEpisodeScreen extends StatelessWidget {
  const SeasonEpisodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: getDeviceType() == 'phone' ? 250 : 380,
            automaticallyImplyLeading: false,
            foregroundColor: Colors.white,
            backgroundColor: kBackgroundColor,
            pinned: true,
            stretch: true,
            floating: true,
            flexibleSpace: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                    child: cacheImage(imageArray.first),
                  ),
                ),
                
                Positioned(
                  left: 20,
                  top: 55,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        color: kWhiteColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(CupertinoIcons.arrow_left, size: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          //body
          SliverToBoxAdapter(child: _buildBody(context)),
        ],
      ),
    );
  }

  Widget _buildEpisodeAndViewCount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: kMargin12,
      children: [
        Container(
          height: 23,
          padding: EdgeInsets.symmetric(horizontal: kMarginMedium + 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: kBlackColor,
          ),
          child: Center(
            child: Row(
              spacing: kMargin5,
              children: [
                //Icon(CupertinoIcons.lock, color: kWhiteColor, size: 18),
                Text('Free', style: TextStyle(color: kWhiteColor)),
              ],
            ),
          ),
        ),
         SizedBox(
          width: 5,
          height: 5,
          child: CircleAvatar(backgroundColor: kBlackColor),
        ),
        Text('30 mins', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(
          width: 5,
          height: 5,
          child: CircleAvatar(backgroundColor: kBlackColor),
        ),
        Row(
          spacing: kMargin5,
          children: [
            Icon(CupertinoIcons.eye, size: 20),
            Text('35', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: kMarginMedium2,
        vertical: kMarginMedium2 ,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: getDeviceType() == 'phone' ? 8 : 15,
        children: [
          Center(
            child: Text(
              'Season 1',
              style: TextStyle(fontSize: kTextRegular18 + 2),
            ),
          ),
          _buildEpisodeAndViewCount(),
          1.vGap,
          _buildWatchNowButton(context),
          1.vGap,
          _buildDescription(),
          Text(
            'Queue',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: kTextRegular18,
            ),
          ),
          _seriesListView(),
        ],
      ),
    );
  }

  Widget _seriesListView() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 5,
      itemBuilder: (context, index) {
        return seasonListItem(isSeries: false);
      },
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExpandableText(
          text:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam eros magna, placerat et ullamcorper eu, tincidunt sit amet dolor. Mauris nibh nulla, scelerisque vel euismod non, lobortis vitae nulla. Cras felis libero, maximus at purus at, eleifend varius, Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam eros magna, placerat et ullamcorper eu, tincidunt sit amet dolor. Mauris nibh nulla, scelerisque vel euismod non, lobortis vitae nulla. Cras felis libero, maximus at purus at, eleifend varius',
          style: TextStyle(fontSize: 14, color: kBlackColor),
        ),
      ],
    );
  }

  Widget _buildWatchNowButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushTransparentRoute(
          VideoPlayerScreen(
            url:
                'https://moviedatatesting.s3.ap-southeast-1.amazonaws.com/Movie2/master.m3u8',
            isFirstTime: true,
          ),
        );
      },
      child: Container(
        height: 48,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: kBlackColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            Icon(CupertinoIcons.video_camera, color: kWhiteColor, size: 27),
            Text(
              'Watch Now',
              style: TextStyle(fontWeight: FontWeight.bold, color: kWhiteColor),
            ),
          ],
        ),
      ),
    );
  }

}
