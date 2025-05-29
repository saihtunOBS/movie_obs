import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/notification_bloc.dart';
import 'package:movie_obs/extension/page_navigator.dart';
import 'package:movie_obs/l10n/app_localizations.dart';
import 'package:movie_obs/list_items/noti_list_item.dart';
import 'package:movie_obs/screens/home/noti_details_screen.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:movie_obs/widgets/show_loading.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.notification ?? ''),
        centerTitle: false,
        backgroundColor: kBackgroundColor,
        surfaceTintColor: kBackgroundColor,
      ),
      body: Consumer<NotificationBloc>(
        builder:
            (context, bloc, child) =>
                bloc.isLoading
                    ? LoadingView()
                    : bloc.notiLists.isNotEmpty
                    ? ListView.builder(
                      itemCount: bloc.notiLists.length,
                      padding: EdgeInsets.symmetric(
                        horizontal: kMarginMedium2,
                        vertical: kMarginMedium,
                      ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            PageNavigator(ctx: context).nextPage(
                              page: NotificationDetailScreen(
                                notiData: bloc.notiLists[index],
                              ),
                            );
                          },
                          child: notiListItem(
                            index == bloc.notiLists.length - 1,
                            bloc.notiLists[index],
                          ),
                        );
                      },
                    )
                    : Text(
                      AppLocalizations.of(context)?.noNotification ?? '',
                      style: TextStyle(color: kWhiteColor),
                    ),
      ),
    );
  }
}
