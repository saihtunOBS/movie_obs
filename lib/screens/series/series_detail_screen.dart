import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/home_bloc.dart';
import 'package:movie_obs/bloc/series_detail_bloc.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/extension/page_navigator.dart';
import 'package:movie_obs/list_items/recommended_movie_list_item.dart';
import 'package:movie_obs/list_items/series_list_item.dart';
import 'package:movie_obs/network/analytics_service/analytics_service.dart';
import 'package:movie_obs/network/responses/movie_detail_response.dart';
import 'package:movie_obs/screens/series/season_episode_screen.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:movie_obs/widgets/cache_image.dart';
import 'package:provider/provider.dart';

import '../../data/vos/movie_vo.dart';
import 'package:movie_obs/l10n/app_localizations.dart';

class SeriesDetailScreen extends StatefulWidget {
  const SeriesDetailScreen({super.key, this.series});
  final MovieVO? series;

  @override
  State<SeriesDetailScreen> createState() => _SeriesDetailScreenState();
}

class _SeriesDetailScreenState extends State<SeriesDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeBloc>().updateViewCount(
        'Series',
        widget.series?.id ?? '',
      );
      AnalyticsService().logSeriesView(seriesId: widget.series?.id ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SeriesDetailBloc(widget.series?.id, context),
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          centerTitle: false,
          title: Text(AppLocalizations.of(context)?.back ?? ''),
          surfaceTintColor: kBlackColor,
          backgroundColor: kBlackColor,
        ),
        body: Consumer<SeriesDetailBloc>(
          builder:
              (context, bloc, child) => CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: getDeviceType() == 'phone' ? 250 : 380,
                    automaticallyImplyLeading: false,
                    foregroundColor: Colors.white,
                    backgroundColor: kBackgroundColor,
                    pinned: false,
                    stretch: false,
                    floating: true,
                    flexibleSpace: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: double.infinity,
                          width: double.infinity,
                          child: cacheImage(
                            widget.series?.bannerImageUrl ?? '',
                          ),
                        ),
                        Container(
                          height: double.infinity,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.center,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black45],
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

  Widget _buildBody(BuildContext context, SeriesDetailBloc bloc) {
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
              widget.series?.name ?? '',
              style: TextStyle(fontSize: kTextRegular18 + 2),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                bloc.seriesResponse?.genres
                        ?.map((genre) => genre.name ?? '')
                        .join(', ') ??
                    '',
                style: TextStyle(
                  fontSize: kTextSmall,
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          10.vGap,
          _buildDescription(bloc, context),
          Visibility(
            visible: bloc.seriesResponse?.seasons?.isNotEmpty ?? true,
            child: Text(
              'Seasons',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: kTextRegular18,
              ),
            ),
          ),
          _buildSeasonListView(bloc),

          //tag view
          _buildTagView(bloc),
          5.vGap,
          //recommended view
          _buildRecommendedView(bloc),

          10.vGap,
        ],
      ),
    );
  }

  Widget _buildTagView(SeriesDetailBloc bloc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tags', style: TextStyle(fontWeight: FontWeight.w700)),
        bloc.seriesResponse?.tags?.isEmpty ?? true
            ? SizedBox.shrink()
            : SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: bloc.seriesResponse?.tags?.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Chip(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      label: Text(
                        '#${bloc.seriesResponse?.tags?[index]}',
                        style: TextStyle(color: kWhiteColor),
                      ),
                      backgroundColor: kBlackColor,
                    ),
                  );
                },
              ),
            ),
      ],
    );
  }

  Widget _buildRecommendedView(SeriesDetailBloc bloc) {
    return bloc.recommendedList?.isEmpty ?? true
        ? SizedBox.shrink()
        : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recommended',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: kTextRegular18,
              ),
            ),
            7.vGap,
            SizedBox(
              height: 170,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: bloc.recommendedList?.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      PageNavigator(ctx: context).nextPage(
                        page: SeriesDetailScreen(
                          series: bloc.recommendedList?[index],
                        ),
                      );
                    },
                    child: recommendedMovieListItem(
                      bloc.recommendedList?[index] ?? MovieVO(),
                    ),
                  );
                },
              ),
            ),
          ],
        );
  }

  Widget _buildSeasonListView(SeriesDetailBloc bloc) {
    return bloc.seriesResponse?.seasons?.isEmpty ?? true
        ? SizedBox.shrink()
        : ListView.builder(
          padding: EdgeInsets.zero,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: bloc.seriesResponse?.seasons?.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                PageNavigator(ctx: context).nextPage(
                  page: SeasonEpisodeScreen(
                    season: bloc.seriesResponse?.seasons?[index],
                    seriesResponse:
                        bloc.seriesResponse ?? MovieDetailResponse(),
                    seriesId: bloc.seriesResponse?.id,
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: seriesListItem(
                  data: bloc.seriesResponse?.seasons?[index],
                  episodes:
                      bloc.seriesResponse?.seasons?[index].episodeCount ?? 0,
                ),
              ),
            );
          },
        );
  }

  Widget _buildDescription(SeriesDetailBloc bloc, BuildContext context) {
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${AppLocalizations.of(context)?.director} ${bloc.seriesResponse?.director ?? ''}',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        Divider(thickness: 0.5),
        Text(
          '${AppLocalizations.of(context)?.scriptWriter} ${bloc.seriesResponse?.scriptWriter ?? ''}',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),

        5.vGap,
      ],
    );
  }
}
