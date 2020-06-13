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
    //fk9wp2EiFXA:cuDlDPrwMuQ:APA91bHxIIawTNEQWS3k_zaFvNXVD35Y29aUoVPhVsicA06S_0Npb8w6Ca4yK4WMZcqh_ucQwQdg2SM5egu3aby6ChTIj1KqZCCwQX85v4IgOMM0HQaf6N3EedJvFyXDUQUg0p2_rYV4
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