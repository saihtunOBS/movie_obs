import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/list_items/movie_list_item.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:movie_obs/widgets/movie_filter_sheet.dart';

class MovieScreen extends StatefulWidget {
  const MovieScreen({super.key});

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> suggestions = [
    'Apple',
    'Banana',
    'Cherry',
    'Date',
    'Grape',
    'Mango',
    'Orange',
  ];
  List<String> filteredSuggestions = [];

  void _onSearchChanged(String value) {
    setState(() {
      filteredSuggestions =
          suggestions
              .where((item) => item.toLowerCase().contains(value.toLowerCase()))
              .toList();
    });
  }

  @override
  void initState() {
    filteredSuggestions.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        surfaceTintColor: kBackgroundColor,
        title: Text('Tuu Tu\' Movies'),
        centerTitle: false,
        actions: [
          InkWell(
            onTap: () {
              showModalBottomSheet(
                useRootNavigator: true,
                backgroundColor: kWhiteColor,
                showDragHandle: true,
                context: context,
                builder: (context) {
                  return movieFilterSheet();
                },
              );
            },
            child: Container(
              width: 43,
              height: 33,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                CupertinoIcons.line_horizontal_3_decrease,
                color: kWhiteColor,
              ),
            ),
          ),
          kMarginMedium2.hGap,
        ],
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, 65),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kMarginMedium2),
            child: SearchBar(
              controller: _controller,
              leading: Icon(CupertinoIcons.search),
              hintText: 'Search by movie title',
              backgroundColor: WidgetStateProperty.all(Colors.white),
              onChanged: _onSearchChanged,
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16), // your border radius
                ),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Stack(
          children: [
            GridView.builder(
              itemCount: 10,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 230,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: kMarginMedium2,
                vertical: kMarginMedium2 - 5,
              ),
              itemBuilder: (context, index) {
                return movieListItem(isMovieScreen: true);
              },
            ),
            filteredSuggestions.isEmpty
                ? SizedBox.shrink()
                : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.black12,
                  ),
                ),
            filteredSuggestions.isEmpty
                ? SizedBox()
                : Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: kMarginMedium2),
                  padding: EdgeInsets.symmetric(vertical: kMarginMedium),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(kMargin10),
                    color: kWhiteColor,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        filteredSuggestions.map((value) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: kMarginMedium,
                              vertical: kMarginMedium,
                            ),
                            child: Text(
                              value,
                              style: TextStyle(color: kBlackColor),
                            ),
                          );
                        }).toList(),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
