import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/episode_bloc.dart';
import 'package:movie_obs/data/vos/episode_vo.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/network/responses/season_episode_response.dart';
import 'package:movie_obs/screens/video_player.dart/video_player_screen.dart';
import 'package:movie_obs/utils/calculate_time.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:movie_obs/widgets/cache_image.dart';
import 'package:provider/provider.dart';

import '../../list_items/episode_list_item.dart';
import '../../widgets/expandable_text.dart';

class EpisodeScreen extends StatelessWidget {
  const EpisodeScreen({
    super.key,
    this.episodeResponse,
    this.episodeData,
    required this.seriesId,
  });
  final SeasonEpisodeResponse? episodeResponse;
  final EpisodeVO? episodeData;
  final String seriesId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EpisodeBloc(episodeData ?? EpisodeVO()),
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: Consumer<EpisodeBloc>(
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
                            child: cacheImage(episodeResponse?.bannerImageUrl),
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

  Widget _buildEpisodeAndViewCount(EpisodeBloc bloc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: kMargin12,
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
                Text(
                  bloc.currentEpisode?.plan ?? '',
                  style: TextStyle(color: kPrimaryColor),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 5,
          height: 5,
          child: CircleAvatar(backgroundColor: kWhiteColor),
        ),
        Text(
          formatMinutesToHoursAndMinutes(bloc.currentEpisode?.duration ?? 0),
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
              bloc.currentEpisode?.viewCount.toString() ?? '0',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, EpisodeBloc bloc) {
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
              bloc.currentEpisode?.name ?? '',
              style: TextStyle(fontSize: kTextRegular18 + 2),
            ),
          ),
          _buildEpisodeAndViewCount(bloc),
          1.vGap,
          _buildWatchNowButton(context, bloc),
          1.vGap,
          _buildDescription(bloc),
          5.vGap,
          Text(
            'Queue',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: kTextRegular18,
            ),
          ),
          _episodeListView(bloc),
          20.vGap,
        ],
      ),
    );
  }

  Widget _episodeListView(EpisodeBloc bloc) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: episodeResponse?.episodes?.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            bloc.changeEpisode(
              episodeResponse?.episodes?[index] ?? EpisodeVO(),
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal:
                  bloc.currentEpisode?.id ==
                          episodeResponse?.episodes?[index].id
                      ? 20
                      : 0,
            ),

            child: episodeListItem(
              imageUrl: episodeResponse?.bannerImageUrl,
              isSeries: false,
              isLast: index == (episodeResponse?.episodes?.length ?? 0) - 1,
              data: episodeResponse?.episodes?[index],
              color:
                  bloc.currentEpisode?.id ==
                          episodeResponse?.episodes?[index].id
                      ? kSecondaryColor.withValues(alpha: 0.2)
                      : Colors.transparent,
            ),
          ),
        );
      },
    );
  }

  Widget _buildDescription(EpisodeBloc bloc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExpandableText(
          text: bloc.currentEpisode?.description ?? '',
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildWatchNowButton(BuildContext context, EpisodeBloc bloc) {
    return GestureDetector(
      onTap: () {
        context.pushTransparentRoute(
          VideoPlayerScreen(
            url: bloc.currentEpisode?.videoUrl ?? '',
            isFirstTime: true,
            type: 'SERIES',
            videoId: seriesId,
          ),
        );
      },
      child: Container(
        height: 48,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: kSecondaryColor,
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
