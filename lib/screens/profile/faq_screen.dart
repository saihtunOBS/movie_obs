import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/faq_bloc.dart';
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
                  bloc.isLoading ? LoadingView() : _buildBody(bloc.faqs),
        ),
      ),
    );
  }

  Widget _buildBody(List<FaqVO> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent, // Removes default dividers
              ),
              child: ExpansionTile(
                tilePadding: EdgeInsets.symmetric(
                  horizontal: 16,
                ), // Adjust horizontal padding
                title: SizedBox(
                  height: 40, // Set custom height
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      data[index].question ?? '',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                childrenPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                ), // Optional: padding for children
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(data[index].answer ?? ''),
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
