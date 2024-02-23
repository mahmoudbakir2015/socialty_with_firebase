import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:socialty_with_firebase/constants/constants.dart';
import 'package:socialty_with_firebase/presentation/profile/items.dart';
import '../../widget/build_post.dart';
import '../../widget/default_text_form.dart';
import '../../widget/make_post.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class Profile extends StatefulWidget {
  final String uid;
  String? imgWall;
  String? imgProfile;
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
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .snapshots()
        .listen((event) {
      setState(() {});

      widget.imgWall = event.get('imageWall').toString();
      widget.imgProfile = event.get('imageProfile').toString();
      widget.name = event.get('name').toString();
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
  File? file;

  var imagePicker = ImagePicker();
  saveImageToStorage(
      {required bool isAvatar, required String imagePath}) async {
    if (isAvatar == true) {
      var refStorage = FirebaseStorage.instance
          .ref('images')
          .child('avatar')
          .child(imagePath);
      await refStorage.putFile(file!);
      var url = await refStorage.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .update({
        'imageProfile': url,
      });
      // log(url.toString());
    } else {
      var refStorage =
          FirebaseStorage.instance.ref('images').child('wall').child(imagePath);
      await refStorage.putFile(file!);
      var url = await refStorage.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .update({
        'imageWall': url,
      });
      // log(url.toString());
    }
  }

  uploadImage({required bool isCamera, required bool isAvatar}) async {
    if (isCamera == true) {
      var imagePicked = await imagePicker.pickImage(source: ImageSource.camera);
      if (imagePicked != null) {
        file = File(imagePicked.path);
        // log(imagePicked.path);
        var nameImage = basename(imagePicked.path);
        // log(nameImage);
        // start upload
        saveImageToStorage(isAvatar: isAvatar, imagePath: nameImage);

        //end upload
      } else {}
    } else {
      var imagePicked =
          await imagePicker.pickImage(source: ImageSource.gallery);
      if (imagePicked != null) {
        file = File(imagePicked.path);
        // log(imagePicked.path);
        var nameImage = basename(imagePicked.path);
        // log(nameImage);
        var random = Random().nextInt(100000000);
        nameImage = '$random$nameImage';
        // start upload
        saveImageToStorage(isAvatar: isAvatar, imagePath: nameImage);

        //end upload
      } else {}
    }
  }

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
              Stack(
                children: [
                  buildCover(image: widget.imgWall),
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: InkWell(
                      onTap: () {
                        buildBottomSheet(context: context, isAvatar: false);
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
                    image: widget.imgProfile,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: InkWell(
                      onTap: () {
                        buildBottomSheet(context: context, isAvatar: true);
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
          name: widget.name,
        ),
        buildMakePost(
          context: context,
          imgPic: widget.imgProfile,
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
              imgPic: widget.imgProfile,
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

  Future<dynamic> buildBottomSheet(
      {required BuildContext context, required bool isAvatar}) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    uploadImage(
                      isAvatar: isAvatar,
                      isCamera: true,
                    );
                  },
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.camera),
                      Text('camera'),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    uploadImage(
                      isAvatar: isAvatar,
                      isCamera: false,
                    );
                  },
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.image),
                      Text('gallery'),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
