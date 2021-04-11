import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysensors/src/bloc/auth_bloc.dart';
import 'package:mysensors/src/screens/result.dart';
import 'package:mysensors/src/screens/sensors.dart';
import 'package:mysensors/src/styles/text.dart';
import 'package:mysensors/src/widgets/buttons.dart';
import 'package:mysensors/src/widgets/textfield.dart';
import 'dart:io';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  StreamSubscription _userSubscription;
  StreamSubscription _errorMessageSubscription;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _userSubscription.cancel();
    _errorMessageSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);

    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        child: pageBody(context, authBloc),
      );
    } else {
      return Scaffold(
        body: pageBody(context, authBloc),
      );
    }
  }

  Widget pageBody(BuildContext context, AuthBloc authBloc) {
    return ListView(
      padding: EdgeInsets.all(0.0),
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * .2,
        
        ),
        Container(
          height: 200.0,
          alignment: Alignment.center,
          child: Text('Set Initial Barometer Reading', style: TextStyles.subtitle,),
        ),
        StreamBuilder<String>(
            stream: authBloc.email,
            builder: (context, snapshot) {
              return AppTextField(
                isIOS: Platform.isIOS,
                hintText: 'Pressure in Millibar',
                cupertinoIcon: CupertinoIcons.thermometer,
                materialIcon: Icons.thermostat_rounded,
                textInputType: TextInputType.number,
                errorText: snapshot.error,
                onChanged: authBloc.changeEmail,
              );
            }),
        StreamBuilder<String>(
            stream: authBloc.password,
            builder: (context, snapshot) {
              return AppTextField(
                isIOS: Platform.isIOS,
                hintText: 'Difference in Millibar',
                cupertinoIcon: CupertinoIcons.thermometer,
                materialIcon: Icons.arrow_downward_rounded,
                textInputType: TextInputType.number,
                errorText: snapshot.error,
                onChanged: authBloc.changePassword,
              );
            }),
        StreamBuilder<bool>(
            stream: authBloc.isValid,
            builder: (context, snapshot) {
              return AppButton(
                buttonText: 'Result',
                buttonType: (snapshot.data == true)
                    ? ButtonType.LightBlue
                    : ButtonType.Disabled,
                onPressed: () => Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Result())),
              );
            }),
        SizedBox(
          height: 16.0,
        ),
        AppButton(
          buttonText: 'All  Sensors',
          buttonType: ButtonType.Straw,
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => MySensor())),
        )
      ],
    );
  }
}
