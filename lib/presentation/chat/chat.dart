import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialty_with_firebase/constants/constants.dart';
import 'package:socialty_with_firebase/presentation/chat/chat_details/chat_details.dart';
import 'package:socialty_with_firebase/presentation/chat/items.dart';
import 'package:socialty_with_firebase/shared/cache_helper.dart';
import '../../widget/search.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  String searched = '';
  List data = [];
  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('chats')
        .doc(CacheHelper.getData(key: 'token').toString())
        .collection('chats')
        // .doc('JE7wbsOTZEWvr5UyvxFUfc6jbLH3')
        // .collection('messages')
        // .get()
        .get()
        .then((value) {
      List<Map<String, dynamic>> dataList =
          value.docs.map((doc) => doc.data()).toList();
      String jsonString = json.encode(dataList).toString();
      data.add(jsonString);
      log(data.toString());
    });

    log(CacheHelper.getData(key: 'token').toString());
    log(data.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        buildSearch(onChanged: (String value) {
          setState(() {});
          searched = value.toString();
        }),
        (searched == '')
            ? ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (ctx, index) {
                  return buildchatCircle(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ChatDetails(
                            uid: '1234',
                          ),
                        ),
                      );
                    },
                    image: Constants.imgTest,
                    name: 'mahmoudbakir',
                    lastMessage: 'hello',
                  );
                },
                separatorBuilder: (ctx, index) {
                  return const SizedBox(
                    height: 5,
                  );
                },
                itemCount: 1,
              )
            : ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (ctx, index) {
                  return buildchatCircle(
                    image: Constants.imgTest,
                    name: 'mahmoudbakir',
                    lastMessage: 'hello',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ChatDetails(
                            uid: '1234',
                          ),
                        ),
                      );
                    },
                  );
                },
                separatorBuilder: (ctx, index) {
                  return const SizedBox(
                    height: 20,
                  );
                },
                itemCount: 2,
              ),
      ],
    );
  }
}
