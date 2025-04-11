import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/extension/page_navigator.dart';
import 'package:movie_obs/list_items/movie_list_item.dart';
import 'package:movie_obs/screens/home/notification_screen.dart';
import 'package:movie_obs/widgets/banner_image_animation.dart';
import 'package:movie_obs/screens/home/movie_type_screen.dart';
import 'package:movie_obs/screens/home/new_release_screen.dart';
import 'package:movie_obs/screens/home/top_trending_screen.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: Text('LOGO'),
        centerTitle: false,
        backgroundColor: Colors.white,
        surfaceTintColor: kBackgroundColor,
        actions: [
          CircleAvatar(
            backgroundColor: Colors.black12,
            child: Icon(CupertinoIcons.layers),
          ),
          10.hGap,
          InkWell(
            onTap: () {
              PageNavigator(ctx: context).nextPage(page: NotificationScreen());
            },
            child: CircleAvatar(
              backgroundColor: Colors.black12,
              child: Icon(CupertinoIcons.bell),
            ),
          ),
          10.hGap,
          CircleAvatar(
            backgroundColor: Colors.black12,
            child: Icon(CupertinoIcons.search),
          ),
          10.hGap,
        ],
      ),

      body: CustomScrollView(
        physics: ClampingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: Container(height: 15, color: kWhiteColor)),
          //carousel
          SliverToBoxAdapter(
            child: Container(
              height: getDeviceType() == 'phone' ? 220 : 350,
              color: kWhiteColor,
              child: BannerImageAnimation(),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: 10)),
          //options
          SliverToBoxAdapter(child: _buildOptions()),

          //free movie & series
          SliverToBoxAdapter(
            child: _buildMovieOptions('Free Movie & Series', () {}),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 10)),
          //top trending
          SliverToBoxAdapter(
            child: _buildMovieOptions('Top Trending', () {
              PageNavigator(ctx: context).nextPage(page: TopTrendingScreen());
            }),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 10)),
          //new release
          SliverToBoxAdapter(
            child: _buildMovieOptions('New Releases', () {
              PageNavigator(ctx: context).nextPage(page: NewReleaseScreen());
            }),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  Widget _buildOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: kMarginMedium2,
        vertical: kMarginMedium2,
      ),
      child: Row(
        spacing: 20,
        children: [
          Column(
            spacing: 5,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(kMarginMedium + 5),
                ),
                child: Center(
                  child: Icon(CupertinoIcons.dot_radiowaves_left_right),
                ),
              ),
              Text('Live'),
            ],
          ),
          Column(
            spacing: 5,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(kMarginMedium + 5),
                ),
                child: Center(child: Icon(CupertinoIcons.app_badge)),
              ),
              Text('Program'),
            ],
          ),
          Column(
            spacing: 5,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(kMarginMedium + 5),
                ),
                child: Center(child: Icon(CupertinoIcons.bookmark)),
              ),
              Text('Watchlist'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMovieOptions(String title, VoidCallback onPress) {
    return SizedBox(
      height: 250,
      width: double.infinity,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kMarginMedium2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: kTextRegular3x,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                IconButton(
                  onPressed: onPress,
                  icon: Icon(CupertinoIcons.arrow_right, size: 20),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: kMarginMedium2),
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    PageNavigator(
                      ctx: context,
                    ).nextPage(page: MovieTypeScreen());
                  },
                  child: SizedBox(width: 180, child: movieListItem()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
