import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/faq_bloc.dart';
import 'package:movie_obs/data/dummy/dummy_data.dart';
import 'package:movie_obs/data/vos/faq_vo.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/widgets/show_loading.dart';
import 'package:provider/provider.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FaqBloc(),
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          backgroundColor: kBackgroundColor,
          surfaceTintColor: kBackgroundColor,
          centerTitle: false,
          title: Text('FAQ'),
        ),
        body: Consumer<FaqBloc>(
          builder:
              (context, bloc, child) =>
                  _buildBody(bloc.faqs),
        ),
      ),
    );
  }

  Widget _buildBody(List<FaqVO> data) {
    return ListView.builder(
      itemCount: imageArray.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Theme(
              data: Theme.of(
                context,
              ).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: EdgeInsets.symmetric(horizontal: 16),
                title: SizedBox(
                  height: 40,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                       'testing',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                childrenPadding: EdgeInsets.symmetric(horizontal: 16),
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('this is testing.....'),
                  ),
                ],
              ),
            ),
            Divider(thickness: 0.5),
          ],
        );
      },
    );
  }
}
