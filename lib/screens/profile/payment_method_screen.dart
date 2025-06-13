import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:movie_obs/bloc/payment_method_bloc.dart';
import 'package:movie_obs/data/vos/package_vo.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/l10n/app_localizations.dart';
import 'package:movie_obs/network/responses/payment_response.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:movie_obs/utils/images.dart';
import 'package:movie_obs/widgets/common_dialog.dart';
import 'package:movie_obs/widgets/gradient_button.dart';
import 'package:movie_obs/widgets/show_loading.dart';
import 'package:movie_obs/widgets/toast_service.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({
    super.key,
    required this.plan,
    required this.packageData,
  });
  final String plan;
  final PackageVO packageData;

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

enum DigitalWallet { kPay, ayaPay }

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  DigitalWallet? _selectedWallet;
  int ayaSelectedIndex = 1;
  int kpaySelectedIndex = 1;
  bool isLoading = false;
  PaymentResponse? payment;
  String selectedPayment = '';
  final GlobalKey qrKey = GlobalKey();
  // final ScreenshotController _screenshotController = ScreenshotController();

  @override
  void dispose() {
    super.dispose();
  }

  _saveImage() async {
    RenderRepaintBoundary boundary =
        qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await (image.toByteData(
      format: ui.ImageByteFormat.png,
    ));
    if (byteData != null) {
      await ImageGallerySaverPlus.saveImage(byteData.buffer.asUint8List());
      ToastService.successToast('Image saved to gallery.');
    } else {
      ToastService.warningToast('Fail to saved image to gallery.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PaymentMethodBloc(),
      child: Scaffold(
        backgroundColor: kWhiteColor,
        appBar: AppBar(
          backgroundColor: kWhiteColor,
          surfaceTintColor: kWhiteColor,
          foregroundColor: kBlackColor,
          title: Text(
            AppLocalizations.of(context)?.back ?? '',
            style: TextStyle(color: kBlackColor),
          ),
          centerTitle: false,
        ),
        body: Consumer<PaymentMethodBloc>(
          builder:
              (context, bloc, child) => Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Column(
                    spacing: kMarginMedium2,
                    children: [
                      merchantView(widget.packageData),
                      paymentMethodView(context),
                      Row(
                        spacing: 10,
                        children: [
                          SizedBox(
                            width: 17,
                            height: 17,
                            child: CircleAvatar(
                              backgroundColor: kGradientTwo,
                              child: Icon(
                                Icons.check,
                                color: kWhiteColor,
                                size: 12,
                              ),
                            ),
                          ),
                          Text(
                            'By choosing, you agree to the  Terms & Conditions',
                            style: TextStyle(color: kBlackColor),
                          ),
                        ],
                      ),
                      gradientButton(
                        onPress: () {
                          if (bloc.payment.isNotEmpty) {
                            if (bloc.payment == 'Pay with AYA Pay') {
                              if (bloc.digitalWalletPayment == 'aya_qr') {
                                showCommonDialog(
                                  context: context,
                                  dialogWidget: _buildAlert(bloc),
                                );
                              }
                            }
                          }
                        },
                        context: context,
                        title: bloc.payment == '' ? 'PAYMENT' : bloc.payment,
                        isGradient: bloc.payment != '',
                      ),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 5,
                        children: [
                          Text(
                            'Powered by',
                            style: TextStyle(color: kBlackColor),
                          ),
                          Text(
                            'OBS',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kGradientTwo,
                            ),
                          ),
                        ],
                      ),
                      20.vGap,
                    ],
                  ),
                ),
              ),
        ),
      ),
    );
  }

  Widget paymentMethodView(BuildContext context) {
    return Consumer<PaymentMethodBloc>(
      builder:
          (context, bloc, child) => Card(
            color: kWhiteColor,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                spacing: 5,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Choose Your Payment Method',
                    style: TextStyle(
                      fontSize: kTextRegular3x,
                      color: kBlackColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  5.vGap,
                  //
                  GestureDetector(
                    onTap: () {
                      bloc.onSelectPaymentMethod('digital');
                      bloc.selectedPayment('');
                    },
                    child:
                        bloc.method == 'digital'
                            ? digitalWalletView(bloc)
                            : Card(
                              color: kWhiteColor,
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Digital Wallet',
                                      style: TextStyle(color: kBlackColor),
                                    ),

                                    SizedBox(
                                      child: Row(
                                        spacing: 10,
                                        children: [
                                          SizedBox(
                                            height: 32,
                                            width: 32,
                                            child: Image.asset(kKpayLogo),
                                          ),
                                          SizedBox(
                                            height: 32,
                                            width: 32,
                                            child: Image.asset(kAyaPayLogo),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                  ),

                  GestureDetector(
                    onTap: () {
                      bloc.onSelectPaymentMethod('local');
                      bloc.selectedPayment('Pay with MPU');
                    },
                    child: Stack(
                      children: [
                        Card(
                          elevation: bloc.method == 'local' ? 0.0 : 1.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color:
                                  bloc.method == 'local'
                                      ? kGradientOne
                                      : Colors.transparent,
                            ),
                          ),
                          color: kWhiteColor,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Local Card',
                                  style: TextStyle(color: kBlackColor),
                                ),

                                SizedBox(
                                  height: 32,
                                  width: 32,
                                  child: Image.asset(kMpuLogo),
                                ),
                              ],
                            ),
                          ),
                        ),
                        bloc.method == 'local'
                            ? Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                color: kWhiteColor,
                                child: Icon(
                                  Icons.check_circle,
                                  color: kGradientTwo,
                                  size: 20,
                                ),
                              ),
                            )
                            : SizedBox.shrink(),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      bloc.onSelectPaymentMethod('global');
                      bloc.selectedPayment('Pay with Global Card');
                    },
                    child:
                        bloc.method == 'global'
                            ? globalCardView()
                            : Card(
                              color: kWhiteColor,
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Global Card',
                                      style: TextStyle(color: kBlackColor),
                                    ),

                                    SizedBox(
                                      height: 32,
                                      width:
                                          MediaQuery.of(context).size.width / 3,
                                      child: Image.asset(kGlobalCardLogo),
                                    ),
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

  Widget merchantView(PackageVO package) {
    return Card(
      color: kWhiteColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 94,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 94,
                    height: 94,
                    child: Image.asset(kMerchantLogo),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      '${package.price} Ks',
                      style: TextStyle(
                        fontSize: kTextRegular3x,
                        color: kBlackColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            23.vGap,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Merchant Name',
                  style: TextStyle(
                    fontSize: kTextRegular2x,
                    color: kBlackColor,
                  ),
                ),
                Text(
                  package.name ?? '',
                  style: TextStyle(
                    fontSize: kTextRegular2x,
                    fontWeight: FontWeight.bold,
                    color: kBlackColor,
                  ),
                ),
              ],
            ),
            16.vGap,
            Row(
              spacing: 20,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Invoice ID',
                  style: TextStyle(
                    fontSize: kTextRegular2x,
                    color: kBlackColor,
                  ),
                ),
                Expanded(
                  child: Text(
                    textAlign: TextAlign.end,
                    overflow: TextOverflow.ellipsis,
                    package.id ?? '',
                    style: TextStyle(
                      fontSize: kTextRegular2x,
                      fontWeight: FontWeight.bold,
                      color: kBlackColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget digitalWalletView(PaymentMethodBloc bloc) {
    return Stack(
      children: [
        Card(
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: kGradientOne),
          ),
          color: kWhiteColor,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Digital Wallet',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: kTextRegular2x,
                    color: kBlackColor,
                  ),
                ),
                10.vGap,
                RadioListTile<DigitalWallet>(
                  contentPadding: EdgeInsets.zero,
                  visualDensity: VisualDensity(horizontal: -4.0),
                  title: Row(
                    spacing: 10,
                    children: [
                      SizedBox(
                        width: 32,
                        height: 32,
                        child: Image.asset(kKpayLogo),
                      ),
                      Text("KBZ PAY", style: TextStyle(color: kBlackColor)),
                    ],
                  ),
                  value: DigitalWallet.kPay,
                  groupValue: _selectedWallet,
                  onChanged: (value) {
                    setState(() {
                      _selectedWallet = value!;
                      ayaSelectedIndex = 1;
                      kpaySelectedIndex = 1;
                    });
                    bloc.selectedPayment('Pay with KBZ Pay');
                  },
                ),
                _selectedWallet == DigitalWallet.kPay
                    ? kpaySegmentControl()
                    : SizedBox.shrink(),
                Divider(color: Colors.grey, thickness: 0.7),
                RadioListTile<DigitalWallet>(
                  contentPadding: EdgeInsets.zero,
                  visualDensity: VisualDensity(horizontal: -4.0),
                  title: Row(
                    spacing: 10,
                    children: [
                      SizedBox(
                        width: 32,
                        height: 32,
                        child: Image.asset(kAyaPayLogo),
                      ),
                      Text("AYA PAY", style: TextStyle(color: kBlackColor)),
                    ],
                  ),
                  value: DigitalWallet.ayaPay,
                  groupValue: _selectedWallet,
                  onChanged: (value) {
                    setState(() {
                      _selectedWallet = value!;
                      ayaSelectedIndex = 1;
                      kpaySelectedIndex = 1;
                      bloc.selectedPayment('Pay with AYA Pay');
                    });
                  },
                ),
                _selectedWallet == DigitalWallet.ayaPay
                    ? ayaSegmentControl(bloc)
                    : SizedBox.shrink(),
              ],
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            color: kWhiteColor,
            child: Icon(Icons.check_circle, color: kGradientTwo, size: 20),
          ),
        ),
      ],
    );
  }

  Widget ayaSegmentControl(PaymentMethodBloc bloc) {
    return Column(
      children: [
        Center(
          child: CustomSlidingSegmentedControl(
            decoration: BoxDecoration(
              color: CupertinoColors.lightBackgroundGray,
              borderRadius: BorderRadius.circular(20),
            ),
            customSegmentSettings: CustomSegmentSettings(
              highlightColor: Colors.red,
            ),
            thumbDecoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.center,
                colors: [kGradientOne, kGradientTwo],
              ),
            ),
            children: {
              1: Row(
                spacing: 5,
                children: [
                  SizedBox(
                    width: 25,
                    height: 25,
                    child: Image.asset(
                      kInAppLogo,
                      color: ayaSelectedIndex == 1 ? kWhiteColor : kBlackColor,
                    ),
                  ),
                  Text(
                    'In App Pay',
                    style: TextStyle(
                      color: ayaSelectedIndex == 1 ? kWhiteColor : kBlackColor,
                    ),
                  ),
                ],
              ),
              2: Row(
                spacing: 5,
                children: [
                  Icon(
                    CupertinoIcons.qrcode,
                    color: ayaSelectedIndex == 2 ? kWhiteColor : kBlackColor,
                  ),
                  Text(
                    'QR Code',
                    style: TextStyle(
                      color: ayaSelectedIndex == 2 ? kWhiteColor : kBlackColor,
                    ),
                  ),
                ],
              ),
            },
            onValueChanged: (value) {
              setState(() {
                ayaSelectedIndex = value;
              });
              if (value == 1) {
                bloc.selectedInAppOrQr('aya_inApp');
              } else {
                bloc.selectedInAppOrQr('aya_qr');
              }
            },
          ),
        ),

        ayaSelectedIndex == 2
            ? SizedBox.shrink()
            : Column(
              spacing: 5,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                10.vGap,
                Text(
                  'Enter Phone Number',
                  style: TextStyle(
                    fontSize: kTextRegular2x,
                    color: kBlackColor,
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 48,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Center(
                    child: Row(
                      spacing: 10,
                      children: [
                        Text('+95', style: TextStyle(color: kBlackColor)),
                        Container(height: 20, width: 1, color: kBlackColor),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Phone Number',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      ],
    );
  }

  Widget kpaySegmentControl() {
    return Column(
      children: [
        Center(
          child: CustomSlidingSegmentedControl(
            decoration: BoxDecoration(
              color: CupertinoColors.lightBackgroundGray,
              borderRadius: BorderRadius.circular(20),
            ),
            customSegmentSettings: CustomSegmentSettings(
              highlightColor: Colors.red,
            ),
            thumbDecoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.center,
                colors: [kGradientOne, kGradientTwo],
              ),
            ),
            children: {
              1: Row(
                spacing: 5,
                children: [
                  SizedBox(
                    width: 25,
                    height: 25,
                    child: Image.asset(
                      kInAppLogo,
                      color: kpaySelectedIndex == 1 ? kWhiteColor : kBlackColor,
                    ),
                  ),
                  Text(
                    'In App Pay',
                    style: TextStyle(
                      color: kpaySelectedIndex == 1 ? kWhiteColor : kBlackColor,
                    ),
                  ),
                ],
              ),
              2: Row(
                spacing: 5,
                children: [
                  Icon(
                    CupertinoIcons.qrcode,
                    color: kpaySelectedIndex == 2 ? kWhiteColor : kBlackColor,
                  ),
                  Text(
                    'QR Code',
                    style: TextStyle(
                      color: kpaySelectedIndex == 2 ? kWhiteColor : kBlackColor,
                    ),
                  ),
                ],
              ),
            },
            onValueChanged: (value) {
              setState(() {
                kpaySelectedIndex = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget globalCardView() {
    return Stack(
      children: [
        Card(
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: kGradientOne),
          ),
          color: kWhiteColor,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Global Card',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: kTextRegular2x,
                    color: kBlackColor,
                  ),
                ),
                10.vGap,
                SizedBox(
                  width: 147,
                  height: 32,
                  child: Image.asset(kGlobalCardLogo),
                ),
                _textfield('First Name'),
                _textfield('Last Name'),
                _textfield('E-mail'),
                _textfield('Phone Number'),
                _addressTextfield('Address'),
              ],
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            color: kWhiteColor,
            child: Icon(Icons.check_circle, color: kGradientTwo, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _textfield(String title) {
    return Column(
      spacing: 5,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        10.vGap,
        Text(
          title,
          style: TextStyle(fontSize: kTextRegular2x, color: kBlackColor),
        ),
        Container(
          width: double.infinity,
          height: 48,
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.grey),
          ),
          child: Center(
            child: TextField(
              style: TextStyle(color: kBlackColor),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: title,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _addressTextfield(String title) {
    return Column(
      spacing: 5,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        5.vGap,
        Text(
          title,
          style: TextStyle(fontSize: kTextRegular2x, color: kBlackColor),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.grey),
          ),
          child: Center(
            child: TextField(
              style: TextStyle(color: kBlackColor),
              maxLines: null,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: title,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAlert(PaymentMethodBloc bloc) {
    int dialogStart = 60;
    Timer? dialogTimer;
    bool hasFetchedPayment = false;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        dialogTimer?.cancel(); // cancel timer on back press
      },
      child: Dialog(
        insetPadding: const EdgeInsets.all(16),
        backgroundColor: kWhiteColor,
        child: StatefulBuilder(
          builder: (context, dialogSetState) {
            void startDialogTimer() {
              dialogTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
                if (dialogStart > 0) {
                  dialogSetState(() {
                    dialogStart--;
                  });
                } else {
                  dialogTimer?.cancel();
                }
              });
            }

            String dialogTimerText() {
              final minutes = (dialogStart ~/ 60).toString().padLeft(2, '0');
              final seconds = (dialogStart % 60).toString().padLeft(2, '0');
              return '$minutes:$seconds';
            }

            if (!hasFetchedPayment) {
              hasFetchedPayment = true;

              dialogSetState(() => isLoading = true);

              bloc
                  .createPayment('ayapay', widget.plan)
                  .then((response) {
                    startDialogTimer();

                    dialogSetState(() {
                      payment = response;
                      isLoading = false;
                      _saveImage();
                    });
                  })
                  .catchError((e) {
                    dialogSetState(() => isLoading = false);
                    ToastService.warningToast(e.toString());
                  });
            }

            return RepaintBoundary(
              key: qrKey,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: kWhiteColor,
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    10.vGap,
                    Center(
                      child: Text(
                        'Scan with your phone to make payment.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: kBlackColor,
                          fontSize: kTextRegular2x,
                        ),
                      ),
                    ),
                    isLoading
                        ? _buildLoading()
                        : _buildQrView(payment?.qrData ?? '', () {
                          dialogSetState(() => isLoading = true);
                          bloc
                              .createPayment('ayapay', widget.plan)
                              .then((response) {
                                dialogTimer?.cancel();
                                dialogStart = 60;
                                startDialogTimer();

                                dialogSetState(() {
                                  payment = response;
                                  isLoading = false;
                                  dialogStart = 60;
                                  _saveImage();
                                });
                              })
                              .catchError((e) {
                                dialogSetState(() => isLoading = false);
                                ToastService.warningToast(e.toString());
                              });
                        }, dialogTimerText()),
                    10.vGap,
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _buildLoading() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        40.vGap,
        SizedBox(
          height: 20,
          width: 20,
          child: LoadingView(bgColor: Colors.transparent),
        ),
        10.vGap,
        Text(
          'loading....',
          style: TextStyle(fontSize: kTextRegular13, color: kBlackColor),
        ),
        10.vGap,
      ],
    );
  }

  _buildQrView(String qrCode, VoidCallback onPerss, String timer) {
    return Column(
      children: [
        10.vGap,
        qrCode.isEmpty
            ? SizedBox(
              height: 80,
              child: Center(
                child: Column(
                  children: [
                    Icon(CupertinoIcons.question, size: 38, color: Colors.red),
                    15.vGap,
                    Text(
                      'Uh oh! Something went wrong...',
                      style: TextStyle(color: kBlackColor, fontSize: 12),
                    ),
                  ],
                ),
              ),
            )
            : QrImageView(
              data: qrCode,
              version: QrVersions.auto,
              size: 170,
              gapless: false,
              errorStateBuilder: (cxt, err) {
                return Center(
                  child: Text(
                    'Uh oh! Something went wrong...',
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
        TextButton(
          onPressed: onPerss,
          child: Text(
            'Refresh Code',
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: kGradientOne,
              decorationThickness: 2.0,
              decorationColor: kGradientOne,
            ),
          ),
        ),

        Text(
          'Code expires in : $timer',
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
      ],
    );
  }
}
