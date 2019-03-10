import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesBuilder<T> extends StatelessWidget {
  final String prefKey;
  final AsyncWidgetBuilder<T> builder;

  const SharedPreferencesBuilder({Key key, this.prefKey, this.builder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(future: _value(), builder: this.builder);
  }

  Future<T> _value() async {
    return (await SharedPreferences.getInstance()).get(prefKey);
  }
}
