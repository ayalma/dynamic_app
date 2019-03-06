import 'package:dynamic_app/src/config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef DynamicWidgetBuilder = Widget Function(
    BuildContext context, ThemeData data, Locale locale);
typedef ThemeDataWithBrightnessBuilder = ThemeData Function(
    Brightness brightness);

class DynamicApp extends StatefulWidget {
  final DynamicWidgetBuilder dynamicWidgetBuilder;
  final ThemeDataWithBrightnessBuilder data;
  final Brightness defaultBrightness;
  final Locale defaultLocale;

  const DynamicApp(
      {Key key,
      this.dynamicWidgetBuilder,
      this.data,
      this.defaultBrightness,
      this.defaultLocale})
      : super(key: key);

  @override
  DynamicAppState createState() => DynamicAppState();

  static DynamicAppState of(BuildContext context) =>
      context.ancestorStateOfType(const TypeMatcher<DynamicAppState>());
}

class DynamicAppState extends State<DynamicApp> {
  ThemeData _themeData;
  Locale _locale;
  Brightness _brightness;

  ThemeData get data => _themeData;

  Brightness get brightness => _brightness;

  Locale get locale => _locale;

  @override
  void initState() {
    super.initState();

    //set defaults

    _brightness = widget.defaultBrightness;
    _themeData = widget.data(_brightness);
    _locale = widget.defaultLocale;

    //load saved
    _loadConfig().then((config) {
      _brightness = config.isDark ? Brightness.dark : Brightness.light;
      _themeData = widget.data(_brightness);
      _locale = Locale(config.languageKey);

      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _themeData = widget.data(_brightness);
  }

  @override
  void didUpdateWidget(DynamicApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    _themeData = widget.data(_brightness);
  }


  void setBrightness(Brightness brightness) async {
    setState(() {
      this._themeData = widget.data(brightness);
      this._brightness = brightness;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(
        _brightnessKey, brightness == Brightness.dark ? true : false);
  }

  void setLocale(String localeKey) async {
    setState(() {
      this._locale = Locale(localeKey);
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey,localeKey);
  }

  void setThemeData(ThemeData data) {
    setState(() {
      _themeData = data;
    });
  }

  @override
  Widget build(BuildContext context) =>
      widget.dynamicWidgetBuilder(context, _themeData, _locale);

  static const String _brightnessKey = "app_brightness";
  static const String _localeKey = "app_locale";

  Future<Config> _loadConfig() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isDark = prefs.getBool(_brightnessKey) ??
        widget.defaultBrightness == Brightness.dark;
    final String languageKey =
        prefs.getString(_localeKey) ?? widget.defaultLocale.languageCode;
    return Config(isDark, languageKey);
  }
}
