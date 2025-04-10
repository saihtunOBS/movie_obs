import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/data/dummy/dummy_data.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/extension/page_navigator.dart';
import 'package:movie_obs/list_items/cast_list_item.dart';
import 'package:movie_obs/screens/home/actor_view_screen.dart';
import 'package:movie_obs/screens/video_player.dart/video_player_screen.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:movie_obs/widgets/cache_image.dart';

class MovieTypeScreen extends StatelessWidget {
  const MovieTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
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
                  bottom: -20,
                  child: Container(
                    height: 42,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: kWhiteColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: _buildWatchTrailerView(),
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

  Widget _buildWatchTrailerView() {
    return Container(
      height: 42,
      width: 167,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(CupertinoIcons.play_circle_fill),
            const SizedBox(width: 5),
            Text('Watch Trailer', style: TextStyle(fontSize: kTextRegular18)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: kMarginMedium2,
        vertical: kMarginMedium2 + 15,
      ),
      child: Column(
        spacing: 10,
        children: [
          Center(
            child: Text(
              'Movie Title',
              style: TextStyle(fontSize: kTextRegular18),
            ),
          ),
          _buildMinuteAndViewCount(),
          Center(
            child: Text(
              'Action , Adventure',
              style: TextStyle(
                fontSize: kTextSmall,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildTypeAndWatchList(),
          1.vGap,
          _buildWatchNowButton(context),
          1.vGap,
          _buildCastView(),
          1.vGap,
          _buildDescription(),
        ],
      ),
    );
  }

  Widget _buildCastView() {
    return SizedBox(
      height: 100,
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('The Cast', style: TextStyle(fontSize: kTextRegular18)),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    PageNavigator(
                      ctx: context,
                    ).nextPage(page: ActorViewScreen());
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: castListItem(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Director : Myanmar',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        10.vGap,
        Text(
          'Script Writer : Myanmar',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        10.vGap,
        Text(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam eros magna, placerat et ullamcorper eu, tincidunt sit amet dolor. Mauris nibh nulla, scelerisque vel euismod non, lobortis vitae nulla. Cras felis libero, maximus at purus at, eleifend varius ex... View more',
        ),
        10.vGap,
        Text('Tags', style: TextStyle(fontWeight: FontWeight.w700)),
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Chip(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  label: Text('#Title', style: TextStyle(color: kWhiteColor)),
                  backgroundColor: kBlackColor,
                ),
              );
            },
          ),
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
            isFirstTime: false,
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
            Icon(CupertinoIcons.video_camera, color: kWhiteColor),
            Text(
              'Watch Now',
              style: TextStyle(fontWeight: FontWeight.bold, color: kWhiteColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMinuteAndViewCount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: kMargin12 + 4,
      children: [
        Text('3 hr 30 mins', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(
          width: 5,
          height: 5,
          child: CircleAvatar(backgroundColor: kBlackColor),
        ),

        Row(
          spacing: kMargin5,
          children: [
            Icon(CupertinoIcons.eye),
            Text('35', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _buildTypeAndWatchList() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: kMarginMedium2 - 3,
      children: [
        Container(
          height: 30,
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
        Container(
          height: 30,
          padding: EdgeInsets.symmetric(horizontal: kMarginMedium),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.transparent,
            border: Border.all(color: kBlackColor),
          ),
          child: Center(
            child: Row(
              spacing: kMargin5,
              children: [
                Icon(CupertinoIcons.bookmark, size: 18),
                Text('Watchlist', style: TextStyle()),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
