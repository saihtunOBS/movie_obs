import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movie_obs/data/model/movie_model.dart';
import 'package:movie_obs/data/model/movie_model_impl.dart';
import 'package:movie_obs/data/persistence/persistence_data.dart';
import 'package:movie_obs/extension/page_navigator.dart';
import 'package:movie_obs/network/requests/google_login_request.dart';
import 'package:movie_obs/network/requests/send_otp_request.dart';
import 'package:movie_obs/network/requests/verify_otp_request.dart';
import 'package:movie_obs/network/responses/otp_response.dart';
import 'package:movie_obs/screens/bottom_nav/bottom_nav_screen.dart';
import 'package:movie_obs/widgets/toast_service.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthBloc extends ChangeNotifier {
  bool isLoading = false;
  bool isDisposed = false;
  bool isSocialLogin = false;

  final MovieModel _movieModel = MovieModelImpl();

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

  void loginWithApple(BuildContext context) async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: credential.identityToken,
      accessToken: credential.authorizationCode,
    );

    final UserCredential userCredential = await FirebaseAuth.instance
        .signInWithCredential(oauthCredential);

    String? fcmToken = await FirebaseMessaging.instance.getToken();

    _showLoading();
    var request = GoogleLoginRequest(
      userCredential.user?.email,
      credential.givenName == null
          ? 'User'
          : '${credential.givenName} ${credential.familyName}',
      fcmToken,
    );
    _movieModel
        .googleLogin(request)
        .then((response) async {
          await FirebaseAuth.instance.signOut();
          PersistenceData.shared.saveToken(response.accessToken ?? '');
          tab.value = true;
          PageNavigator(ctx: context).nextPageOnly(page: BottomNavScreen());
        })
        .catchError((error) async {
          hideLoading();
          await FirebaseAuth.instance.signOut();
          ToastService.warningToast(error.toString());
        });
  }

  void loginGoogle(BuildContext context) async {
    isSocialLogin = true;
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    GoogleSignIn googleSignIn = GoogleSignIn();
    googleSignIn
        .signIn()
        .then((response) {
          isSocialLogin = false;
          if (response?.displayName?.isEmpty ?? true) {
            hideLoading();
            return;
          }
          googleSignIn.signOut();
          _showLoading();
          var request = GoogleLoginRequest(
            response?.email ?? '',
            response?.displayName ?? '',
            fcmToken,
          );
          _movieModel
              .googleLogin(request)
              .then((response) {
                PersistenceData.shared.saveToken(response.accessToken ?? '');
                tab.value = true;
                PageNavigator(
                  ctx: context,
                ).nextPageOnly(page: BottomNavScreen());
              })
              .catchError((e) {
                ToastService.warningToast(e.toString());
                hideLoading();
              });
        })
        .catchError((_) {
          googleSignIn.signOut();
          isSocialLogin = false;
        })
        .whenComplete(() {
          isSocialLogin = false;
          googleSignIn.signOut();
        });
  }

  Future getAuthUser() async {
    var token = PersistenceData.shared.getToken();
    return _movieModel.getUser(token).then((value) {
      hideLoading();
    });
  }

  Future<OTPResponse> verifyOtp(String phone, String requestId, String otp) {
    _showLoading();
    var request = VerifyOtpRequest(phone, 'CUSTOMER', otp, requestId);
    return _movieModel.verifyOtp(request).whenComplete(() {
      hideLoading();
    });
  }

  Future<OTPResponse> userLogin(String phoneNubmer) async {
    _showLoading();
    var request = SendOtpRequest(phoneNubmer);
    return _movieModel.sendOtp(request).whenComplete(() {
      hideLoading();
    });
  }

  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }
}
