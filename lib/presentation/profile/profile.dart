import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialty_with_firebase/constants/constants.dart';
import 'package:socialty_with_firebase/presentation/profile/items.dart';
import '../../widget/build_post.dart';
import '../../widget/default_text_form.dart';
import '../../widget/make_post.dart';

// ignore: must_be_immutable
class Profile extends StatefulWidget {
  final String uid;
  String img = '';
  String name = '';
  List posts = [];
  Profile({
    super.key,
    required this.uid,
  });

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    getPosts();
    FirebaseFirestore.instance.collection('users').snapshots().listen((event) {
      event.docs.forEach((element) {
        setState(() {});
        widget.img = element.data()['imgPic'].toString();
        widget.name = element.data()['name'].toString();
      });
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
      widget.posts = [];
      event.docs.forEach((element) {
        widget.posts.add(element.data());
      });
    });
  }

  bool isTap = false;
  TextEditingController controllerName = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    controllerName.text = widget.name;
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        SizedBox(
          height: 260,
          child: Stack(
            children: [
              buildCover(),
              buildImgProfile(
                context: context,
                image: widget.img,
              ),
            ],
          ),
        ),
        buildName(
          onTap: () {
            showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Scaffold(
                    body: Padding(
                      padding: const EdgeInsets.all(
                        Constants.appPadding,
                      ),
                      child: Form(
                        key: formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              defaultTextForm(
                                label: 'Name',
                                controller: controllerName,
                                textInputType: TextInputType.name,
                                iconData: Icons.abc_sharp,
                                onValidate: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'Should not be empty';
                                  }
                                  if (value.toString().length < 3) {
                                    return 'Should be greater than 2 char';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                height: 50,
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(widget.uid)
                                          .update(
                                        {
                                          'name': controllerName.text,
                                        },
                                      ).then(
                                        (value) => Navigator.of(context).pop(),
                                      );
                                    }
                                  },
                                  child: const Text(
                                    'change',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                });
          },
          name: widget.name,
        ),
        buildMakePost(
          context: context,
          imgPic: widget.img,
          uid: widget.uid,
          name: widget.name,
        ),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (ctx, index) {
            return buildPostInfo(
              postWriter: widget.name,
              time: widget.posts[index]['date'],
              imgPic: widget.img,
              isOnline: true,
              isTap: isTap,
              postText: widget.posts[index]['text'],
              postImg: (widget.posts[index]['image'] == '')
                  ? null
                  : widget.posts[index]['image'],
              numLike: widget.posts[index]['numOfLike'],
              numComment: widget.posts[index]['numOfComment'],
              numShare: widget.posts[index]['numOfShare'],
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
          itemCount: widget.posts.length,
        ),
      ],
    );
  }
}
