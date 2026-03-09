import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:maroofkhan8/core/utils/snackbar_utils.dart';

class PaymentWebView extends StatefulWidget {
  final String url;
  const PaymentWebView({super.key, required this.url});

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  late final WebViewController _controller;
  bool isLoading = true;
  bool _isHandled = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
            _checkUrl(url);
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
            _checkUrl(url);
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('WebView error: ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  void _checkUrl(String url) {
    if (_isHandled) return;

    if (url.contains('success')) {
      _isHandled = true;
      // Ensure we haven't already moved back
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop(true);
        SnackbarUtils.showSnackbar(
          "Payment Successful",
          "Your transaction was completed successfully.",
        );
      }
    } else if (url.contains('cancel')) {
      _isHandled = true;
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop(false);
        SnackbarUtils.showSnackbar(
          "Payment Cancelled",
          "The payment process was cancelled.",
          isError: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment"),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Get.back(),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
