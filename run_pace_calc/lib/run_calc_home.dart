import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:run_pace_calc/data_field_item.dart';
import 'package:run_pace_calc/pace_item.dart';

import 'RunningData.dart';
import 'input_data_field_item.dart';

class RunCalcHome extends StatefulWidget {
  @override
  _RunCalcHomeState createState() => _RunCalcHomeState();
}

class _RunCalcHomeState extends State<RunCalcHome> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    var providerListen = Provider.of<RunningData>(context, listen: true);
    var providerNotListen = Provider.of<RunningData>(context, listen: false);
    var weightField = InputDataFieldItem(
        'Weight',
        'kg',
        TextField(
          keyboardType: TextInputType.number,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          onSubmitted: (newValue) {
            providerNotListen.setWeight(double.parse(newValue));
          },
        ));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Running Calculator'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(height: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              DataFieldItem('SPEED',
                  providerListen.getSpeed().toStringAsFixed(1), ' km/h'),
              DataFieldItem('PACE',
                  convertSpeedToPace(providerListen.getSpeed()), '/ km'),
            ],
          ),
          Slider(
            min: 5,
            max: 25,
            divisions: 200,
            value: providerNotListen.getSpeed(),
            onChanged: (double newValue) {
              setState(() {
                providerNotListen.setSpeed(newValue);
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              DataFieldItem('Cadence',
                  providerListen.getCadence().toInt().toString(), ' steps'),
              DataFieldItem(
                  'Stride',
                  measureStrideBySpeedAndCadence(
                      providerListen.getSpeed(), providerListen.getCadence()),
                  ' meter'),
            ],
          ),
          Slider(
            min: 100,
            max: 250,
            divisions: 150,
            value: providerNotListen.getCadence(),
            onChanged: (double newValue) {
              setState(() {
                Provider.of<RunningData>(context, listen: false)
                    .setCadence(newValue);
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              weightField,
              DataFieldItem(
                  'Power',
                  measurePowerBySpeedWeight(
                      Provider.of<RunningData>(context, listen: true)
                          .getSpeed(),
                      Provider.of<RunningData>(context, listen: true)
                          .getWeight()),
                  ' Watts'),
              DataFieldItem(
                  'FTP',
                  Provider.of<RunningData>(context, listen: true)
                      .getFTP()
                      .toStringAsFixed(1),
                  ' W/kg'),
            ],
          ),
          Slider(
            min: 0.1,
            max: 10.0,
            value: providerNotListen.getFTP(),
            onChanged: (double newValue) {
              print('ftp slide changed $newValue');
              setState(() {
                Provider.of<RunningData>(context, listen: false)
                    .setFTP(newValue);
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              DataFieldItem('Distance',
                  providerListen.getDistance().toInt().toString(), 'meter'),
              DataFieldItem(
                  'Time(sec)',
                  getSecondsPerDistance(providerNotListen.getSpeed(),
                      providerNotListen.getDistance()),
                  ' sec'),
              DataFieldItem(
                  'Steps',
                  calculateSteps(
                      providerNotListen.getSpeed(),
                      providerNotListen.getCadence(),
                      providerNotListen.getDistance()),
                  ' steps'),
            ],
          ),
          Slider(
            min: 0,
            max: 10,
            divisions: 10,
            value: providerNotListen.getDistIndex() as double,
            onChanged: (double newValue) {
              print('distance slide changed $newValue');
              setState(() {
                Provider.of<RunningData>(context, listen: false)
                    .setDistIndex(newValue);
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              PaceItem('1Km', calcTimeDistance(providerListen.getSpeed(), 1)),
              PaceItem('3Km', calcTimeDistance(providerListen.getSpeed(), 3)),
              PaceItem('5Km', calcTimeDistance(providerListen.getSpeed(), 5)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              PaceItem('10Km', calcTimeDistance(providerListen.getSpeed(), 10)),
              PaceItem('20Km', calcTimeDistance(providerListen.getSpeed(), 20)),
              PaceItem(
                  'Full', calcTimeDistance(providerListen.getSpeed(), 42.195)),
            ],
          )
        ],
      ),
    );
  }

  String convertSpeedToPace(double speed) {
    int sec = (3600 / speed).toInt();
    int min = (sec / 60).floor();
    int seconds = (sec % 60).toInt();
    return '${min < 10 ? '0' : ''}${min}:${seconds < 10 ? '0' : ''}${seconds}';
    // return '${(sec / 60).floor()}:${(sec % 60).toInt()}';
  }

  String measureStrideBySpeedAndCadence(double speed, double cadence) {
    return ((speed * 1000) / (60 * cadence)).toStringAsFixed(2);
  }

  String measurePowerBySpeedWeight(double speed, double weight) {
    return ((1.04 * speed * 1000 * weight) / 3600).toStringAsFixed(1);
  }

  String getSecondsPerDistance(double speed, distance) {
    return ((distance * 3.6) / speed).toStringAsFixed(0);
  }

  String calculateSteps(double speed, double cadence, double distance) {
    int sec = (3600 / speed).toInt();
    double period = (distance * 3.6) / speed;
    int step = ((period / 60) * cadence).toInt();

    return step.toString();
  }

  String calcTimeDistance(double speed, double i) {
    int time_sec = ((3600 / speed) * i).toInt();
    int hour = (time_sec / 3600).toInt();
    int hourRe = time_sec % 3600;
    int min = (hourRe / 60).toInt();
    int sec = hourRe % 60;
    return '${hour == 0 ? '0' : hour.toString()}:${min < 10 ? '0' : ''}${min.toString()}:${sec < 10 ? '0' : ''}$sec';
  }
}
