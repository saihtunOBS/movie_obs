import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/actor_bloc.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:movie_obs/widgets/cache_image.dart';
import 'package:movie_obs/widgets/show_loading.dart';
import 'package:provider/provider.dart';

import '../../list_items/movie_list_item.dart';

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
          title: Text('Back'),
          centerTitle: false,
        ),
        body: Consumer<ActorBloc>(
          builder:
              (context, bloc, child) =>
                  bloc.isLoading
                      ? LoadingView()
                      : Column(
                        spacing: 15,
                        children: [
                          _buildActorView(context, bloc),
                          bloc.actorData?.movieCounts == 0
                              ? Center(
                                child: Text('There is no movies to show.'),
                              )
                              : _buildListView(context, bloc),
                          10.vGap,
                        ],
                      ),
        ),
      ),
    );
  }

  Widget _buildListView(BuildContext context, ActorBloc bloc) {
    return Expanded(
      child: GridView.builder(
        itemCount: bloc.actorData?.movies?.length,
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
          return movieListItem(
            isHomeScreen: true,
            movies: bloc.actorData?.movies?[index],
          );
        },
      ),
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
