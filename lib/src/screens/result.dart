import 'package:environment_sensors/environment_sensors.dart';
import 'package:flutter/material.dart';
import 'package:mysensors/src/bloc/auth_bloc.dart';
import 'package:mysensors/src/styles/colors.dart';
import 'package:mysensors/src/styles/text.dart';
import 'package:mysensors/src/widgets/sensorTile.dart';
import 'package:provider/provider.dart';

class Result extends StatefulWidget {
  Result({Key key}) : super(key: key);

  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  bool _pressureAvailable = false;
  final environmentSensors = EnvironmentSensors();

  Future<void> initPlatformState() async {
    bool pressureAvailable;

    pressureAvailable =
        await environmentSensors.getSensorAvailable(SensorType.Pressure);

    setState(() {
      _pressureAvailable = pressureAvailable;
    });
  }

  @override
  void initState() {
    super.initState();
    environmentSensors.pressure.listen((pressure) {
      print(pressure.toString());
    });
    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);
    var logic = '''
    if( initialPressure - currentPressure >= difference)
    {
      Then -> Person is laying down
    }
    else
    {
      Person is doing someother activity
    }

                ''';

    //  String password;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Result',
          style: TextStyles.subtitle.copyWith(fontSize: 24),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
      ),
      body: (_pressureAvailable)
          ? ListView(
              children: [
                StreamBuilder<double>(
                    stream: environmentSensors.pressure,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return CircularProgressIndicator();
                      return SensorTile(
                          data:
                              'The Current Pressure is: ${snapshot.data.toStringAsFixed(4)}');
                    }),
                StreamBuilder<String>(
                  stream: authBloc.email,
                  initialData: "Checking for data",
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) return Text('Data Not available');
                    return Container(
                      child: SensorTile(
                          data: "Initial Pressure is: ${snapshot.data} mbar"),
                    );
                  },
                ),
                StreamBuilder<String>(
                  stream: authBloc.password,
                  initialData: "Checking for data",
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) return Text('Data Not available');
                    return Container(
                      child: SensorTile(
                          data: "Set Difference is: ${snapshot.data} mbar"),
                    );
                  },
                ),
                StreamBuilder<double>(
                  stream: environmentSensors.pressure,
                  initialData: 0.0,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) return Text('Data Not available');
                    var initPressure = double.parse(authBloc.initialPressure);
                    var difference = double.parse(authBloc.initialDifference);
                    var currentPressure =
                        double.parse(snapshot.data.toStringAsFixed(4));
                    if (initPressure - currentPressure >= difference)
                      return Container(
                        child: SensorTile(
                          data: "Laying Down detected",
                          present: false,
                        ),
                      );
                    return Container(
                      child: SensorTile(
                          data:
                              "Current Difference = ${initPressure - currentPressure} mbar"),
                    );
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                    child: Text("Logic",
                        style: TextStyles.title.copyWith(fontSize: 24))),
                SizedBox(
                  height: 30,
                ),
                Text(logic, style: TextStyles.body.copyWith(fontSize: 14))
              ],
            )
          : Center(
              child: Text(
                'Oops!No Pressure sensor found',
                style: TextStyles.listTitle.copyWith(
                  color: AppColors.red,
                ),
              ),
            ),
    );
  }
}
