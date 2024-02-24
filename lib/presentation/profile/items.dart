import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../../constants/constants.dart';

Padding buildName({required String name, void Function()? onTap}) {
  return Padding(
    padding: const EdgeInsets.symmetric(
      vertical: 8.0,
    ),
    child: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          InkWell(
            onTap: onTap,
            child: const Icon(
              Icons.edit,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    ),
  );
}

Positioned buildImgProfile(
    {required BuildContext context, required String image}) {
  return Positioned(
    top: 140,
    left: MediaQuery.of(context).size.width / 2 - 60,
    child: CircleAvatar(
      radius: 60,
      child: ClipOval(
        child: Image(
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
          image: NetworkImage(
            (image == '') ? Constants.imgProfile : image,
          ),
        ),
      ),
    ),
  );
}

InkWell buildCover({required String image}) {
  return InkWell(
    onTap: () {},
    child: Container(
      width: double.infinity,
      height: 200,
      color: Colors.red,
      child: Image(
        fit: BoxFit.cover,
        image: NetworkImage(
          (image == '') ? Constants.imgWall : image,
        ),
      ),
    ),
  );
}

abstract class UploadImageInStorage {
  static File? file;
  static var imagePicker = ImagePicker();
  static saveImageToStorage({
    required bool isAvatar,
    required String imagePath,
    required String uid,
  }) async {
    if (isAvatar == true) {
      //save in file profile in storage
      var refStorage = FirebaseStorage.instance
          .ref('images')
          .child('avatar')
          .child(imagePath);
      await refStorage.putFile(file!);
      var url = await refStorage.getDownloadURL();
      //update in image profile in firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'imageProfile': url,
      });
    } else {
      //save in file wall
      var refStorage =
          FirebaseStorage.instance.ref('images').child('wall').child(imagePath);
      await refStorage.putFile(file!);
      var url = await refStorage.getDownloadURL();
      //update in image wall in firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'imageWall': url,
      });
    }
  }

  static uploadImage(
      {required bool isCamera,
      required bool isAvatar,
      required String uid}) async {
    if (isCamera == true) {
      var imagePicked = await imagePicker.pickImage(source: ImageSource.camera);
      if (imagePicked != null) {
        file = File(imagePicked.path);

        var nameImage = basename(imagePicked.path);

        // start upload
        saveImageToStorage(
          isAvatar: isAvatar,
          imagePath: nameImage,
          uid: uid,
        );

        //end upload
      } else {}
    } else {
      var imagePicked =
          await imagePicker.pickImage(source: ImageSource.gallery);
      if (imagePicked != null) {
        file = File(imagePicked.path);

        var nameImage = basename(imagePicked.path);

        var random = Random().nextInt(100000000);
        nameImage = '$random$nameImage';
        // start upload
        saveImageToStorage(
          isAvatar: isAvatar,
          imagePath: nameImage,
          uid: uid,
        );

        //end upload
      } else {}
    }
  }
}

Future<dynamic> buildBottomSheet({
  required BuildContext context,
  required bool isAvatar,
  required String uid,
}) {
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
                  UploadImageInStorage.uploadImage(
                    isCamera: true,
                    isAvatar: isAvatar,
                    uid: uid,
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
                  UploadImageInStorage.uploadImage(
                    isCamera: false,
                    isAvatar: isAvatar,
                    uid: uid,
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
