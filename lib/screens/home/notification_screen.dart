import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/notification_bloc.dart';
import 'package:movie_obs/data/persistence/persistence_data.dart';
import 'package:movie_obs/extension/page_navigator.dart';
import 'package:movie_obs/l10n/app_localizations.dart';
import 'package:movie_obs/list_items/noti_list_item.dart';
import 'package:movie_obs/screens/auth/login_screen.dart';
import 'package:movie_obs/screens/home/noti_details_screen.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:movie_obs/widgets/empty_view.dart';
import 'package:movie_obs/widgets/show_loading.dart';
import 'package:movie_obs/widgets/toast_service.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationBloc>().updateToken();
      context.read<NotificationBloc>().getNotifications().catchError((e) {
        PersistenceData.shared.clearToken();
        PageNavigator(ctx: context).nextPageOnly(page: LoginScreen());
        ToastService.warningToast(e.toString());
      });
    });
  }

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
                    ? RefreshIndicator(
                      onRefresh: () async {
                        bloc.getNotifications();
                      },
                      child: ListView.builder(
                        itemCount: bloc.notiLists.length,
                        padding: EdgeInsets.only(
                          left: kMarginMedium2,
                          right: kMarginMedium2,
                          bottom: 20,
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
                      ),
                    )
                    : EmptyView(
                      reload: () {
                        bloc.getNotifications();
                      },
                      title: AppLocalizations.of(context)?.noNotification ?? '',
                    ),
      ),
    );
  }
}
