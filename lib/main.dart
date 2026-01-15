import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final savedLocale = prefs.getString('app_locale');

  runApp(MyApp(
    initialLocale: savedLocale != null ? Locale(savedLocale) : const Locale('en'),
  ));
}

class MyApp extends StatefulWidget {
  final Locale initialLocale;

  const MyApp({super.key, required this.initialLocale});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _locale = widget.initialLocale;
  }

  void changeLanguage(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_locale', code);

    setState(() {
      _locale = Locale(code);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: _locale,

      supportedLocales: const [
        Locale('en'), // English
        Locale('hi'), // Hindi
        Locale('ar'), // Arabic
      ],

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      home: HomePage(
        onLanguageChange: changeLanguage,
        locale: _locale,
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final Function(String) onLanguageChange;
  final Locale locale;

  const HomePage({
    super.key,
    required this.onLanguageChange,
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multilang Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Current Language: ${locale.languageCode}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),

            // Language Selector Dropdown
            DropdownButton<String>(
              value: locale.languageCode,
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'hi', child: Text('Hindi')),
                DropdownMenuItem(value: 'ar', child: Text('Arabic')),
              ],
              onChanged: (value) {
                if (value != null) {
                  onLanguageChange(value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
