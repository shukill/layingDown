import 'package:flutter/material.dart';
import 'package:mysensors/src/styles/text.dart';

class SensorTile extends StatelessWidget {
  SensorTile({
    Key key,
    @required this.data,
    this.present,
  }) : super(key: key);
  final String data;
  final bool present;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ListTile(
        title: Text(
          '$data',
          softWrap: true,
          textAlign: TextAlign.center,
          style:(present == false)?TextStyles.navTitle.copyWith(color: Colors.redAccent): TextStyles.link,
          textDirection: TextDirection.ltr,
        ),
      ),
    );
  }
}