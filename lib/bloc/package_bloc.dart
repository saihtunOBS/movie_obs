import 'package:flutter/material.dart';
import 'package:movie_obs/data/model/movie_model.dart';
import 'package:movie_obs/data/model/movie_model_impl.dart';
import 'package:movie_obs/data/persistence/persistence_data.dart';
import 'package:movie_obs/data/vos/package_vo.dart';
import 'package:movie_obs/extension/page_navigator.dart';
import 'package:movie_obs/screens/auth/login_screen.dart';
import 'package:movie_obs/widgets/toast_service.dart';

class PackageBloc extends ChangeNotifier {
  bool isLoading = false;
  bool isDisposed = false;
  String token = '';
  List<PackageVO>? packages;
  PackageVO? selectedPackage;
  final MovieModel _movieModel = MovieModelImpl();
  BuildContext? myContext;
  String packageId = '';

  PackageBloc({BuildContext? context}) {
    myContext = context;
    packageId = '';
    token = PersistenceData.shared.getToken();
    getPackage();
  }

  choosePackage(String package, PackageVO packageData) {
    packageId = package;
    selectedPackage = packageData;
    notifyListeners();
  }

  getPackage() {
    _showLoading();
    _movieModel
        .getAllPackage(token)
        .then((response) {
          packages = response.data ?? [];
          notifyListeners();
        })
        .whenComplete(() {
          _hideLoading();
        })
        .catchError((e) {
          PersistenceData.shared.clearToken();
          PageNavigator(ctx: myContext).nextPageOnly(page: LoginScreen());
          ToastService.warningToast(e.toString());
        });
  }

  _showLoading() {
    isLoading = true;
    _notifySafely();
  }

  _hideLoading() {
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
