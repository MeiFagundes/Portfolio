import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:meifagundesdotcom/views/home/home_view.dart';
import 'package:meifagundesdotcom/views/shared/shared.dart';

import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PortfolioBootstrap());
}

class PortfolioBootstrap extends StatefulWidget {
  const PortfolioBootstrap({super.key, this.initialize});
  final Future<void> Function()? initialize;

  @override
  State<PortfolioBootstrap> createState() => _PortfolioBootstrapState();
}

class _PortfolioBootstrapState extends State<PortfolioBootstrap> {
  late Future<void> _initialization;

  @override
  void initState() {
    super.initState();
    _initialization = _beginInitialization();
  }

  Future<void> _beginInitialization() {
    final future = _initialize();
    // Retry may fail before FutureBuilder attaches on the next frame.
    future.ignore();
    return future;
  }

  Future<void> _initialize() async {
    if (widget.initialize != null) {
      await widget.initialize!();
    } else {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            !snapshot.hasError) {
          return const MyApp();
        }
        return MaterialApp(
          title: 'Mei Fagundes',
          theme: ThemeData(
            fontFamily: 'OpenSans',
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
          ),
          home: Scaffold(
            body: Center(
              child: snapshot.hasError
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Não foi possível carregar o portfólio.'),
                        TextButton(
                          onPressed: () => setState(() {
                            _initialization = _beginInitialization();
                          }),
                          child: const Text('Tentar novamente'),
                        ),
                      ],
                    )
                  : const CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mei Fagundes',
      theme: ThemeData(
        fontFamily: 'OpenSans',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.pink,
          brightness: Brightness.light,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        iconTheme: const IconThemeData(color: Colors.pinkAccent, size: 25),
        buttonTheme: ButtonThemeData(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(BorderRadiusSizes.level2),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            textStyle: WidgetStateProperty.all<TextStyle>(
              const TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.w600,
              ),
            ),
            foregroundColor: WidgetStateProperty.all<Color>(Colors.pinkAccent),
            padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
            ),
            shape: WidgetStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(BorderRadiusSizes.level2),
              ),
            ),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            textStyle: WidgetStateProperty.all<TextStyle>(
              const TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: WidgetStateProperty.all<Color>(Colors.pinkAccent),
            padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
            ),
            shape: WidgetStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(BorderRadiusSizes.level2),
              ),
            ),
          ),
        ),
      ),
      home: const Home(),
    );
  }
}
