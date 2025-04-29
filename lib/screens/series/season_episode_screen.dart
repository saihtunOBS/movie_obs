import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/season_episode_bloc.dart';
import 'package:movie_obs/data/vos/season_vo.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/list_items/series_list_item.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:movie_obs/widgets/cache_image.dart';
import 'package:provider/provider.dart';

import '../../extension/page_navigator.dart';
import '../../list_items/cast_list_item.dart';
import '../../widgets/expandable_text.dart';
import '../home/actor_view_screen.dart';

class SeasonEpisodeScreen extends StatelessWidget {
  const SeasonEpisodeScreen({super.key, this.season});
  final SeasonVO? season;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SeasonEpisodeBloc(season?.id),
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: Consumer<SeasonEpisodeBloc>(
          builder:
              (context, bloc, child) => CustomScrollView(
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
                              bottomLeft: Radius.circular(35),
                              bottomRight: Radius.circular(35),
                            ),
                            child: cacheImage(season?.bannerImageUrl ?? ''),
                          ),
                        ),
                        Positioned(
                          bottom: -17,
                          child: Container(
                            height: 35,
                            padding: const EdgeInsets.symmetric(horizontal: 5),
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
                                child: Icon(
                                  CupertinoIcons.arrow_left,
                                  size: 20,
                                  color: kBlackColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //body
                  SliverToBoxAdapter(child: _buildBody(context, bloc)),
                ],
              ),
        ),
      ),
    );
  }

  Widget _buildWatchTrailerView() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              CupertinoIcons.play_circle_fill,
              size: 26,
              color: kBlackColor,
            ),
            const SizedBox(width: 5),
            Text(
              'Watch Trailer',
              style: TextStyle(
                fontSize: kTextRegular2x - 3,
                color: kBlackColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEpisodeAndViewCount(SeasonEpisodeBloc bloc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: kMargin12 + 4,
      children: [
        Text(
          '${bloc.seasonEpisodeResponse?.episodes?.length ?? 0} episodes',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 5,
          height: 5,
          child: CircleAvatar(backgroundColor: kWhiteColor),
        ),
        Row(
          spacing: kMargin5,
          children: [
            Icon(CupertinoIcons.eye, size: 20),
            Text(
              '${bloc.seasonEpisodeResponse?.viewCount ?? 0}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCastView(SeasonEpisodeBloc bloc) {
    return SizedBox(
      height: 100,
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: bloc.seasonEpisodeResponse?.actors?.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    PageNavigator(ctx: context).nextPage(
                      page: ActorViewScreen(
                        id:
                            bloc
                                .seasonEpisodeResponse
                                ?.actors?[index]
                                .cast
                                ?.id ??
                            '',
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: castListItem(
                      actor: bloc.seasonEpisodeResponse?.actors?[index],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, SeasonEpisodeBloc bloc) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: kMarginMedium2,
        vertical: kMarginMedium2 + 15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: getDeviceType() == 'phone' ? 8 : 15,
        children: [
          Center(
            child: Text(
              season?.name ?? '',
              style: TextStyle(fontSize: kTextRegular18 + 2),
            ),
          ),
          _buildEpisodeAndViewCount(bloc),
          1.vGap,
          _buildTypeAndWatchList(),
          bloc.seasonEpisodeResponse?.actors?.isEmpty ?? true
              ? SizedBox.shrink()
              : _buildCastView(bloc),
          _buildDescription(bloc),
          5.vGap,
          bloc.seasonEpisodeResponse?.episodes?.isEmpty ?? true
              ? SizedBox.shrink()
              : Text(
                'Episodes (${bloc.seasonEpisodeResponse?.episodes?.length})',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: kTextRegular18,
                ),
              ),
          _episodeListView(bloc),
        ],
      ),
    );
  }

  Widget _episodeListView(SeasonEpisodeBloc bloc) {
    return bloc.seasonEpisodeResponse?.episodes?.isEmpty ?? true
        ? SizedBox.shrink()
        : ListView.builder(
          padding: EdgeInsets.zero,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: bloc.seasonEpisodeResponse?.episodes?.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                // PageNavigator(ctx: context).nextPage(page: SeasonEpisodeScreen());
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: seasonListItem(
                  isLast:
                      (index ==
                          (bloc.seasonEpisodeResponse?.episodes?.length ?? 0) -
                              1),
                  isSeries: false,
                  data: bloc.seasonEpisodeResponse?.episodes?[index],
                ),
              ),
            );
          },
        );
  }

  Widget _buildDescription(SeasonEpisodeBloc bloc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExpandableText(
          text: bloc.seasonEpisodeResponse?.description ?? '',
          style: TextStyle(fontSize: 14),
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
