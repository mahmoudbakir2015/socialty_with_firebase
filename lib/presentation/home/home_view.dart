// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialty_with_firebase/constants/constants.dart';
import 'package:socialty_with_firebase/presentation/chat/chat_details/chat_details.dart';
import '../../widget/build_post.dart';
import '../../widget/make_post.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// ignore: must_be_immutable
class Home extends StatefulWidget {
  final String uid;

  Home({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String img = '';
  String name = '';
  @override
  void initState() {
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ChatDetails(
            uid: '123',
          ),
        ),
      );
    });

    getPosts();
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .snapshots()
        .listen((event) {
      setState(() {});
      img = event.get('imageProfile');
      name = event.get('name');
    });
    super.initState();
  }

  getPosts() async {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.uid)
        .collection('posts')
        .snapshots()
        .listen((event) {
      event.docs.forEach((element) {
        log(element.data().toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isTap = false;

    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        buildMakePost(
          context: context,
          imgPic: img,
          uid: widget.uid,
          name: name,
        ),
        const SizedBox(
          height: 10,
        ),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (ctx, index) {
            return buildPostInfo(
              postWriter: 'MahmoudBakir',
              time: '10 sec',
              imgPic: Constants.imgWall,
              isOnline: true,
              isTap: isTap,
              postText: null,
              postImg: null,
              numLike: '20',
              numComment: '30',
              numShare: '10',
              close: () {},
              option: () {},
              onLike: () {
                setState(() {});
                isTap = !isTap;
              },
              onComment: () {},
              onShare: () {},
            );
          },
          separatorBuilder: (ctx, index) {
            return const SizedBox(
              height: 5,
            );
          },
          itemCount: 10,
        ),
      ],
    );
  }
}
