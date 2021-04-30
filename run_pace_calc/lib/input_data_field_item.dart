import 'package:flutter/material.dart';

class InputDataFieldItem extends Container {
  final String title;
  final String unit;
  final TextField _textField;

  InputDataFieldItem(
    this.title,
    this.unit,
    this._textField,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 100,
        padding: EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            Text(title),
            Row(children: <Widget>[
              Flexible(
                child: _textField,
              ),
              Text(unit),
            ])
          ],
        ));
  }
}
