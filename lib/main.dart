import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(const CoffeeBreakApp());

class CoffeeBreakApp extends StatelessWidget {
  const CoffeeBreakApp({super.key, this.useWebView = true});

  final bool useWebView;

  @override
  Widget build(BuildContext context) {
    final canUseWebView = useWebView &&
        !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS);

    return MaterialApp(
      title: 'CoffeeBreak Boracay',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8A4B2A)),
        useMaterial3: true,
      ),
      home: canUseWebView ? const CoffeeBreakWebView() : const UnsupportedPreviewScreen(),
    );
  }
}

class CoffeeBreakWebView extends StatefulWidget {
  const CoffeeBreakWebView({super.key});

  @override
  State<CoffeeBreakWebView> createState() => _CoffeeBreakWebViewState();
}

class _CoffeeBreakWebViewState extends State<CoffeeBreakWebView> {
  late final WebViewController _controller;
  var _loading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFFF5EFE4))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) => setState(() => _loading = false),
        ),
      )
      ..loadFlutterAsset('index.html');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_loading)
              const ColoredBox(
                color: Color(0xFFF5EFE4),
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xFF8A4B2A)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class UnsupportedPreviewScreen extends StatelessWidget {
  const UnsupportedPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EFE4),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/CB-logo.png', width: 92, height: 92),
                const SizedBox(height: 18),
                const Text(
                  'CoffeeBreak Boracay',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 12),
                const Text(
                  'This Flutter wrapper uses WebView, which runs on iOS and Android builds. For browser preview, open the original index.html. For iPhone, build with Codemagic and install through TestFlight.',
                  textAlign: TextAlign.center,
                  style: TextStyle(height: 1.45, color: Color(0xFF705746)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
