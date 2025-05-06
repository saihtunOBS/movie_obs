import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/movie_bloc.dart';
import 'package:movie_obs/data/vos/filter_vo.dart';
import 'package:movie_obs/data/vos/genre_vo.dart';
import 'package:movie_obs/data/vos/movie_vo.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:movie_obs/utils/images.dart';
import 'package:provider/provider.dart';

final ValueNotifier<String> selectedType = ValueNotifier('');
final ValueNotifier<int> selectedGenre = ValueNotifier(-1);
String genre = '';

Widget movieFilterSheet(
  VoidCallback onFilter, {
  FilterVo Function(FilterVo data)? filter,
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
                        onFilter();
                        if (filter != null) {
                          filter(FilterVo(selectedType.value, genre));
                        }
                        selectedType.value = '';
                        selectedGenre.value = -1;
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
                        selectedType.value = '';
                        selectedGenre.value = -1;
                      },
                      child: Chip(
                        label: Text(
                          'Clear',
                          style: TextStyle(color: kWhiteColor),
                        ),
                        backgroundColor: Colors.transparent,
                        side: BorderSide(color: kWhiteColor, width: 0.8),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      spacing: 5,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //movie session
                        buildMovieSession(),
                        Divider(thickness: 0.5),

                        //type session
                        buildTypeSession(categoryData: bloc.categoryLists),
                        Divider(thickness: 0.5),

                        //genre session
                        buildGenreSession(genreData: bloc.genreLists),

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

Widget buildMovieSession() {
  return Column(
    spacing: 5,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        spacing: kMarginMedium,
        children: [
          Image.asset(
            kMovieSeriesIcon,
            width: 28,
            height: 28,
            color: kWhiteColor,
          ),
          Text(
            'Movies',
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
          itemCount: 1,
          itemBuilder: (context, index) {
            return Chip(
              label: Text('Myanmar'),
              backgroundColor: Colors.grey.withValues(alpha: 0.2),
            );
          },
        ),
      ),
    ],
  );
}

Widget buildMovieAndSeriesSession() {
  return Column(
    spacing: 5,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        spacing: kMarginMedium,
        children: [
          Image.asset(
            kMovieSeriesIcon,
            width: 28,
            height: 28,
            color: kWhiteColor,
          ),
          Text(
            'Movies & Series',
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
          itemCount: 1,
          itemBuilder: (context, index) {
            return Chip(
              label: Text('Myanmar'),
              backgroundColor: Colors.grey.withValues(alpha: 0.2),
            );
          },
        ),
      ),
    ],
  );
}

List<String> typeArray = ['Free', 'Paid', 'Pay per view'];
Widget buildTypeSession({List<CategoryVO>? categoryData}) {
  return Column(
    spacing: 5,
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Row(
        spacing: kMarginMedium,
        children: [
          Image.asset(kTypeIcon, width: 32, height: 32, color: kWhiteColor),
          Text(
            'Types',
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
          itemCount: typeArray.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                selectedType.value = typeArray[index];
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 7),
                child: ValueListenableBuilder(
                  valueListenable: selectedType,
                  builder:
                      (context, value, child) => Chip(
                        label: Text(typeArray[index]),
                        backgroundColor:
                            value == typeArray[index]
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

Widget buildGenreSession({List<GenreVO>? genreData}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: 5,
    children: [
      Row(
        spacing: kMarginMedium,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(kGenreIcon, width: 32, height: 32, color: kWhiteColor),
          Text(
            'Genre',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: kTextRegular2x,
            ),
          ),
        ],
      ),
      Wrap(
        spacing: kMarginMedium,
        runSpacing: kMarginMedium - 10,
        alignment: WrapAlignment.start,
        children:
            genreData?.asMap().entries.map((value) {
              return GestureDetector(
                onTap: () {
                  genre = value.value.id ?? '';
                  selectedGenre.value = value.key;
                },
                child: ValueListenableBuilder(
                  valueListenable: selectedGenre,
                  builder:
                      (context, index, child) => Chip(
                        label: Text(genreData[value.key].name ?? ''),
                        backgroundColor:
                            index == value.key
                                ? kSecondaryColor
                                : Colors.grey.withValues(alpha: 0.2),
                      ),
                ),
              );
            }).toList() ??
            [],
      ),
    ],
  );
}

void showMovieRightSideSheet(BuildContext context) {
  showGeneralDialog(
    useRootNavigator: true,
    context: context,
    barrierDismissible: true,
    barrierLabel: "RightSideSheet",
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, anim1, anim2) {
      return Align(
        alignment: Alignment.centerRight,
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: EdgeInsets.only(top: 60),
            decoration: BoxDecoration(
              color: kWhiteColor,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(30)),
            ),
            width: MediaQuery.of(context).size.width / 2,
            height: double.infinity,
            padding: const EdgeInsets.all(20),
            child: movieFilterSheet(() {}),
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curvedValue = Curves.easeInOut.transform(animation.value) - 1.0;
      return Transform.translate(
        offset: Offset(curvedValue * -300, 0),
        child: Opacity(opacity: animation.value, child: child),
      );
    },
  );
}
