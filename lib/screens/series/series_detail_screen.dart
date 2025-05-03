import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/series_detail_bloc.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/extension/page_navigator.dart';
import 'package:movie_obs/list_items/recommended_movie_list_item.dart';
import 'package:movie_obs/list_items/series_list_item.dart';
import 'package:movie_obs/screens/series/season_episode_screen.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:movie_obs/widgets/cache_image.dart';
import 'package:provider/provider.dart';

import '../../data/vos/movie_vo.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class SeriesDetailScreen extends StatelessWidget {
  const SeriesDetailScreen({super.key, this.series});
  final MovieVO? series;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SeriesDetailBloc(series?.id),
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: Consumer<SeriesDetailBloc>(
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
                            child: cacheImage(series?.posterImageUrl ?? ''),
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
              series?.name ?? '',
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
          _buildDescription(bloc,context),
          Text(
            'Seasons',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: kTextRegular18,
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
                  return recommendedMovieListItem(
                    bloc.recommendedList?[index] ?? MovieVO(),
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
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: seasonListItem(
                  data: bloc.seriesResponse?.seasons?[index],
                ),
              ),
            );
          },
        );
  }

  Widget _buildDescription(SeriesDetailBloc bloc,BuildContext context) {
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
