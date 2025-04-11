import 'package:flutter/material.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:movie_obs/utils/images.dart';

import '../../list_items/movie_list_item.dart';

class ActorViewScreen extends StatelessWidget {
  const ActorViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        surfaceTintColor: kBackgroundColor,
        title: Text('Back'),
        centerTitle: false,
      ),
      body: Column(
        spacing: 15,
        children: [_buildActorView(context), _buildListView(context), 10.vGap],
      ),
    );
  }

  Widget _buildListView(BuildContext context) {
    return Expanded(
      child: GridView.builder(
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
    );
  }

  Widget _buildActorView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kMarginMedium2),
      child: Row(
        spacing: 15,
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: kBlackColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(child: Image.asset(kUserIcon, width: 30, height: 30)),
          ),
          Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Actor name', style: TextStyle(fontWeight: FontWeight.bold,fontSize: kTextRegular2x)),
              Text('Actor', style: TextStyle(fontSize: kTextSmall)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                  color: kBlackColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Movie & Series',
                  style: TextStyle(color: kWhiteColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
