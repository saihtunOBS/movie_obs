import 'package:flutter/material.dart';
import 'package:movie_obs/l10n/app_localizations.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/widgets/show_loading.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebScreen extends StatefulWidget {
  final String paymentUrl; // URL that shows the payment UI
  final Map<String, String>? postData; // Optional POST parameters

  const PaymentWebScreen({super.key, required this.paymentUrl, this.postData});

  @override
  State<PaymentWebScreen> createState() => _PaymentWebScreenState();
}

class _PaymentWebScreenState extends State<PaymentWebScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(kWhiteColor)
          ..setNavigationDelegate(
            NavigationDelegate(
              onHttpError: (error) {
                setState(() => _isLoading = false);
                Center(child: Text(error.toString()));
              },
              onWebResourceError: (error) {
                setState(() => _isLoading = false);
                Center(child: Text(error.toString()));
              },
              onPageStarted: (_) {
                setState(() => _isLoading = true);
              },
              onPageFinished: (_) {
                setState(() => _isLoading = false);
              },

              onNavigationRequest: (request) {
                final url = request.url.toLowerCase();

                if (url.contains("loadingmerchant") ||
                    url.contains('canceled')) {
                  Navigator.pop(context, 'cancel');
                  return NavigationDecision.prevent;
                }
                if (url.contains("success")) {
                  Navigator.pop(context, 'success');
                } else if (url.contains("fail")) {
                  Navigator.pop(context, 'fail');
                }

                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadHtmlString(_buildPostFormHtml());
  }

  String _buildPostFormHtml() {
    final inputs = widget.postData?.entries
        .map((e) => '<input type="hidden" name="${e.key}" value="${e.value}">')
        .join('\n');

    return '''
      <html>
        <body onload="document.forms[0].submit()">
          <form method="post" action="${widget.paymentUrl}">
            $inputs
          </form>
        </body>
      </html>
    ''';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)?.back ?? '',
          style: TextStyle(color: kBlackColor),
        ),
        centerTitle: false,
        backgroundColor: kWhiteColor,
        foregroundColor: kBlackColor,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          _isLoading
              ? Center(
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: LoadingView(bgColor: Colors.transparent),
                ),
              )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
