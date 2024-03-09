import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../presentation/chat/chat_details/chat_details.dart';

// import '../presentation/chat/chat_details/chat_details.dart';
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log("Handling a background message: ${message.messageId}");
  String uid = message.data['uid'];
  log(uid);
  // Navigator.of(context as BuildContext).push(MaterialPageRoute(
  //   builder: (context) => ChatDetails(
  //     uid: uid,
  //   ),
  // ));
}

abstract class ConfigureMessage {
  static initFirebaseMessaging(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      String uid = message.data['uid'];
      log('========================');
      log(uid);
      log('==============onMessage=====================');
      //to make some thing when you opened app and use it in ui
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ChatDetails(
          uid: uid,
        ),
      ));
      // Here you can extract the notification data and navigate to the appropriate screen
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log("onMessageOpenedApp: $message");
      String uid = message.data['uid'];
      log('========================');
      log(uid);
      log('==============onMessageOpenedApp=====================');
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ChatDetails(
          uid: uid,
        ),
      ));
      // Here you can extract the notification data and navigate to the appropriate screen
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
}
