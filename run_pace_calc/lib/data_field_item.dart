import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'RunningData.dart';

class DataFieldItem extends Container {
  final String title;
  final String value;
  final String unit;

  DataFieldItem(
    this.title,
    this.value,
    this.unit,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
        // padding: EdgeInsets.all(15),
        child: Column(
      children: <Widget>[
        Text(
          title,
          style: TextStyle(fontSize: 15),
        ),
        Row(children: <Widget>[
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
          ),
          Text(
            unit,
            style: TextStyle(fontSize: 14),
          ),
        ])
      ],
    ));
  }
}
