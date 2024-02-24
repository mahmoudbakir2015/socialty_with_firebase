import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialty_with_firebase/constants/constants.dart';
import 'package:socialty_with_firebase/presentation/main_screen/main_screen.dart';

class MakePost extends StatefulWidget {
  final String uid;
  final String name;
  final String image;
  const MakePost({
    super.key,
    required this.uid,
    required this.name,
    required this.image,
  });

  @override
  State<MakePost> createState() => _MakePostState();
}

class _MakePostState extends State<MakePost> {
  bool onTap = false;
  bool isImage = false;
  TextEditingController post = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          onPressed: () {
            if (post.text != '') {
              FirebaseFirestore.instance
                  .collection('posts')
                  .doc(widget.uid)
                  .collection('posts')
                  .add({
                'text': post.text,
                'date': '10/12/2022',
                'image': '',
                'numOfLike': '0',
                'numOfComment': '0',
                'numOfShare': '0',
              }).then(
                (value) => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => MainScreen(
                      uid: widget.uid,
                    ),
                  ),
                  (route) => false,
                ),
              );
            }
          },
          child: const Text(
            'التالي',
          ),
        ),
        title: const Text('انشاء منشور'),
        actions: [
          Center(
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => MainScreen(
                      uid: widget.uid,
                    ),
                  ),
                  (route) => false,
                );
              },
              icon: const Icon(
                Icons.close,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(Constants.appPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      Text(widget.name),
                    ],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.image),
                  ),
                ],
              ),
            ),
            TextFormField(
              onTap: () {
                onTap = true;
                setState(() {});
              },
              onTapOutside: (PointerDownEvent v) {
                onTap = false;
                setState(() {});
              },
              controller: post,
              textDirection: TextDirection.rtl,
              autofocus: true,
              maxLines: 15,
              decoration: const InputDecoration(
                enabledBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: 'بم تفكر ؟',
              ),
            ),
            (isImage == true)
                ? const Image(
                    image: NetworkImage(''),
                  )
                : const Text(''),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(Constants.appPadding),
                  topRight: Radius.circular(Constants.appPadding),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildIcon(
                    onTap: () {},
                    icon: Icons.image,
                  ),
                  buildIcon(
                    onTap: () {},
                    icon: Icons.camera,
                  ),
                  buildIcon(
                    onTap: () {},
                    icon: Icons.image,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding buildIcon({
    required Function() onTap,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.all(Constants.appPadding),
      child: InkWell(
        onTap: onTap,
        child: Icon(
          icon,
        ),
      ),
    );
  }
}
