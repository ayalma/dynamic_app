import 'package:dynamic_app/dynamic_app.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences_widgets/shared_preferences_widgets.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicApp(
      defaultLocale: Locale('fa'),
      themes: [
        ThemeData(primaryColor: Colors.yellow),
        ThemeData(primaryColor: Colors.deepPurpleAccent),
        ThemeData(brightness: Brightness.dark)
      ],
      selectedTheme: 0,
      dynamicWidgetBuilder: (context, theme, locale) {
        return MaterialApp(
          title: 'Flutter Demo',
          locale: locale,
          theme: theme,
          home: MyHomePage(title: 'Flutter Demo Home Page'),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void changeLocale() {
    DynamicApp.of(context).setLocale("en");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: <Widget>[
          ListPreferences(
            prefKey: "app_theme",
            defaultValue: 0,
            entries: ["blue", "green", "dark"],
            entryValues: [0, 1, 2],
            title: 'Application theme',
            summary: '',
            onValueChange: (value) {
              DynamicApp.of(context).selectTheme(value);
            },
          )
        ],
      ),
    );
  }
}
