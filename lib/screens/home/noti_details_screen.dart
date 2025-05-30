import 'package:flutter/material.dart';
import 'package:movie_obs/data/vos/notification_vo.dart';
import 'package:movie_obs/l10n/app_localizations.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/date_formatter.dart';
import 'package:movie_obs/widgets/cache_image.dart';

import '../../utils/dimens.dart';

class NotificationDetailScreen extends StatelessWidget {
  const NotificationDetailScreen({super.key, required this.notiData});
  final NotificationVo notiData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.back ?? ''),
        centerTitle: false,
        backgroundColor: kBackgroundColor,
        surfaceTintColor: kBackgroundColor,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: kMarginMedium2,
        vertical: kMarginMedium2,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                height: 200,
                width: double.infinity,
                child: cacheImage(notiData.imageUrl),
              ),
            ),
            Text(
              DateFormatter.formatDate(notiData.createdAt ?? DateTime.now()),
            ),
            Text(
              notiData.title ?? '',
              style: TextStyle(
                fontSize: kTextRegular2x,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(notiData.body ?? '', style: TextStyle()),
          ],
        ),
      ),
    );
  }
}
