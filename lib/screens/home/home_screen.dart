import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/home_bloc.dart';
import 'package:movie_obs/data/vos/movie_vo.dart';
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
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeBloc(context),
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          title: Text('LOGO'),
          centerTitle: false,
          backgroundColor: Colors.transparent,
          surfaceTintColor: kBackgroundColor,
          foregroundColor: kWhiteColor,
          actions: [
            CircleAvatar(
              backgroundColor: Colors.black12,
              child: Icon(CupertinoIcons.layers),
            ),
            10.hGap,
            InkWell(
              onTap: () {
                PageNavigator(
                  ctx: context,
                ).nextPage(page: NotificationScreen());
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

        body: Consumer<HomeBloc>(
          builder:
              (context, bloc, child) => CustomScrollView(
                physics: ClampingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Container(height: 15, color: kBackgroundColor),
                  ),
                  //carousel
                  SliverToBoxAdapter(
                    child: Container(
                      height: getDeviceType() == 'phone' ? 220 : 350,
                      color: Colors.transparent,
                      child: BannerImageAnimation(),
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: 0)),
                  //options
                  SliverToBoxAdapter(child: _buildOptions()),

                  //free movie & series
                  SliverToBoxAdapter(
                    child: _buildMovieOptions(
                      'Free Movie & Series',
                      () {},
                      bloc.movieLists,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: getDeviceType() == 'phone' ? 10 : 20,
                    ),
                  ),
                  //top trending
                  SliverToBoxAdapter(
                    child: Visibility(
                      visible: bloc.topTrendingMoviesList.isNotEmpty,
                      child: _buildMovieOptions('Top Trending', () {
                        PageNavigator(
                          ctx: context,
                        ).nextPage(page: TopTrendingScreen());
                      }, bloc.topTrendingMoviesList),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height:
                          bloc.topTrendingMoviesList.isNotEmpty
                              ? getDeviceType() == 'phone'
                                  ? 10
                                  : 20
                              : 0,
                    ),
                  ),
                  //new release
                  SliverToBoxAdapter(
                    child: Visibility(
                      visible: bloc.newReleaseMoviesList.isNotEmpty,
                      child: _buildMovieOptions('New Releases', () {
                        PageNavigator(
                          ctx: context,
                        ).nextPage(page: NewReleaseScreen(movieLists: bloc.newReleaseMoviesList,));
                      }, bloc.newReleaseMoviesList),
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 20)),
                ],
              ),
        ),
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

  Widget _buildMovieOptions(
    String title,
    VoidCallback onPress,
    List<MovieVO> movies,
  ) {
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
                    fontSize: kTextRegular3x - 1,
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
              itemCount: movies.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    PageNavigator(
                      ctx: context,
                    ).nextPage(page: MovieTypeScreen(movie: movies[index]));
                  },
                  child: SizedBox(
                    width: 180,
                    child: movieListItem(movies: movies[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
