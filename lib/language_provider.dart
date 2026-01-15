import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  Map<String, String> _localizedStrings = {};

  Map<String, String> get strings => _localizedStrings;

  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString('lang') ?? 'en';

    _locale = Locale(langCode);
    await loadLanguageFile(langCode);
    notifyListeners();
  }

  Future<void> loadLanguageFile(String langCode) async {
    String jsonString =
        await rootBundle.loadString('assets/lang/$langCode.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings =
        jsonMap.map((key, value) => MapEntry(key, value.toString()));
  }

  Future<void> changeLanguage(String langCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lang', langCode);

    _locale = Locale(langCode);
    await loadLanguageFile(langCode);
    notifyListeners();
  }

  String t(String key) => _localizedStrings[key] ?? key;
}
