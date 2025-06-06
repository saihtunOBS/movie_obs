import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_obs/bloc/user_bloc.dart';
import 'package:movie_obs/data/persistence/persistence_data.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/extension/page_navigator.dart';
import 'package:movie_obs/screens/bottom_nav/bottom_nav_screen.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:movie_obs/widgets/custom_button.dart';
import 'package:movie_obs/widgets/show_loading.dart';
import 'package:movie_obs/widgets/toast_service.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../network/analytics_service/analytics_service.dart';
import '../../utils/images.dart';

import 'package:movie_obs/l10n/app_localizations.dart';

class ChangeLanguageScreen extends StatefulWidget {
  const ChangeLanguageScreen({super.key, this.isProfile});
  final bool? isProfile;

  @override
  State<ChangeLanguageScreen> createState() => _ChangeLanguageScreenState();
}

class _ChangeLanguageScreenState extends State<ChangeLanguageScreen> {
  Country? selectedCountryCode;
  List<Widget> languages = [];
  int? _selectedValue;

  @override
  void initState() {
    _selectedValue =
        PersistenceData.shared.getLocale() == null
            ? 1
            : PersistenceData.shared.getLocale() == 'en'
            ? 1
            : 0;
    languages = [
      _buildLanguageRow(title: 'Myanmar'),
      _buildLanguageRow(title: 'English'),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserBloc(context: context),
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          title: Text(
            widget.isProfile == true
                ? AppLocalizations.of(context)?.language ?? ''
                : "",
          ),
          centerTitle: false,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal:
                getDeviceType() == 'phone'
                    ? kMarginMedium2
                    : MediaQuery.of(context).size.width * 0.15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: kMarginMedium,
            children: [
              Visibility(
                visible: widget.isProfile == true ? false : true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'LANGUAGE',
                      style: TextStyle(
                        letterSpacing: 10.0,
                        fontSize: kTextRegular32,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)?.preferLanguage ?? '',
                      style: TextStyle(fontSize: kTextRegular2x),
                    ),
                    20.vGap,
                  ],
                ),
              ),

              //
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.2),
                  borderRadius: BorderRadiusDirectional.circular(10),
                ),
                child: Column(
                  children:
                      languages.asMap().entries.map((entry) {
                        return Localizations.override(
                          context: context,
                          locale: Locale('en'),
                          child: RadioListTile(
                            hoverColor: Colors.transparent,
                            tileColor: Colors.transparent,
                            selectedTileColor: Colors.transparent,
                            value: entry.key,
                            visualDensity: VisualDensity(
                              horizontal: -4,
                              vertical: -2,
                            ),
                            groupValue: _selectedValue,
                            title: entry.value,
                            onChanged: (value) {
                              setState(() {
                                switch (value) {
                                  case 1:
                                    PersistenceData.shared.saveLocale('en');
                                    languageStreamController.sink.add('en');
                                  case 0:
                                    PersistenceData.shared.saveLocale('my');
                                    languageStreamController.sink.add('my');
                                    break;
                                  default:
                                }
                                _selectedValue = value;
                              });
                            },
                          ),
                        );
                      }).toList(),
                ),
              ),
              20.vGap,
              //button
              widget.isProfile == true
                  ? SizedBox.shrink()
                  : Consumer<UserBloc>(
                    builder:
                        (context, bloc, child) =>
                            bloc.isLoading
                                ? LoadingView()
                                : AnimatedContainer(
                                  duration: Duration(milliseconds: 1000),
                                  child: SizedBox(
                                    width: bloc.isLoading ? 0 : null,
                                    child: Column(
                                      spacing: 2,
                                      children: [
                                        customButton(
                                          onPress: () {
                                            bloc
                                                .updateUser(
                                                  userDataListener.value.name ??
                                                      '',
                                                  userDataListener
                                                          .value
                                                          .email ??
                                                      '',
                                                )
                                                .then((value) {
                                                  tab.value = true;
                                                  AnalyticsService().setUserId(
                                                    value.id ?? '',
                                                  );
                                                  PageNavigator(
                                                    ctx: context,
                                                  ).nextPageOnly(
                                                    page: BottomNavScreen(),
                                                  );
                                                })
                                                .catchError((e) {
                                                  bloc.hideLoading();
                                                  ToastService.warningToast(
                                                    e.toString(),
                                                  );
                                                });
                                          },
                                          context: context,
                                          backgroundColor: kSecondaryColor,
                                          title:
                                              AppLocalizations.of(
                                                context,
                                              )?.confirm ??
                                              '',
                                          textColor: kWhiteColor,
                                        ),
                                        Image.asset(kShadowImage),
                                      ],
                                    ),
                                  ),
                                ),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageRow({required String title}) {
    return Row(
      spacing: kMargin12,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
