import 'dart:async';
import 'package:flutter/services.dart';
import 'package:mysensors/src/models/application_user.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class AuthBloc {
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _user = BehaviorSubject<ApplicationUser>();
  final _state = BehaviorSubject<String>();
  final _errorMessage = BehaviorSubject<String>();


  //Get Data
  Stream<String> get email => _email.stream.transform(validateEmail);
  Stream<String> get password => _password.stream.transform(validatePassword);
  Stream<bool> get isValid =>
      CombineLatestStream.combine2(email, password, (email, password) => true);
  Stream<ApplicationUser> get user => _user.stream;
  Stream<String> get errorMessage => _errorMessage.stream;
  Stream<String> get state => _state.stream;
  String get initialPressure => _email.value.trim();
  String get initialDifference => _password.value.trim();
  //Set Data
  Function(String) get changeEmail => _email.sink.add;
  Function(String) get changePassword => _password.sink.add;
  Function(String) get changeState => _state.sink.add;

  dispose() {
    _email.close();
    _password.close();
    _user.close();
    _errorMessage.close();
    _state.close();
  }

  //Transformers
  final validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.length >= 1) {
      sink.add(email.trim());
    } else {
      sink.addError('Must Not be empty');
    }
  });

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length >= 1) {
      sink.add(password.trim());
    } else {
      sink.addError('Must not be empty');
    }
  });

  //Functions

  sumbitData() async {
    try {
      _state.sink.add('Laying');
    } on PlatformException catch (error) {
      print(error);
      _errorMessage.sink.add(error.message);
    }
  }

  clearErrorMessage() {
    _errorMessage.sink.add('');
  }
}
