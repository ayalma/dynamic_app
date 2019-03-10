import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_widgets/src/entry_dialog.dart';
import 'package:shared_preferences_widgets/src/shared_preferences_builder.dart';

class ListPreferences<T> extends StatefulWidget {
  final String prefKey;
  final String title;
  final T defaultValue;
  final List<String> entries;
  final List<T> entryValues;
  final String summary;
  final IconData icon;
  final IconData dialogIcon;

  final OnValueChange onValueChange;

  const ListPreferences(
      {Key key,
      this.prefKey,
      this.title,
      this.defaultValue,
      this.entries,
      this.entryValues,
      this.summary,
      this.icon,
      this.dialogIcon,
      this.onValueChange})
      : super(key: key);

  @override
  _ListPreferencesState<T> createState() => _ListPreferencesState<T>();
}

class _ListPreferencesState<T> extends State<ListPreferences> {
  T _value;

  @override
  void initState() {
    _value = widget.defaultValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SharedPreferencesBuilder<T>(
      prefKey: widget.prefKey,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        if (snapshot.hasData) {
          _value = snapshot.data;
        }

        return InkWell(
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return EntryDialog<T>(
                    dialogTitle: 'Select ${widget.title}',
                    selected: widget.entryValues.indexOf(_value),
                    entries: widget.entries,
                    entryValues: widget.entryValues,
                    onValueChange: (dynamic  data){
                      SharedPreferences.getInstance().then((instance){
                        if(widget.onValueChange != null) {
                          instance.setString(widget.prefKey, data.toString())
                              .then((result) {
                            setState(() {
                              _value = data;
                            });
                            widget.onValueChange(_value);
                          });
                        }
                      });
                    },
                    );
          });},
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                (widget.icon != null) ? Icon(widget.icon) : Container(),
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
                      Text(
                        widget.summary,
                        style: Theme.of(context).textTheme.subtitle,
                      ),
                      Text(
                        widget.entries[widget.entryValues.indexOf(_value)],
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
