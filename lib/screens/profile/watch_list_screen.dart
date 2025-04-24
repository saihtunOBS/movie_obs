import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/list_items/movie_list_item.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:movie_obs/widgets/movie_filter_sheet.dart';

class WatchListScreen extends StatefulWidget {
  const WatchListScreen({super.key});

  @override
  State<WatchListScreen> createState() => _WatchListScreenState();
}

class _WatchListScreenState extends State<WatchListScreen> {
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
        title: Text('Watchlist'),
        centerTitle: false,
        actions: [
          InkWell(
            onTap: () {
              if (getDeviceType() == 'phone') {
                showModalBottomSheet(
                  useRootNavigator: true,
                  backgroundColor: kWhiteColor,
                  showDragHandle: true,
                  context: context,
                  builder: (context) {
                    return movieFilterSheet();
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
                color: kThirdColor,
                size: 19,
              ),
            ),
          ),
          kMarginMedium2.hGap,
        ],
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, 50),
          child: Padding(
            padding: EdgeInsets.only(
              left: kMarginMedium2,
              right:
                  getDeviceType() == 'phone'
                      ? kMarginMedium2
                      : MediaQuery.sizeOf(context).width / 2,
            ),
            child: SizedBox(
              height: 50,
              child: SearchBar(
                controller: _controller,
                leading: Icon(CupertinoIcons.search),
                hintText: 'Search by movie & series',
                backgroundColor: WidgetStateProperty.all(
                  Colors.grey.withValues(alpha: 0.2),
                ),
                hintStyle: WidgetStateProperty.resolveWith<TextStyle>(
                  (_) => TextStyle(color: kWhiteColor),
                ),
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
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Stack(
          children: [
            GridView.builder(
              itemCount: 10,
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
