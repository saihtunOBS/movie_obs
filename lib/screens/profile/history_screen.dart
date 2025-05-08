// import 'package:flutter/material.dart';
// import 'package:movie_obs/bloc/history_bloc.dart';
// import 'package:movie_obs/data/vos/watchlist_history_vo.dart';
// import 'package:movie_obs/extension/extension.dart';
// import 'package:movie_obs/list_items/movie_list_item.dart';
// import 'package:movie_obs/utils/colors.dart';
// import 'package:movie_obs/utils/date_formatter.dart';
// import 'package:movie_obs/utils/dimens.dart';
// import 'package:provider/provider.dart';

// import '../../extension/page_navigator.dart';
// import '../../widgets/empty_view.dart';
// import '../../widgets/show_loading.dart';
// import '../home/movie_detail_screen.dart';
// import '../series/series_detail_screen.dart';

// class HistoryScreen extends StatefulWidget {
//   const HistoryScreen({super.key});

//   @override
//   State<HistoryScreen> createState() => _HistoryScreenState();
// }

// class _HistoryScreenState extends State<HistoryScreen> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => HistoryBloc(),
//       child: Scaffold(
//         backgroundColor: kBackgroundColor,
//         appBar: AppBar(
//           backgroundColor: kBackgroundColor,
//           surfaceTintColor: kBackgroundColor,
//           title: Text('Your History'),
//           centerTitle: false,
//         ),
//         body: Consumer<HistoryBloc>(
//           builder:
//               (context, bloc, child) => RefreshIndicator(
//                 onRefresh: () async {
//                   bloc.getHistory();
//                 },
//                 child:
//                     bloc.isLoading
//                         ? LoadingView()
//                         : bloc.historyData?.data?.isNotEmpty ?? true
//                         ? Padding(
//                           padding: const EdgeInsets.only(),
//                           child: ListView.builder(
//                             itemCount: bloc.historyData?.data?.length ?? 0,
//                             itemBuilder: (context, index) {
//                               return HistoryListItem(
//                                 dataList: bloc.historyData?.data ?? [],
//                                 index: index,
//                               );
//                             },
//                           ),
//                         )
//                         : EmptyView(
//                           title: 'There is no history to show.',
//                           reload: () {
//                             bloc.getHistory();
//                           },
//                         ),
//               ),
//         ),
//       ),
//     );
//   }
// }

// class HistoryListItem extends StatelessWidget {
//   const HistoryListItem({
//     super.key,
//     required this.index,
//     required this.dataList,
//   });
//   final int index;
//   final WatchlistHistoryVo dataList;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text(DateFormatter.formatDate(data.createdAt ?? DateTime.now())),
//         GridView.builder(
//           itemCount: dataList.length,
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: getDeviceType() == 'phone' ? 2 : 3,
//             mainAxisExtent: 230,
//             mainAxisSpacing: 10,
//             crossAxisSpacing: 10,
//           ),
//           physics: NeverScrollableScrollPhysics(),
//           shrinkWrap: true,
//           padding: EdgeInsets.symmetric(
//             horizontal: kMarginMedium2,
//             vertical: kMarginMedium2 - 5,
//           ),
//           itemBuilder: (context, index) {
//             return GestureDetector(
//               onTap: () {
//                 dataList[index].type == 'MOVIE'
//                     ? PageNavigator(ctx: context).nextPage(
//                       page: MovieDetailScreen(movie: dataList[index].reference),
//                     )
//                     : PageNavigator(ctx: context).nextPage(
//                       page: SeriesDetailScreen(
//                         series: dataList[index].reference,
//                       ),
//                     );
//               },
//               child: movieListItem(
//                 movies: dataList[index].reference,
//                 type: dataList[index].type ?? '',
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }
// }
