import 'package:flutter/material.dart';
import 'package:movie_obs/data/model/movie_model.dart';
import 'package:movie_obs/data/model/movie_model_impl.dart';
import 'package:movie_obs/data/persistence/persistence_data.dart';
import 'package:movie_obs/data/vos/package_vo.dart';

import '../widgets/common_dialog.dart';
import '../widgets/error_dialog.dart';

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
        .catchError((_) {
          PersistenceData.shared.saveFirstTime(true);
          showCommonDialog(
            context: myContext!,
            isBarrierDismiss: false,
            dialogWidget: ErrorDialogView(
              errorMessage: 'Session Expired. Please Login Again',
              isLogin: true,
            ),
          );
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
