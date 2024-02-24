import 'package:flutter/material.dart';
import 'package:socialty_with_firebase/constants/constants.dart';
import '../presentation/home/make_post/make_post.dart';

InkWell buildMakePost({
  required BuildContext context,
  required String uid,
  String imgPic = '',
  required String name,
}) {
  return InkWell(
    onTap: () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MakePost(
            uid: uid,
            name: name,
            image: imgPic,
          ),
        ),
      );
    },
    child: Container(
      color: Colors.red,
      child: ListTile(
        leading: const Icon(Icons.photo),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [Text('بم تفكر ؟')],
        ),
        trailing: CircleAvatar(
          backgroundImage: NetworkImage(
            (imgPic == '') ? Constants.imgProfile : imgPic,
          ),
        ),
      ),
    ),
  );
}
