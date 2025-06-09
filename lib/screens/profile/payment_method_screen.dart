import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/payment_method_bloc.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/l10n/app_localizations.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:movie_obs/utils/images.dart';
import 'package:movie_obs/widgets/gradient_button.dart';
import 'package:provider/provider.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

enum DigitalWallet { kPay, ayaPay }

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  DigitalWallet? _selectedWallet;
  int selectedIndex = 1;
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
                      merchantView(),
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
                        onPress: () {},
                        context: context,
                        title: bloc.payment == '' ? 'PAYMENT' : bloc.payment,
                        isGradient: bloc.payment != '',
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

  Widget merchantView() {
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
                      '2000000 Ks',
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
                  'User',
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Invoice ID',
                  style: TextStyle(
                    fontSize: kTextRegular2x,
                    color: kBlackColor,
                  ),
                ),
                Text(
                  '22233434',
                  style: TextStyle(
                    fontSize: kTextRegular2x,
                    fontWeight: FontWeight.bold,
                    color: kBlackColor,
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
                    });
                    bloc.selectedPayment('Pay with KBZ Pay');
                  },
                ),
                _selectedWallet == DigitalWallet.kPay
                    ? segmentControl(true)
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
                      bloc.selectedPayment('Pay with AYA Pay');
                    });
                  },
                ),
                _selectedWallet == DigitalWallet.ayaPay
                    ? segmentControl(false)
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

  Widget segmentControl(bool isKpay) {
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
                      color: selectedIndex == 1 ? kWhiteColor : kBlackColor,
                    ),
                  ),
                  Text(
                    'In App Pay',
                    style: TextStyle(
                      color: selectedIndex == 1 ? kWhiteColor : kBlackColor,
                    ),
                  ),
                ],
              ),
              2: Row(
                spacing: 5,
                children: [
                  Icon(
                    CupertinoIcons.qrcode,
                    color: selectedIndex == 2 ? kWhiteColor : kBlackColor,
                  ),
                  Text(
                    'QR Code',
                    style: TextStyle(
                      color: selectedIndex == 2 ? kWhiteColor : kBlackColor,
                    ),
                  ),
                ],
              ),
            },
            onValueChanged: (value) {
              setState(() {
                selectedIndex = value;
              });
            },
          ),
        ),

        isKpay == false
            ? Column(
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
            )
            : SizedBox.shrink(),
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
                10.vGap,
                SelectState(
                  style: TextStyle(color: kBlackColor),
                  dropdownColor: kWhiteColor,
                  onCountryChanged: (value) {
                    setState(() {});
                  },
                  onStateChanged: (value) {
                    setState(() {});
                  },
                  onCityChanged: (value) {
                    setState(() {});
                  },
                ),

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
}
