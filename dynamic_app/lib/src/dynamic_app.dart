import 'dart:async';

import 'package:dynamic_app/src/config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef DynamicWidgetBuilder = Widget Function(
    BuildContext context, ThemeData data, Locale locale);

class DynamicApp extends StatefulWidget {
  final DynamicWidgetBuilder dynamicWidgetBuilder;
  final Locale defaultLocale;
  final Iterable<ThemeData> themes;
  final int selectedTheme;

  const DynamicApp(
      {Key key,
      this.dynamicWidgetBuilder,
      this.defaultLocale,
      this.themes,
      this.selectedTheme = 0})
      : assert(themes != null),
        super(key: key);

  @override
  DynamicAppState createState() => DynamicAppState();

  static DynamicAppState of(BuildContext context) =>
      context.ancestorStateOfType(const TypeMatcher<DynamicAppState>());
}

class DynamicAppState extends State<DynamicApp> {
  ThemeData _themeData;
  Locale _locale;
  int _selectedTheme;

  ThemeData get themeData => _themeData;

  Iterable<ThemeData> get themes => widget.themes;

  Locale get locale => _locale;

  @override
  void initState() {
    super.initState();

    //set defaults
    _selectedTheme = widget.selectedTheme;
    _themeData = widget.themes.elementAt(_selectedTheme);
    _locale = widget.defaultLocale;

    //load saved
    _loadConfig().then((config) {
      _selectedTheme = config.selectedTheme;
      _themeData = widget.themes.elementAt(config.selectedTheme);

      _locale = Locale(config.languageKey);

      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _themeData = widget.themes.elementAt(_selectedTheme);
  }

  @override
  void didUpdateWidget(DynamicApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    _themeData = widget.themes.elementAt(_selectedTheme);
  }

  void setLocale(String localeKey) async {
    setState(() {
      this._locale = Locale(localeKey);
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, localeKey);
  }

  @deprecated
  void setThemeData(ThemeData data) {
    setState(() {
      _themeData = data;
    });
  }

  void selectTheme(int themePosition) async {
    setState(() {
      _themeData = widget.themes.elementAt(themePosition);
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, themePosition);
  }

  @override
  Widget build(BuildContext context) =>
      widget.dynamicWidgetBuilder(context, _themeData, _locale);

  static const String _localeKey = "app_locale";
  static const String _themeKey = "app_theme";

  Future<Config> _loadConfig() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String languageKey =
        prefs.getString(_localeKey) ?? widget.defaultLocale.languageCode;
    final int selectedTheme = prefs.getInt(_themeKey) ?? widget.selectedTheme;

    return Config(languageKey, selectedTheme);
  }
}
