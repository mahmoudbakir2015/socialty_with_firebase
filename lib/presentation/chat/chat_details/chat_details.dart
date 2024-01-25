import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialty_with_firebase/business_logic/cubit/chat/chat_states.dart';
import 'package:socialty_with_firebase/constants/constants.dart';
import 'package:socialty_with_firebase/presentation/chat/chat_details/items.dart';
import 'package:socialty_with_firebase/shared/cache_helper.dart';
import '../../../business_logic/cubit/chat/chat_cubit.dart';

class ChatDetails extends StatefulWidget {
  final String uid;

  const ChatDetails({
    super.key,
    required this.uid,
  });

  @override
  State<ChatDetails> createState() => _ChatDetailsState();
}

class _ChatDetailsState extends State<ChatDetails> {
  TextEditingController sendMessages = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    BlocProvider.of<ChatCubit>(context).getMessages(
      senderId: CacheHelper.getData(key: 'token').toString(),
      recieverId: widget.uid,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ChatCubit cubit = ChatCubit.get(context);
    return BlocBuilder<ChatCubit, ChateStates>(
      builder: (context, state) {
        return Scaffold(
          appBar: buildAppBar(
            context: context,
          ),
          body: BlocBuilder<ChatCubit, ChateStates>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(Constants.appPadding),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          if (cubit.message.isNotEmpty) {
                            var message = cubit.message;
                            if (CacheHelper.getData(key: 'token').toString() ==
                                message[index].senderId) {
                              return buildSenderMessage(message[index]);
                            } else {
                              return buildRecievedMessage(
                                message[index],
                                img:
                                    'https://wallpapercave.com/wp/wp2568544.jpg',
                              );
                            }
                          }

                          return null;
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 10,
                          );
                        },
                        itemCount: cubit.message.length,
                      ),
                    ),
                    buildFooter(
                      context: context,
                      controller: sendMessages,
                      receiverId: widget.uid,
                      scrollController: scrollController,
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
