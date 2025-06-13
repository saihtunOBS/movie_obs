import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:movie_obs/bloc/user_bloc.dart';
import 'package:movie_obs/data/model/movie_model.dart';
import 'package:movie_obs/data/model/movie_model_impl.dart';
import 'package:movie_obs/data/persistence/persistence_data.dart';
import 'package:movie_obs/network/requests/payment_request.dart';
import 'package:movie_obs/network/responses/payment_response.dart';
import 'package:movie_obs/widgets/toast_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class PaymentMethodBloc extends ChangeNotifier {
  bool isSelectPayment = false;
  String method = '';
  String payment = '';
  String digitalWalletPayment = '';
  bool isLoading = false;
  bool isDisposed = false;
  String token = '';
  PaymentResponse? paymentResponse;
  final MovieModel _movieModel = MovieModelImpl();

  PaymentMethodBloc() {
    token = PersistenceData.shared.getToken();
  }

  selectedPayment(String paymentType) {
    payment = paymentType;
    if (paymentType == 'Pay with AYA Pay') {
      digitalWalletPayment = 'aya_inApp';
    } else {
      digitalWalletPayment = 'kbz_inApp';
    }

    notifyListeners();
  }

  selectedInAppOrQr(String type) {
    digitalWalletPayment = type;
    notifyListeners();
  }

  onSelectPaymentMethod(String selectedMethod) {
    method = selectedMethod;
    isSelectPayment = true;
    notifyListeners();
  }

  Future<void> saveQrToGalleryWithGallerySaver(GlobalKey qrKey) async {
    final permissionStatus = await Permission.photos.request();
    if (!permissionStatus.isGranted) return;

    try {
      RenderRepaintBoundary boundary =
          qrKey.currentContext?.findRenderObject() as RenderRepaintBoundary;

      if (boundary.debugNeedsPaint) {
        await Future.delayed(const Duration(milliseconds: 20));
        return saveQrToGalleryWithGallerySaver(qrKey); // Retry
      }

      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      final directory = await getTemporaryDirectory();
      final filePath =
          '${directory.path}/qr_code_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(filePath);
      await file.writeAsBytes(pngBytes);

      await GallerySaver.saveImage(file.path)
          .then((_) {
            ToastService.successToast('Image save to gallery!');
          })
          .catchError((_) {
            ToastService.warningToast('Error saving image!');
          });
    } catch (e) {
      ToastService.warningToast('Error saving image!');
    }
  }

  Future<PaymentResponse> createPayment(String paymentType, String plan) async {
    return Future.delayed(Duration(seconds: 2), () {
      var request = PaymentRequest(
        userDataListener.value.id ?? '',
        plan,
        paymentType,
        'QR_CODE',
        userDataListener.value.phone,
      );
      return _movieModel.createPayment(token, request);
    });
  }

  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }
}
