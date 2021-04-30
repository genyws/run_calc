import 'package:flutter/material.dart';

class RunningData extends ChangeNotifier {
  double _speed;
  double _cadence;
  double _weight;
  double _ftp;
  double _distance;
  double _distIndex;
  List<double> dists = [
    30,
    50,
    100,
    200,
    400,
    800,
    1000,
    1600,
    2000,
    3000,
    5000
  ];

  RunningData() {
    initData();
  }

  void initData() {
    _speed = 8.0;
    _cadence = 160;
    _weight = 50;
    _ftp = 1.0;
    _distance = 100;
    _distIndex = 2;
  }

  double getSpeed() {
    print('get speed called return : ${_speed}');
    return _speed;
  }

  void setSpeed(double s) {
    _speed = s;
    _ftp = (_speed * 1.04) / 3.6;
    notifyListeners();
  }

  double getCadence() {
    return _cadence;
  }

  void setCadence(double c) {
    _cadence = c;
    print('cadence changed : $c');
    notifyListeners();
  }

  double getWeight() {
    if (_weight == null) {
      _weight = 60.0;
    }
    print('get weight called return : ${_weight}');
    return _weight;
  }

  void setWeight(double w) {
    _weight = w;
    print('weight changed : ${w}');
    notifyListeners();
  }

  double getFTP() {
    return _ftp;
  }

  void setFTP(double ftp) {
    _ftp = ftp;
    _speed = (_ftp * 3.6) / 1.04;
    if (_speed < 5) _speed = 5;
    if (_speed > 25) _speed = 25;
    notifyListeners();
  }

  void setDistance(double d) {
    _distance = d;
  }

  double getDistance() {
    return _distance;
  }

  void setDistIndex(double d) {
    _distIndex = d;
    _distance = dists.elementAt(d.toInt());
  }

  double getDistIndex() {
    return _distIndex;
  }
}
