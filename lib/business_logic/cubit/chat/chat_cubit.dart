import 'package:flutter/Material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialty_with_firebase/business_logic/cubit/chat/chat_states.dart';
import 'package:socialty_with_firebase/data/model/message_model.dart';

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
        .then((value) {
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
