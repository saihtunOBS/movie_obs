import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/home_bloc.dart';
import 'package:movie_obs/bloc/season_episode_bloc.dart';
import 'package:movie_obs/data/vos/season_vo.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/network/responses/movie_detail_response.dart';
import 'package:movie_obs/screens/series/episode_screen.dart';
import 'package:movie_obs/utils/calculate_time.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:movie_obs/widgets/cache_image.dart';
import 'package:movie_obs/widgets/show_loading.dart';
import 'package:provider/provider.dart';

import '../../extension/page_navigator.dart';
import '../../list_items/cast_list_item.dart';
import '../../list_items/episode_list_item.dart';
import '../../network/analytics_service/analytics_service.dart';
import '../../utils/images.dart';
import '../../widgets/common_dialog.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/expandable_text.dart';
import '../home/actor_view_screen.dart';
import 'package:movie_obs/l10n/app_localizations.dart';

import '../video_player.dart/video_player_screen.dart';

class SeasonEpisodeScreen extends StatefulWidget {
  const SeasonEpisodeScreen({
    super.key,
    this.season,
    this.seriesId,
    required this.seriesResponse,
  });
  final SeasonVO? season;
  final String? seriesId;
  final MovieDetailResponse seriesResponse;

  @override
  State<SeasonEpisodeScreen> createState() => _SeasonEpisodeScreenState();
}

class _SeasonEpisodeScreenState extends State<SeasonEpisodeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeBloc>().updateViewCount(
        'Season',
        widget.season?.id ?? '',
      );
      AnalyticsService().logSeasonView(seasonId: widget.season?.id ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:
          (context) => SeasonEpisodeBloc(
            widget.season?.id,
            widget.seriesResponse,
            seriesId: widget.seriesId ?? '',
          ),
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
                            child: cacheImage(
                              widget.season?.bannerImageUrl ?? '',
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -17,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              PageNavigator(ctx: context).nextPage(
                                page: VideoPlayerScreen(
                                  isFirstTime: true,
                                  type: 'trailer',
                                  url: widget.season?.trailerUrl ?? '',
                                ),
                              );
                            },
                            child: Container(
                              height: 35,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                              ),
                              decoration: BoxDecoration(
                                color: kWhiteColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: _buildWatchTrailerView(
                                context,
                                widget.season?.trailerUrl ?? '',
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 20,
                          top: 45,
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

  Widget _buildWatchTrailerView(BuildContext context, String trailerUrl) {
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
              AppLocalizations.of(context)?.watchTrailer ?? '',
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
              formatViewCount(bloc.seasonEpisodeResponse?.viewCount ?? 0),
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
              itemCount: bloc.castsLists.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    PageNavigator(ctx: context).nextPage(
                      page: ActorViewScreen(
                        id: bloc.castsLists[index].cast?.id ?? '',
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: castListItem(actor: bloc.castsLists[index]),
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
              widget.season?.name ?? '',
              style: TextStyle(fontSize: kTextRegular18 + 2),
            ),
          ),
          _buildEpisodeAndViewCount(bloc),
          1.vGap,
          _buildTypeAndWatchList(bloc),
          bloc.castsLists.isEmpty ? SizedBox.shrink() : _buildCastView(bloc),
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
          bloc.isLoading ? LoadingView() : _episodeListView(bloc),
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
                PageNavigator(ctx: context)
                    .nextPage(
                      page: EpisodeScreen(
                        seasonResponse: bloc.seasonEpisodeResponse,
                        episodeData:
                            bloc.seasonEpisodeResponse?.episodes?[index],
                        seriesId: widget.seriesId ?? '',
                        seasonId: widget.season?.id ?? '',
                      ),
                    )
                    .whenComplete(() {
                      bloc.getSeasonEpisode();
                    });
              },
              child: episodeListItem(
                imageUrl: bloc.seasonEpisodeResponse?.bannerImageUrl,
                isLast:
                    (index ==
                        (bloc.seasonEpisodeResponse?.episodes?.length ?? 0) -
                            1),
                isSeries: false,
                data: bloc.seasonEpisodeResponse?.episodes?[index],
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

  Widget _buildTypeAndWatchList(SeasonEpisodeBloc bloc) {
    bool isWishlisted = bloc.seriesDetailResponse?.isWatchlist ?? false;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: kMarginMedium2 - 3,
      children: [
        widget.season?.plan == 'PAY_PER_VIEW'
            ? _payPerView(widget.season?.payPerViewPrice ?? 0, context)
            : Container(
              height: 30,
              padding: EdgeInsets.symmetric(horizontal: kMarginMedium + 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: kSecondaryColor.withValues(alpha: 0.2),
              ),
              child: Center(
                child: Text(
                  widget.season?.plan ?? '',
                  style: TextStyle(color: kPrimaryColor),
                ),
              ),
            ),
        GestureDetector(
          onTap: () {
            bloc.toggleWatchlist();
            setState(() {
              isWishlisted = !isWishlisted;
            });
          },
          child: Container(
            height: 30,
            padding: EdgeInsets.symmetric(horizontal: kMarginMedium),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.transparent,
              border: Border.all(
                color: isWishlisted ? kSecondaryColor : kWhiteColor,
              ),
            ),
            child: Center(
              child: Row(
                spacing: kMargin5,
                children: [
                  Icon(
                    CupertinoIcons.bookmark_fill,
                    size: 18,
                    color: isWishlisted ? kSecondaryColor : kWhiteColor,
                  ),
                  Text('Watchlist', style: TextStyle()),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _payPerView(int price, BuildContext context) {
    return GestureDetector(
      onTap:
          () => showCommonDialog(
            context: context,
            dialogWidget: _buildAlert(price),
          ),
      child: Container(
        height: 30,
        padding: EdgeInsets.symmetric(horizontal: kMarginMedium + 4),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: kSecondaryColor.withValues(alpha: 0.2),
        ),
        child: Center(
          child: Row(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, color: kPrimaryColor, size: 15),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  '$price Ks to Unlock',
                  style: TextStyle(color: kPrimaryColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlert(int price) {
    return Dialog(
      insetPadding: const EdgeInsets.all(10),
      backgroundColor: kWhiteColor,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.withValues(alpha: 0.4),
                  ),
                  child: Center(
                    child: Icon(
                      CupertinoIcons.clear,
                      color: kBlackColor,
                      size: 10,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 56, width: 56, child: Image.asset(kLockOpenLogo)),
            15.vGap,
            Text(
              'Unlock this movie for only $price Ks!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: kTextRegular2x,
                color: kSecondaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            2.vGap,
            Text(
              'Pay now to start watching instantly.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: kTextRegular13, color: kBlackColor),
            ),
            20.vGap,
            SizedBox(
              width: 140,
              child: customButton(
                height: 35,
                borderRadius: 20,
                onPress: () {},
                context: context,
                backgroundColor: kSecondaryColor,
                title: 'Purchase',
                textColor: kWhiteColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
