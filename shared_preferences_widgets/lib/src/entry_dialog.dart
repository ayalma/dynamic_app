import 'package:flutter/material.dart';

typedef OnValueChange = void Function(dynamic value);

class EntryDialog<T> extends StatefulWidget {
  final List<String> entries;
  final List<T> entryValues;
  final int selected;
  final String dialogTitle;
  final OnValueChange onValueChange;

  const EntryDialog(
      {Key key,
      this.entries,
      this.entryValues,
      this.selected,
      this.dialogTitle,
      this.onValueChange})
      : super(key: key);

  @override
  _EntryDialogState createState() => _EntryDialogState();
}

class _EntryDialogState extends State<EntryDialog> {
  int _selected;

  @override
  void initState() {
    _selected = widget.selected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(widget.dialogTitle),
      children: widget.entries.map((entry) {
        print(widget.entries.indexOf(entry) == _selected);
        return Container(
          child: InkWell(
            onTap: () {
              setState(() {
                _selected = widget.entries.indexOf(entry);
              });
              if (widget.onValueChange != null) {
                widget.onValueChange(widget.entryValues[_selected]);
              }
            },
            child: ListTile(
              leading: Radio(
                value: widget.entries.indexOf(entry) == _selected,
                groupValue: true,
                onChanged: (_) {},
              ),
              title: Text(entry),
            ),
          ),
        );
      }).toList()
        ..add(
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('ok'),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
