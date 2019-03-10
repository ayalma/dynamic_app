import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_widgets/src/shared_preferences_builder.dart';

typedef OnValueChange = void Function(bool value);

class SwitchPreferences extends StatefulWidget {
  final String title;
  final String summary;
  final IconData icon;
  final String prefKey;
  final OnValueChange onValueChange;

  const SwitchPreferences(
      {Key key,
      this.title,
      this.summary,
      this.icon,
      this.prefKey,
      this.onValueChange})
      : super(key: key);

  @override
  _SwitchPreferencesState createState() => _SwitchPreferencesState();
}

class _SwitchPreferencesState extends State<SwitchPreferences> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return SharedPreferencesBuilder<bool>(
      prefKey: widget.prefKey,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          _value = snapshot.data;
        }
        return InkWell(
          onTap: (){
            onValueChange(!_value);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
               
                (widget.icon != null)?Icon(widget.icon):Container(),
                SizedBox(
                  width: 16.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.title,
                        style: Theme.of(context).textTheme.title,
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(widget.summary,
                          style: Theme.of(context).textTheme.caption),
                    ],
                  ),
                ),
                Switch(
                  value: _value,
                  onChanged: onValueChange,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void onValueChange(value) async{
              if (widget.onValueChange != null) {
                (await SharedPreferences.getInstance()).setBool(widget.prefKey, value).then((result){
                  setState(() {
                    _value = value;
                  });
                  widget.onValueChange(value);
                });
              }
            }
}
