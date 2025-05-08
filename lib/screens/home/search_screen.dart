import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/search_bloc.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/extension/page_navigator.dart';
import 'package:movie_obs/list_items/genre_list_item.dart';
import 'package:movie_obs/screens/home/filter_screen.dart';
import 'package:movie_obs/screens/home/movie_detail_screen.dart';
import 'package:movie_obs/screens/series/series_detail_screen.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:movie_obs/utils/images.dart';
import 'package:provider/provider.dart';
import 'package:substring_highlight/substring_highlight.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SearchBloc(),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(left: kMarginMedium2),
            child: Image.asset(kAppIcon, width: 40, height: 40),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: kBlackColor,
          surfaceTintColor: kBlackColor,
          centerTitle: false,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: kMarginMedium2,
            vertical: kMarginMedium2 - 5,
          ),
          child: Consumer<SearchBloc>(
            builder:
                (context, bloc, child) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //search widget
                    _buildSearchView(context, bloc),
                    Expanded(child: _buildGenre(bloc)),
                  ],
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchView(BuildContext context, SearchBloc bloc) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(CupertinoIcons.arrow_left, size: 20),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.withValues(alpha: 0.2),
            ),
            child: Row(
              spacing: 10,
              children: [
                Icon(CupertinoIcons.search),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onChanged: (value) => bloc.onSearchChanged(value),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search Movies & Series',
                    ),
                  ),
                ),
                Visibility(
                  visible: _controller.text.isNotEmpty,
                  child: GestureDetector(
                    onTap: () {
                      _controller.clear();
                      bloc.clearFilter();
                    },
                    child: Icon(CupertinoIcons.clear_circled),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenre(SearchBloc bloc) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.vGap,
            Text(
              'Genres',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            10.vGap,
            Expanded(
              child: GridView.builder(
                itemCount: bloc.genreLists.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 60,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      PageNavigator(ctx: context).nextPage(
                        page: FilterScreen(
                          id: bloc.genreLists[index].id ?? '',
                          title: bloc.genreLists[index].name ?? '',
                        ),
                      );
                    },
                    child: genreListItem(bloc.genreLists[index]),
                  );
                },
              ),
            ),
          ],
        ),
        //filter
        bloc.filteredSuggestions.isEmpty
            ? SizedBox.shrink()
            : Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.black38,
              ),
            ),
        bloc.filteredSuggestions.isEmpty
            ? SizedBox()
            : Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.symmetric(vertical: kMarginMedium),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(kMargin10),
                color: kWhiteColor,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    bloc.filteredSuggestions.map((value) {
                      return GestureDetector(
                        onTap: () {
                          value.type == 'movie'
                              ? PageNavigator(
                                ctx: context,
                              ).nextPage(page: MovieDetailScreen(movie: value))
                              : PageNavigator(ctx: context).nextPage(
                                page: SeriesDetailScreen(series: value),
                              );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: kMarginMedium,
                            vertical: kMarginMedium,
                          ),
                          child: SubstringHighlight(
                            text: value.name ?? '',
                            term: _controller.text,
                            textStyleHighlight: TextStyle(
                              color: kSecondaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
      ],
    );
  }
}
