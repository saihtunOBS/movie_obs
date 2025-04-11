import 'package:flutter/material.dart';
import 'package:movie_obs/data/dummy/dummy_data.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/widgets/cache_image.dart';

import '../../utils/dimens.dart';

class NotificationDetailScreen extends StatelessWidget {
  const NotificationDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: Text('Back'),
        centerTitle: false,
        backgroundColor: kBackgroundColor,
        surfaceTintColor: kBackgroundColor,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kMarginMedium2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: 200,
              width: double.infinity,
              child: cacheImage(imageArray.last),
            ),
          ),
          Text('12 Jan, 2025'),
          Text(
            'Your account have been created successfully',
            style: TextStyle(
              fontSize: kTextRegular2x,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            'We send notifications for new movie releases, personalized recommendations, special promotions, and account-related updates.',
            style: TextStyle(),
          ),
        ],
      ),
    );
  }
}
