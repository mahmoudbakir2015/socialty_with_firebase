import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialty_with_firebase/constants/constants.dart';
import 'package:socialty_with_firebase/presentation/main_screen/main_screen.dart';

class MakePost extends StatefulWidget {
  final String uid;
  const MakePost({super.key, required this.uid});

  @override
  State<MakePost> createState() => _MakePostState();
}

class _MakePostState extends State<MakePost> {
  bool onTap = false;
  bool isImage = false;

  // void initState() {
  //   super.initState();
  //   showModalBottomSheet(
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(30.0),
  //     ),
  //     isScrollControlled: false,
  //     isDismissible: true,
  //     backgroundColor: Colors.white,
  //     context: context,
  //     builder: (context) =>
  //     DraggableScrollableSheet(
  //       initialChildSize: 0.4,
  //       minChildSize: 0.2,
  //       maxChildSize: 0.6,
  //       builder: (context, scrollController) {
  //         return SingleChildScrollView(
  //           controller: scrollController,
  //           child: Container(
  //             color: Colors.blue,
  //             height: 300,
  //             width: 200,
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    TextEditingController post = TextEditingController();
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
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(Constants.appPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  children: [
                    Text('Mahmoudbakir'),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                CircleAvatar(),
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
          Expanded(
            flex: 3,
            child: (isImage == true)
                ? const Image(
                    image: NetworkImage(''),
                  )
                : const Text(''),
          ),
          Expanded(
            flex: 1,
            child: Container(
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
          ),
        ],
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
