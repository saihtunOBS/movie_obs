import 'package:flutter/material.dart';
import 'package:movie_obs/extension/page_navigator.dart';
import 'package:movie_obs/list_items/noti_list_item.dart';
import 'package:movie_obs/screens/home/noti_details_screen.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: Text('Notification'),
        centerTitle: false,
        backgroundColor: kBackgroundColor,
        surfaceTintColor: kBackgroundColor,
      ),
      body: ListView.builder(
        itemCount: 3,
        padding: EdgeInsets.symmetric(
          horizontal: kMarginMedium2,
          vertical: kMarginMedium,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              PageNavigator(
                ctx: context,
              ).nextPage(page: NotificationDetailScreen());
            },
            child: notiListItem(index == 2),
          );
        },
      ),
    );
  }
}
