import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';


class PushNotificationProvider {

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  final _mensajesStreamController = StreamController<String>.broadcast();
  Stream<String> get mensajes => _mensajesStreamController.stream;

  initNotifications() async {

    _firebaseMessaging.requestNotificationPermissions();

    List<String> tokenList = new List();
    String token = await _firebaseMessaging.getToken();
    print(token);
    //comprobe token

    tokenList.add(token);
    print(tokenList);

    _firebaseMessaging.configure(

      onMessage: (info) async {
        print('======== On Message =======');
        print(info);

        String argumento = 'no-data';
        if(Platform.isAndroid) {
          argumento = info['data']['comida'] ?? 'no-data';
        }

        _mensajesStreamController.sink.add(argumento);
      },

      onLaunch: (info) async {
        print('======== On Message =======');
        print(info);
      },

       onResume: (info) async {
        print('======== On Resume =======');
        print(info);

        final noti = info['data']['comida'];
        _mensajesStreamController.sink.add(noti);
      }

    );

  }

  dispose() {
    _mensajesStreamController?.close();
  }

}