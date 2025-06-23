import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_obs/data/model/movie_model.dart';
import 'package:movie_obs/data/model/movie_model_impl.dart';
import 'package:movie_obs/data/persistence/persistence_data.dart';
import 'package:movie_obs/data/vos/user_vo.dart';
import 'package:movie_obs/extension/page_navigator.dart';
import 'package:movie_obs/screens/auth/login_screen.dart';
import 'package:movie_obs/widgets/toast_service.dart';

import '../screens/bottom_nav/bottom_nav_screen.dart';

final ValueNotifier<UserVO> userDataListener = ValueNotifier(UserVO());

class UserBloc extends ChangeNotifier {
  bool isLoading = false;
  bool isDisposed = false;
  String token = '';
  UserVO? userData;
  File? imgFile;
  final MovieModel _movieModel = MovieModelImpl();
  BuildContext? myContext;

  UserBloc({BuildContext? context}) {
    myContext = context;
    updateToken();
  }

  onTapupdate() {
    _showLoading();

    Future.delayed(Duration(milliseconds: 1000), () {
      hideLoading();
    });
  }

  updateToken() {
    token = PersistenceData.shared.getToken();
    getUser(context: myContext);
    notifyListeners();
  }

  Future deleteUser(BuildContext context) {
    _showLoading();
    return _movieModel
        .deleteUser(token)
        .then((_) {
          tab.value = false;
          hideLoading();
          PersistenceData.shared.clearToken();
          PageNavigator(ctx: context).nextPageOnly(page: LoginScreen());
        })
        .catchError((e) {
          tab.value = false;
          hideLoading();
          PersistenceData.shared.clearToken();
          PageNavigator(ctx: context).nextPageOnly(page: LoginScreen());
          ToastService.warningToast(e.toString());
        });
  }

  getUser({BuildContext? context}) {
    _movieModel
        .getUser(token)
        .then((response) {
          userData = response;
          userDataListener.value = response;
          notifyListeners();
        })
        .catchError((e) {
          PersistenceData.shared.clearToken();
          PageNavigator(ctx: context).nextPageOnly(page: LoginScreen());
          ToastService.warningToast(e.toString());
        })
        .whenComplete(() {
          hideLoading();
        });
  }

  Future<UserVO> updateUser(String name, String email) async {
    _showLoading();
    String? fcmToken = await FirebaseMessaging.instance.getToken();

    return _movieModel
        .updateUser(token, imgFile, name, email, 'ENG', fcmToken ?? '')
        .whenComplete(() {
          hideLoading();
        });
  }

  void selectImage(int type) async {
    final ImagePicker picker = ImagePicker();
    final XFile? img = await picker.pickImage(source: ImageSource.values[type]);
    if (img == null) return;

    String path = await cropImage(img);
    if (path.isEmpty) return;

    imgFile = File(path);
  }

  Future<String> cropImage(XFile? imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile!.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPresetCustom(),
          ],
        ),
        IOSUiSettings(
          title: 'Cropper',
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPresetCustom(),
          ],
        ),
      ],
    );
    notifyListeners();
    return croppedFile?.path ?? '';
  }

  _showLoading() {
    isLoading = true;
    _notifySafely();
  }

  hideLoading() {
    isLoading = false;
    _notifySafely();
  }

  void _notifySafely() {
    if (!isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }
}

class CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (2, 3);

  @override
  String get name => '2x3 (customized)';
}
