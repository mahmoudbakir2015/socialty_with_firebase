// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:socialty_with_firebase/presentation/home/items.dart';

// ignore: must_be_immutable
class Home extends StatefulWidget {
  final String uid;
  String img = '';
  Home({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    getPosts();
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .get()
        .then((value) {
      setState(() {});

      widget.img = value.data()!['imgPic'].toString();
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
          imgPic: widget.img,
          uid: widget.uid,
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
              imgPic: 'https://wallpapercave.com/wp/wp2568544.jpg',
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
