import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/actor_bloc.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/extension/page_navigator.dart';
import 'package:movie_obs/network/responses/movie_detail_response.dart';
import 'package:movie_obs/screens/home/movie_detail_screen.dart';
import 'package:movie_obs/screens/series/season_episode_screen.dart';
import 'package:movie_obs/screens/series/series_detail_screen.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:movie_obs/widgets/cache_image.dart';
import 'package:movie_obs/widgets/show_loading.dart';
import 'package:provider/provider.dart';

import '../../list_items/movie_list_item.dart';
import 'package:movie_obs/l10n/app_localizations.dart';

class ActorViewScreen extends StatelessWidget {
  const ActorViewScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ActorBloc(actorId: id),
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          backgroundColor: kBackgroundColor,
          surfaceTintColor: kBackgroundColor,
          title: Text(AppLocalizations.of(context)?.back ?? ''),
          centerTitle: false,
        ),
        body: Consumer<ActorBloc>(
          builder:
              (context, bloc, child) =>
                  bloc.isLoading
                      ? LoadingView()
                      : SingleChildScrollView(
                        child: Column(
                          spacing: 15,
                          children: [
                            _buildActorView(context, bloc),
                            1.vGap,
                            bloc.actorData?.movieCounts == 0
                                ? SizedBox.shrink()
                                : _buildMovieView(context, bloc),
                            bloc.actorData?.seasons?.isEmpty ?? true
                                ? SizedBox.shrink()
                                : _builSeriesView(context, bloc),
                            20.vGap,
                          ],
                        ),
                      ),
        ),
      ),
    );
  }

  Widget _buildMovieView(BuildContext context, ActorBloc bloc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 2,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kMarginMedium2),
          child: Text(
            AppLocalizations.of(context)?.movies ?? '',
            style: TextStyle(
              fontSize: kTextRegular2x,
              color: kWhiteColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        GridView.builder(
          itemCount: bloc.actorData?.movies?.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: getDeviceType() == 'phone' ? 2 : 3,
            mainAxisExtent: 230,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: kMarginMedium2,
            vertical: kMarginMedium2 - 5,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                PageNavigator(ctx: context).nextPage(
                  page: MovieDetailScreen(
                    movie: bloc.actorData?.movies?[index],
                  ),
                );
              },
              child: movieListItem(
                isHomeScreen: true,
                movies: bloc.actorData?.movies?[index],
                type: 'movie',
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _builSeriesView(BuildContext context, ActorBloc bloc) {
    return Column(
      spacing: 2,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kMarginMedium2),
          child: Text(
            AppLocalizations.of(context)?.series ?? '',
            style: TextStyle(
              fontSize: kTextRegular2x,
              color: kWhiteColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        GridView.builder(
          itemCount: bloc.actorData?.seasons?.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: getDeviceType() == 'phone' ? 2 : 3,
            mainAxisExtent: 230,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: kMarginMedium2,
            vertical: kMarginMedium2 - 5,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                if (bloc.actorData?.seasons?[index].seasons?.length == 1) {
                  PageNavigator(ctx: context).nextPage(
                    page: SeasonEpisodeScreen(
                      seriesResponse:
                          bloc.actorData?.seasons?[index].toDetail() ??
                          MovieDetailResponse(),
                      seriesId: bloc.actorData?.seasons?[index].id,
                      season: bloc.actorData?.seasons?[index].seasons?.first,
                    ),
                  );
                } else {
                  PageNavigator(ctx: context).nextPage(
                    page: SeriesDetailScreen(
                      series: bloc.actorData?.seasons?[index],
                    ),
                  );
                }
              },
              child: movieListItem(
                isHomeScreen: true,
                movies: bloc.actorData?.seasons?[index],
                type: bloc.actorData?.seasons?[index].plan,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActorView(BuildContext context, ActorBloc bloc) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kMarginMedium2),
      child: Row(
        spacing: 15,
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: cacheImage(bloc.actorData?.profilePictureUrl ?? ''),
              ),
            ),
          ),
          Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                bloc.actorData?.name ?? '',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: kTextRegular2x,
                  color: kWhiteColor,
                ),
              ),
              Text(
                bloc.actorData?.role?.role ?? '',
                style: TextStyle(fontSize: kTextSmall),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Movie & Series',
                  style: TextStyle(color: kWhiteColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
