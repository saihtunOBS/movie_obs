import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/data/dummy/dummy_data.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/extension/page_navigator.dart';
import 'package:movie_obs/list_items/series_list_item.dart';
import 'package:movie_obs/screens/series/series_season_screen.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:movie_obs/widgets/cache_image.dart';

class SeriesTitleScreen extends StatelessWidget {
  const SeriesTitleScreen({super.key});

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
                        child: Icon(CupertinoIcons.arrow_left, size: 20,color: kBlackColor,),
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

  Widget _buildBody(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: kMarginMedium2,
        vertical: kMarginMedium2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: getDeviceType() == 'phone' ? 8 : 15,
        children: [
          Center(
            child: Text(
              'Series Title',
              style: TextStyle(fontSize: kTextRegular18 + 2),
            ),
          ),
          Center(
            child: Text(
              'Action , Adventure',
              style: TextStyle(
                fontSize: kTextSmall,
                color: kThirdColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildTypeAndWatchList(),
          1.vGap,
          _buildDescription(),
          Text(
            'Seasons',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: kTextRegular18,
            ),
          ),
          _seriesListView(),

          //tag view
          _buildTagView(),
        ],
      ),
    );
  }

  Widget _buildTagView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tags', style: TextStyle(fontWeight: FontWeight.w700)),
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
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

  Widget _seriesListView() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 5,
      itemBuilder: (context, index) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            PageNavigator(ctx: context).nextPage(page: SeriesSeasonScreen());
          },
          child: seasonListItem(),
        );
      },
    );
  }

  Widget _buildDescription() {
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Director : Myanmar',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        Text(
          'Script Writer : Myanmar',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),

        5.vGap,
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
            color: kSecondaryColor.withValues(alpha: 0.2),
          ),
          child: Center(
            child: Row(
              spacing: kMargin5,
              children: [
                //Icon(CupertinoIcons.lock, color: kWhiteColor, size: 18),
                Text('Free', style: TextStyle(color: kThirdColor)),
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
            border: Border.all(color: kWhiteColor),
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
