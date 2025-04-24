import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/extension/page_navigator.dart';
import 'package:movie_obs/screens/bottom_nav/bottom_nav_screen.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:movie_obs/widgets/custom_button.dart';

import '../../utils/images.dart';

class ChangeLanguageScreen extends StatefulWidget {
  const ChangeLanguageScreen({super.key});

  @override
  State<ChangeLanguageScreen> createState() => _ChangeLanguageScreenState();
}

class _ChangeLanguageScreenState extends State<ChangeLanguageScreen> {
  Country? selectedCountryCode;
  List<Widget> languages = [];
  int? _selectedValue;

  @override
  void initState() {
    languages = [
      _buildLanguageRow(title: 'Myanmar'),
      _buildLanguageRow(title: 'English'),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      resizeToAvoidBottomInset: true,
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
            Text(
              'LANGUAGE',
              style: TextStyle(
                letterSpacing: 10.0,
                fontSize: kTextRegular32,
                fontWeight: FontWeight.bold,
                color: kThirdColor
              ),
            ),
            Text(
              'Please select your prefer language to continue.',
              style: TextStyle(fontSize: kTextRegular2x),
            ),
            20.vGap,

            //
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.2),
                borderRadius: BorderRadiusDirectional.circular(10),
              ),
              child: Column(
                children:
                    languages.asMap().entries.map((entry) {
                      return RadioListTile(
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
                              case 0:
                              // PersistenceData.shared.saveLocale('en');
                              // languageStreamController.sink.add('en');
                              case 1:
                                // PersistenceData.shared.saveLocale('my');
                                // languageStreamController.sink.add('my');
                                break;
                              default:
                            }
                            _selectedValue = value;
                          });
                        },
                      );
                    }).toList(),
              ),
            ),
            20.vGap,
            //button
            Column(
              spacing: 2,
              children: [
                customButton(
                  onPress: () {
                    PageNavigator(
                      ctx: context,
                    ).nextPageOnly(page: BottomNavScreen());
                  },
                  context: context,
                  backgroundColor: kSecondaryColor,
                  title: 'Send OTP',
                  textColor: kWhiteColor,
                ),
                Image.asset(kShadowImage),
              ],
            ),
          ],
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
