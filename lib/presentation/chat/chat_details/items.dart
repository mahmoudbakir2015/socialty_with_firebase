import 'package:flutter/Material.dart';
import 'package:socialty_with_firebase/business_logic/cubit/chat/chat_cubit.dart';
import 'package:socialty_with_firebase/constants/constants.dart';
import 'package:socialty_with_firebase/shared/cache_helper.dart';

import '../../../data/model/message_model.dart';

buildAppBar({
  required BuildContext context,
}) {
  return AppBar(
    titleSpacing: 0,
    leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Color(0xff191919),
        ),
        onPressed: () {
          Navigator.pop(context);
        }),
    backgroundColor: Colors.white,
    elevation: 0,
    title: const Row(
      children: [
        CircleAvatar(
          backgroundImage:
              NetworkImage('https://wallpapercave.com/wp/wp2568544.jpg'),
        ),
        Padding(
          padding: EdgeInsets.only(left: 8),
          child: Text(
            'name',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    ),
  );
}

buildRecievedMessage(MessageModel messageModel, {required String img}) {
  return Row(
    children: [
      const CircleAvatar(
        radius: 15,
        backgroundImage:
            NetworkImage('https://wallpapercave.com/wp/wp2568544.jpg'),
      ),
      const SizedBox(
        width: 10,
      ),
      Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: const BorderRadiusDirectional.only(
                    topEnd: Radius.circular(
                      Constants.appPadding,
                    ),
                    topStart: Radius.circular(
                      Constants.appPadding,
                    ),
                    bottomEnd: Radius.circular(
                      Constants.appPadding,
                    ),
                  ),
                ),
                child: Text(
                  messageModel.text!,
                  // style: MyTextStyle.tM14,
                ),
              ),
            ),
            Text(
              messageModel.dateTime!,
              // style: MyTextStyle.tR10,
            ),
          ],
        ),
      ),
    ],
  );
}

buildSenderMessage(MessageModel messageModel) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      Align(
        alignment: Alignment.centerRight,
        child: Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: Colors.indigo[300],
            borderRadius: const BorderRadiusDirectional.only(
              topEnd: Radius.circular(
                Constants.appPadding,
              ),
              topStart: Radius.circular(
                Constants.appPadding,
              ),
              bottomStart: Radius.circular(
                Constants.appPadding,
              ),
            ),
          ),
          child: Text(
            messageModel.text!,
            // style: MyTextStyle.tM14.copyWith(
            //   color: Colors.white,
            // ),
          ),
        ),
      ),
      Text(messageModel.dateTime
              .toString()
              .characters
              .take(16)
              .toString()
              .replaceAll(' ', ' ,Time:')

          // style: MyTextStyle.tR10,
          ),
    ],
  );
}

buildFooter(
    {required String receiverId,
    required BuildContext context,
    required TextEditingController controller,
    required ScrollController scrollController}) {
  return Container(
    clipBehavior: Clip.antiAliasWithSaveLayer,
    height: 40,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(Constants.appPadding),
    ),
    child: Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: controller,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(10),
              border: OutlineInputBorder(),
              hintText: "Write Your message",
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        InkWell(
          onTap: () {
            if (controller.text != '') {
              ChatCubit.get(context).sendMessage(
                text: controller.text,
                recieverId: receiverId,
                senderId: CacheHelper.getData(key: 'token').toString(),
                dateTime: DateTime.now().toString(),
                scrollController: scrollController,
                // receiverId: receiverId,
              );

              controller.text = '';
            }
          },
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(Constants.appPadding),
            ),
            child: const Icon(
              Icons.send,
              size: 20,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
  );
}
