import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/Material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialty_with_firebase/business_logic/cubit/chat/chat_states.dart';
import 'package:socialty_with_firebase/data/model/message_model.dart';
import 'package:http/http.dart' as http;
import '../../../constants/constants.dart';
import '../../../shared/dio_helper.dart';

class ChatCubit extends Cubit<ChateStates> {
  ChatCubit()
      : super(
          InitialState(),
        );
  static ChatCubit get(context) => BlocProvider.of(context);

  void sendMessage(
      {required String recieverId,
      required String senderId,
      required String text,
      required String dateTime,
      required ScrollController scrollController}) {
    MessageModel model = MessageModel(
      dateTime: dateTime,
      receiverId: recieverId,
      senderId: senderId,
      text: text,
    );

    FirebaseFirestore.instance
        .collection('chats')
        .doc(senderId)
        .collection('chats')
        .doc(recieverId)
        .collection('messages')
        .add(
          model.toMap(),
        )
        .then(
          (value) => FirebaseFirestore.instance
              .collection('chats')
              .doc(recieverId)
              .collection('chats')
              .doc(senderId)
              .collection('messages')
              .add(
                model.toMap(),
              ),
        )
        .then((value) async {
      String title = '';
      String to = '';
      await FirebaseFirestore.instance
          .collection('users')
          .doc(senderId)
          .get()
          .then((DocumentSnapshot ds) {
        title = ds['name'];
      });
      log(title);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(recieverId)
          .get()
          .then((DocumentSnapshot ds) {
        to = ds['Fcm'];

        print(to);
      }).then(
        (value) async => await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'key=${Constants.serverToken}',
          },
          body: jsonEncode(
            <String, dynamic>{
              'notification': <String, dynamic>{
                'body': model.text.toString(),
                'title': title,
              },
              'priority': 'high',
              'data': <String, dynamic>{
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'id': '1',
                'status': 'done'
              },
              'to': to.toString(),
            },
          ),
        ),

        //     await DioHelper.postData(
        //   body: model.text.toString(),
        //   title: title.toString(),
        //   to: to.toString(),
        //   data: <String, dynamic>{
        //     'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        //     'id': '1',
        //     'status': 'done'
        //   },
        // ),
      );

      // await DioHelper.postData(
      //   body: model.text.toString(),
      //   title: title.toString(),
      //   to: to.toString(),
      //   data: <String, dynamic>{
      //     'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      //     'id': '1',
      //     'status': 'done'
      //   },
      // );
      scrollToBottom(
        scrollController: scrollController,
      );
      emit(
        SendMessageSuccessedState(),
      );
    }).catchError((error) {
      emit(SendMessageFailedState());
    });
  }

  List<MessageModel> message = [];
  void getMessages({
    required String senderId,
    required String recieverId,
  }) {
    FirebaseFirestore.instance
        .collection('chats')
        .doc(senderId)
        .collection('chats')
        .doc(recieverId)
        .collection('messages')
        .orderBy(
          'dateTime',
        )
        .snapshots()
        .listen((event) {
      message = [];
      event.docs.forEach((element) {
        message.add(
          MessageModel.fromJson(
            element.data(),
          ),
        );

        emit(GetMessageSuccessedState());
      });
    });
  }

  void scrollToBottom({required ScrollController scrollController}) {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
    emit(ScrollSuccessedState());
  }
}
