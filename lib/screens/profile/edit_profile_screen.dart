import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/user_bloc.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/widgets/custom_textfield.dart';
import 'package:provider/provider.dart';

import '../../utils/colors.dart';
import '../../utils/dimens.dart';
import '../../utils/images.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserBloc(),
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAppBar(context),
            30.vGap,
            _buildUserInfo('Username', 'Username', context),
            10.vGap,
            _buildUserInfo('Phone Number', '+95 0976666677', context),
            10.vGap,
            _buildUserInfo(
              'Email Address',
              'user@gmail.com',
              context,
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 55, left: 10, right: 10),
          child: Row(
            spacing: 10,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(kMarginMedium + 8),
                  ),
                  child: Center(
                    child: Icon(
                      CupertinoIcons.arrow_left,
                      color: kWhiteColor,
                      size: getDeviceType() == 'phone' ? 20 : 27,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        Consumer<UserBloc>(
          builder:
              (context, bloc, child) => Padding(
                padding: const EdgeInsets.only(top: 70),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Stack(
                      children: [
                        Container(
                          height: 74,
                          width: 74,
                          decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.3),
                          ),
                          child:
                              bloc.imgFile == null
                                  ? Image.asset(kProfileCoverIcon)
                                  : Image.file(bloc.imgFile!, fit: BoxFit.fill),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              _showCupertinoActionSheet(context, bloc);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 3),
                              color: Colors.black54,
                              child: Icon(
                                CupertinoIcons.camera_fill,
                                color: kWhiteColor,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        ),
        Positioned(
          top: 65,
          right: kMarginMedium2,
          child: Row(
            spacing: 10,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: kSecondaryColor,
                    borderRadius: BorderRadius.circular(kMarginMedium + 8),
                  ),
                  child: Center(
                    child: Text('Save', style: TextStyle(color: kWhiteColor)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _showCupertinoActionSheet(BuildContext context, UserBloc bloc) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text(
            'Choose Option',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: kTextRegular18,
            ),
          ),
          message: Text(
            'Select one of the options below.',
            style: TextStyle(fontSize: kTextRegular2x),
          ),
          actions: <CupertinoActionSheetAction>[
            CupertinoActionSheetAction(
              onPressed: () {
                bloc.selectImage(0);
                Navigator.pop(context);
              },
              child: Text(
                'Camera',
                style: TextStyle(
                  fontSize: kTextRegular2x,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                bloc.selectImage(1);
                Navigator.pop(context);
              },
              child: Text(
                'Gallery',
                style: TextStyle(
                  fontSize: kTextRegular2x,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildUserInfo(
    String title,
    String name,
    BuildContext context, {
    bool? isLast,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal:
            getDeviceType() == 'phone'
                ? kMarginMedium2
                : MediaQuery.of(context).size.width * 0.15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: kTextRegular2x,
            ),
          ),
          5.vGap,
          CustomTextfield(hint: title),
          10.vGap,
        ],
      ),
    );
  }
}
