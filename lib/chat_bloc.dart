import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class MessageBloc {
  String message;
  String deviceId;
  var currentTime;
  var _textController = StreamController<String>();
  var _timeController = StreamController<Timestamp>();

  Stream<String> get textStream {
    return _textController.stream;
  }

  Stream<String> get deviceIdStream {
    return _textController.stream;
  }

  Stream<Timestamp> get currentTimeStream{
    return _timeController.stream;
  }

  updateText(String text) {
    (text == null || text == "")
        ? _textController.sink.addError("Invalid value entered!")
        : _textController.sink.add(text);
    message = text;
  }

  updateDeviceid(String deviceid){
    _textController.sink.add(deviceid);
    deviceId = deviceid;
  }

  updateCurrentTime(var now){
    _timeController.sink.add(now);
    currentTime = now;
  }

  dispose() {
    _textController.close();
    _timeController.close();
  }
}
