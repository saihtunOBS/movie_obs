import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:movie_obs/bloc/term_privacy_bloc.dart';
import 'package:movie_obs/l10n/app_localizations.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/widgets/show_loading.dart';
import 'package:provider/provider.dart';

import '../../utils/dimens.dart';

class TermAndConditionScreen extends StatelessWidget {
  const TermAndConditionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TermPrivacyBloc(),
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          surfaceTintColor: kBackgroundColor,
          backgroundColor: kBackgroundColor,
          title: Text(AppLocalizations.of(context)?.term ?? ''),
        ),
        body: Consumer<TermPrivacyBloc>(
          builder:
              (context, bloc, child) =>
                  bloc.isLoading
                      ? LoadingView()
                      : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: kMarginMedium2,),
                        child: HtmlWidget(bloc.termPrivacyResponse?.content ?? ''),
                      ),
        ),
      ),
    );
  }
}
