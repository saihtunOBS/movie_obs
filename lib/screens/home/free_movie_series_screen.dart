import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/home_bloc.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/list_items/movie_list_item.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:movie_obs/widgets/movie_filter_sheet.dart';
import 'package:movie_obs/widgets/show_loading.dart';
import 'package:provider/provider.dart';

import '../../extension/page_navigator.dart';
import '../home/movie_type_screen.dart';

class FreeMovieSeriesScreen extends StatefulWidget {
  const FreeMovieSeriesScreen({super.key});
  @override
  State<FreeMovieSeriesScreen> createState() => _FreeMovieSeriesScreenState();
}

class _FreeMovieSeriesScreenState extends State<FreeMovieSeriesScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeBloc(),
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          backgroundColor: kBackgroundColor,
          surfaceTintColor: kBackgroundColor,
          foregroundColor: kWhiteColor,
          title: Text('Free Movies & Series'),
          centerTitle: false,
          actions: [
            GestureDetector(
              onTap: () {
                if (getDeviceType() == 'phone') {
                  showModalBottomSheet(
                    useRootNavigator: true,
                    context: context,
                    builder: (context) {
                      return movieFilterSheet((){});
                    },
                  );
                } else {
                  showMovieRightSideSheet(context);
                }
              },
              child: Container(
                width: 42,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  CupertinoIcons.slider_horizontal_3,
                  color: kPrimaryColor,
                  size: 19,
                ),
              ),
            ),
            kMarginMedium2.hGap,
          ],
        ),
        body: Consumer<HomeBloc>(
          builder:
              (context, bloc, child) => Padding(
                padding: const EdgeInsets.only(top: 10),
                child:
                    bloc.isLoading
                        ? LoadingView()
                        : Stack(
                          children: [
                            bloc.freeMovieLists.isNotEmpty
                                ? GridView.builder(
                                  itemCount: bloc.freeMovieLists.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount:
                                            getDeviceType() == 'phone' ? 2 : 3,
                                        mainAxisExtent: 200,
                                        mainAxisSpacing: 10,
                                        crossAxisSpacing: 10,
                                      ),
                                  padding: EdgeInsets.only(
                                    left: kMarginMedium2,
                                    right: kMarginMedium2,
                                    bottom: 20,
                                  ),
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        PageNavigator(ctx: context).nextPage(
                                          page: MovieTypeScreen(
                                            movie: bloc.freeMovieLists[index],
                                          ),
                                        );
                                      },
                                      child: movieListItem(
                                        isHomeScreen: true,
                                        movies: bloc.freeMovieLists[index],
                                        type: bloc.freeMovieLists[index].plan,
                                      ),
                                    );
                                  },
                                )
                                : Center(
                                  child: Text(
                                    'There is no movies and series to show.',
                                  ),
                                ),
                          ],
                        ),
              ),
        ),
      ),
    );
  }
}
