import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/user_bloc.dart';
import 'package:movie_obs/data/vos/user_vo.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/utils/validator.dart';
import 'package:movie_obs/widgets/cache_image.dart';
import 'package:movie_obs/widgets/custom_textfield.dart';
import 'package:movie_obs/widgets/show_loading.dart';
import 'package:movie_obs/widgets/toast_service.dart';
import 'package:provider/provider.dart';

import '../../utils/colors.dart';
import '../../utils/dimens.dart';
import '../../utils/images.dart';
import 'package:movie_obs/l10n/app_localizations.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.userData});
  final UserVO userData;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

final _nameController = TextEditingController();
final _phoneController = TextEditingController();
final _emailController = TextEditingController();
final _formKey = GlobalKey<FormState>();

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  void initState() {
    _nameController.text = widget.userData.name ?? '';
    _phoneController.text = widget.userData.phone ?? '';
    _emailController.text = widget.userData.email ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserBloc(context: context),
      child: Scaffold(
        backgroundColor: kBackgroundColor,

        body: Consumer<UserBloc>(
          builder:
              (context, bloc, child) => Stack(
                children: [
                  Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildAppBar(context, bloc),
                          30.vGap,
                          _buildUserInfo(
                            AppLocalizations.of(context)?.username ?? '',
                            nameValidator,
                            TextInputType.text,
                            controller: _nameController,
                            context,
                          ),
                          10.vGap,
                          IgnorePointer(
                            ignoring: true,
                            child: _buildUserInfo(
                              AppLocalizations.of(context)?.phone ?? '',
                              phoneValidator,
                              controller: _phoneController,
                              TextInputType.phone,
                              context,
                            ),
                          ),
                          10.vGap,
                          _buildUserInfo(
                            AppLocalizations.of(context)?.email ?? '',
                            emailValidator,
                            controller: _emailController,
                            TextInputType.emailAddress,
                            context,
                          ),
                        ],
                      ),
                    ),
                  ),

                  //loading
                  bloc.isLoading ? LoadingView() : SizedBox.shrink(),
                ],
              ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, UserBloc bloc) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 56, left: 8, right: 8),
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
                              bloc.imgFile != null
                                  ? Image.file(bloc.imgFile!, fit: BoxFit.cover)
                                  : widget.userData.profilePictureUrl == ''
                                  ? Image.asset(kProfileCoverIcon)
                                  : cacheImage(
                                    widget.userData.profilePictureUrl,
                                  ),
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
          top: 60,
          right: kMarginMedium2,
          child: Row(
            spacing: 10,
            children: [
              GestureDetector(
                onTap: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    bloc
                        .updateUser(
                          _nameController.text.trim(),
                          _emailController.text.trim(),
                        )
                        .then((_) {
                          bloc.updateToken();
                          bloc.getUser(context: context);
                          Future.delayed(Duration(milliseconds: 300), () {
                            Navigator.of(context).pop();
                          });
                        })
                        .catchError((error) {
                          ToastService.warningToast(error.toString());
                        });
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: kSecondaryColor,
                    borderRadius: BorderRadius.circular(kMarginMedium + 8),
                  ),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)?.save ?? '',
                      style: TextStyle(color: kWhiteColor),
                    ),
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
    String? Function(String?)? validator,
    TextInputType type,
    BuildContext context, {
    TextEditingController? controller,
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
              fontSize: kTextRegular,
            ),
          ),
          5.vGap,
          CustomTextfield(
            hint: title,
            keyboardType: type,
            controller: controller,
            validator: validator,
          ),
          10.vGap,
        ],
      ),
    );
  }
}
