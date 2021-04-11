import 'package:flutter/material.dart';
import 'dart:async';
import 'package:environment_sensors/environment_sensors.dart';
import 'package:mysensors/src/styles/text.dart';
import 'package:mysensors/src/widgets/sensorTile.dart';

class MySensor extends StatefulWidget {
  @override
  _MySensorState createState() => _MySensorState();
}

class _MySensorState extends State<MySensor> {
  bool _tempAvailable = false;
  bool _humidityAvailable = false;
  bool _lightAvailable = false;
  bool _pressureAvailable = false;
  final environmentSensors = EnvironmentSensors();

  @override
  void initState() {
    super.initState();
    environmentSensors.pressure.listen((pressure) {
      print(pressure.toString());
    });
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    bool tempAvailable;
    bool humidityAvailable;
    bool lightAvailable;
    bool pressureAvailable;

    tempAvailable = await environmentSensors
        .getSensorAvailable(SensorType.AmbientTemperature);
    humidityAvailable =
        await environmentSensors.getSensorAvailable(SensorType.Humidity);
    lightAvailable =
        await environmentSensors.getSensorAvailable(SensorType.Light);
    pressureAvailable =
        await environmentSensors.getSensorAvailable(SensorType.Pressure);

    setState(() {
      _tempAvailable = tempAvailable;
      _humidityAvailable = humidityAvailable;
      _lightAvailable = lightAvailable;
      _pressureAvailable = pressureAvailable;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Relevant Sensors',
          style: TextStyles.listTitle,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          (_tempAvailable)
              ? StreamBuilder<double>(
                  stream: environmentSensors.humidity,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return CircularProgressIndicator();
                    return SensorTile(
                        data:
                            'The Current Humidity is: ${snapshot.data.toStringAsFixed(2)}%',);
                  },)
              : SensorTile(
                      data:'No relative humidity sensor found',present: false,),
          (_humidityAvailable)
              ? StreamBuilder<double>(
                  stream: environmentSensors.temperature,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return CircularProgressIndicator();
                    return SensorTile(
                      data:
                        'The Current Temperature is: ${snapshot.data.toStringAsFixed(2)}');
                  })
              : SensorTile(
                      data:'No temperature sensor found',present: false,),
          (_lightAvailable)
              ? StreamBuilder<double>(
                  stream: environmentSensors.light,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return CircularProgressIndicator();
                    return SensorTile(
                      data: 'The Current Light is: ${snapshot.data.toStringAsFixed(2)}',
                    );
                  })
              : SensorTile(
                      data:'No light sensor found',present: false,),
          (_pressureAvailable)
              ? StreamBuilder<double>(
                  stream: environmentSensors.pressure,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return CircularProgressIndicator();
                    return SensorTile(
                      data:
                        'The Current Pressure is: ${snapshot.data.toStringAsFixed(2)}');
                  })
              : SensorTile(
                      data:'No pressure sensure found',present: false,),
          //ElevatedButton(onPressed: initPlatformState , child: Text('Get'))
        ],
      ),
    );
  }
}


