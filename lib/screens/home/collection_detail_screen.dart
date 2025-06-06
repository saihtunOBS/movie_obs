import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/home_bloc.dart';
import 'package:movie_obs/data/vos/collection_vo.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/list_items/movie_list_item.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:movie_obs/widgets/empty_view.dart';
import 'package:movie_obs/widgets/shimmer_loading.dart';
import 'package:movie_obs/widgets/show_loading.dart';
import 'package:provider/provider.dart';

import '../../extension/page_navigator.dart';
import '../series/series_detail_screen.dart';
import 'movie_detail_screen.dart';

class CollectionDetailScreen extends StatefulWidget {
  const CollectionDetailScreen({super.key, required this.collectionData});
  final CollectionVO collectionData;
  @override
  State<CollectionDetailScreen> createState() => _CollectionDetailScreenState();
}

class _CollectionDetailScreenState extends State<CollectionDetailScreen> {
  final scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:
          (context) => HomeBloc(
            isCollectionDetail: true,
            collectionId: widget.collectionData.id,
          ),
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          backgroundColor: kBackgroundColor,
          surfaceTintColor: kBackgroundColor,
          foregroundColor: kWhiteColor,
          title: Text(widget.collectionData.name ?? ''),
          centerTitle: false,
        ),
        body: Consumer<HomeBloc>(
          builder:
              (context, bloc, child) => RefreshIndicator(
                onRefresh: () async {
                  bloc.getFreeMovieAndSeries();
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child:
                      bloc.isLoading
                          ? shimmerLoading(isVertical: true)
                          : Stack(
                            children: [
                              bloc.freeMovieLists.isNotEmpty
                                  ? GridView.builder(
                                    physics: AlwaysScrollableScrollPhysics(),
                                    itemCount:
                                        bloc.collectionDetail?.items?.length ??
                                        0,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount:
                                              getDeviceType() == 'phone'
                                                  ? 2
                                                  : 3,
                                          mainAxisExtent: 230,
                                          mainAxisSpacing: 10,
                                          crossAxisSpacing: 10,
                                        ),
                                    padding: EdgeInsets.only(
                                      left: kMarginMedium2,
                                      right: kMarginMedium2,
                                      bottom: 60,
                                    ),
                                    controller:
                                        scrollController..addListener(() {
                                          if (scrollController
                                                  .position
                                                  .pixels ==
                                              scrollController
                                                  .position
                                                  .maxScrollExtent) {}
                                        }),
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          if (bloc
                                                  .collectionDetail
                                                  ?.items?[index]
                                                  .referenceModel ==
                                              'Movie') {
                                            PageNavigator(
                                              ctx: context,
                                            ).nextPage(
                                              page: MovieDetailScreen(
                                                movie:
                                                    bloc
                                                        .collectionDetail
                                                        ?.items?[index]
                                                        .reference,
                                              ),
                                            );
                                          } else {
                                            PageNavigator(
                                              ctx: context,
                                            ).nextPage(
                                              page: SeriesDetailScreen(
                                                series:
                                                    bloc
                                                        .collectionDetail
                                                        ?.items?[index]
                                                        .reference,
                                              ),
                                            );
                                          }
                                        },
                                        child: movieListItem(
                                          isHomeScreen: true,
                                          movies:
                                              bloc
                                                  .collectionDetail
                                                  ?.items?[index]
                                                  .reference,
                                          type:
                                              bloc
                                                  .collectionDetail
                                                  ?.items?[index]
                                                  .referenceModel,
                                        ),
                                      );
                                    },
                                  )
                                  : EmptyView(
                                    reload: () {
                                      bloc.getFreeMovieAndSeries();
                                    },
                                    title: 'There is no free movies & series',
                                  ),
                              //load more loading
                              Positioned(
                                bottom: 30,
                                left: 0,
                                right: 0,
                                child:
                                    bloc.isLoadMore
                                        ? Center(
                                          child: SizedBox(
                                            width: 25,
                                            height: 25,
                                            child: LoadingView(),
                                          ),
                                        )
                                        : SizedBox.shrink(),
                              ),
                            ],
                          ),
                ),
              ),
        ),
      ),
    );
  }
}
