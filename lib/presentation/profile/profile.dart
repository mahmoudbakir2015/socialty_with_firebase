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

  const Profile({
    super.key,
    required this.uid,
  });

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String imgWall = '';
  String imgProfile = '';
  String name = '';
  List posts = [];
  @override
  void initState() {
    getPosts();
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .snapshots()
        .listen((event) {
      setState(() {});

      imgWall = event.get('imageWall').toString();
      imgProfile = event.get('imageProfile').toString();
      name = event.get('name').toString();
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
      posts = [];
      event.docs.forEach((element) {
        posts.add(element.data());
      });
    });
  }

  bool isTap = false;

  TextEditingController controllerName = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    controllerName.text = name;
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        SizedBox(
          height: 260,
          child: Stack(
            children: [
              Stack(
                children: [
                  buildCover(image: imgWall),
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: InkWell(
                      onTap: () {
                        buildBottomSheet(
                          context: context,
                          isAvatar: false,
                          uid: widget.uid,
                        );
                      },
                      child: const CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 20,
                        child: Icon(
                          Icons.add,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Stack(
                children: [
                  buildImgProfile(
                    context: context,
                    image: imgProfile,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: InkWell(
                      onTap: () {
                        buildBottomSheet(
                          context: context,
                          isAvatar: true,
                          uid: widget.uid,
                        );
                      },
                      child: const CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.black,
                        child: Icon(
                          Icons.add,
                        ),
                      ),
                    ),
                  ),
                ],
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
          name: name,
        ),
        buildMakePost(
          context: context,
          imgPic: imgProfile,
          uid: widget.uid,
          name: name,
        ),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (ctx, index) {
            return buildPostInfo(
              postWriter: name,
              time: posts[index]['date'],
              imgPic: imgProfile,
              isOnline: true,
              isTap: isTap,
              postText: posts[index]['text'],
              postImg:
                  (posts[index]['image'] == '') ? null : posts[index]['image'],
              numLike: posts[index]['numOfLike'],
              numComment: posts[index]['numOfComment'],
              numShare: posts[index]['numOfShare'],
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
          itemCount: posts.length,
        ),
      ],
    );
  }
}
