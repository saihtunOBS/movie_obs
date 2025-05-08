import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/movie_bloc.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:movie_obs/utils/images.dart';
import 'package:movie_obs/widgets/movie_filter_sheet.dart';
import 'package:provider/provider.dart';

import '../data/vos/filter_vo.dart';

final ValueNotifier<String> _selectedCategory = ValueNotifier('');

Widget searchFilterSheet(
  VoidCallback onFilter, {
  FilterVo Function(FilterVo data)? filter,
  bool? isWatchList,
}) {
  return ChangeNotifierProvider(
    create: (context) => MovieBloc(),
    child: Consumer<MovieBloc>(
      builder:
          (context, bloc, child) => Container(
            margin: EdgeInsets.symmetric(
              horizontal: kMarginMedium2,
              vertical: kMarginMedium2,
            ),
            child: Column(
              children: [
                Container(
                  width: 30,
                  height: 3,
                  decoration: BoxDecoration(
                    color: kWhiteColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                15.vGap,
                Expanded(
                  child: SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    child: Column(
                      spacing: 5,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //title
                        Row(
                          children: [
                            Text(
                              'FILTER',
                              style: TextStyle(
                                fontSize: kTextRegular22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                if (filter != null) {
                                  filter(
                                    FilterVo(
                                      selectedType.value,
                                      _selectedCategory.value,
                                      genre,
                                    ),
                                  );
                                }
                                selectedType.value = '';
                                selectedGenre.value = -1;
                                _selectedCategory.value = '';
                                genre = '';
                                Navigator.pop(context);
                              },
                              child: Chip(
                                label: Text(
                                  'Filter',
                                  style: TextStyle(color: kWhiteColor),
                                ),
                                backgroundColor: kSecondaryColor,
                              ),
                            ),
                            10.hGap,
                            GestureDetector(
                              onTap: () {
                                _selectedCategory.value = '';
                                selectedType.value = '';
                                selectedGenre.value = -1;
                                genre = '';
                              },
                              child: Chip(
                                label: Text(
                                  'Clear',
                                  style: TextStyle(color: kWhiteColor),
                                ),
                                backgroundColor: Colors.transparent,
                                side: BorderSide(
                                  color: kWhiteColor,
                                  width: 0.8,
                                ),
                              ),
                            ),
                          ],
                        ),

                        //movie session
                        _buildCategorySession(),
                        Divider(thickness: 0.5),

                        buildMovieAndSeriesSession(),
                        Divider(thickness: 0.5),

                        //type session
                        buildTypeSession(),
                        isWatchList == true
                            ? Divider(thickness: 0.5)
                            : SizedBox.shrink(),

                        isWatchList == true
                            ? buildGenreSession(genreData: bloc.genreLists)
                            : SizedBox.shrink(),

                        20.vGap,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
    ),
  );
}

List<String> categoryArray = ['Both', 'Movie', 'Series'];

Widget _buildCategorySession() {
  return Column(
    spacing: 5,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        spacing: kMarginMedium,
        children: [
          Image.asset(kCategoryIcon, width: 28, height: 28, color: kWhiteColor),
          Text(
            'Category',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: kTextRegular2x,
            ),
          ),
        ],
      ),
      SizedBox(
        height: 50,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: categoryArray.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                _selectedCategory.value = categoryArray[index];
              },
              child: ValueListenableBuilder(
                valueListenable: _selectedCategory,
                builder:
                    (context, value, child) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Chip(
                        label: Text(categoryArray[index]),
                        backgroundColor:
                            value == categoryArray[index]
                                ? kSecondaryColor
                                : Colors.grey.withValues(alpha: 0.2),
                      ),
                    ),
              ),
            );
          },
        ),
      ),
    ],
  );
}
