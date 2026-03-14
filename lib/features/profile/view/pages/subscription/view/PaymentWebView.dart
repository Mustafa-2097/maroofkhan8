import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

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

  bool? _paymentResult;

  void _checkUrl(String url) async {
    if (_isHandled) return;

    final lowerUrl = url.toLowerCase();

    // Handle immediate exit if the user clicks an internal "Back" or "Return" button in the WebView
    if (lowerUrl.contains('back') || lowerUrl.contains('return')) {
      // If it's a back/return button, exit immediately without the status delay
      // unless it specifically indicates a success state.
      if (!lowerUrl.contains('success')) {
        _isHandled = true;
        if (mounted && Navigator.of(context).canPop()) {
          Navigator.of(context).pop(false);
        }
        return;
      }
    }

    if (lowerUrl.contains('success')) {
      _isHandled = true;
      _paymentResult = true;
      // Wait for a few seconds so user can see the success page in WebView
      await Future.delayed(const Duration(seconds: 3));
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop(true);
      }
    } else if (lowerUrl.contains('cancel')) {
      _isHandled = true;
      _paymentResult = false;
      // Wait for a few seconds so user can see the cancel page in WebView
      await Future.delayed(const Duration(seconds: 3));
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop(false);
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
          onPressed: () => Navigator.of(context).pop(_paymentResult),
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
