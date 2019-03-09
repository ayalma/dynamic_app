import 'package:shared_preferences/shared_preferences.dart';

class Config {
  final bool isDark;
  final String languageKey;
  final int selectedTheme;

  Config(this.isDark, this.languageKey, this.selectedTheme);
}
