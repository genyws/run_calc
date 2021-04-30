import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'RunningData.dart';

class PaceItem extends Container {
  final String title;
  final String value;

  PaceItem(
    this.title,
    this.value,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            Text(
              title,
              style: TextStyle(fontSize: 15),
            ),
            Text(
              value,
            )
          ],
        ));
  }
}
