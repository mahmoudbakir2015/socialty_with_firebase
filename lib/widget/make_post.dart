import 'package:flutter/material.dart';

import '../presentation/home/make_post/make_post.dart';

InkWell buildMakePost({
  required BuildContext context,
  required String uid,
  required String imgPic,
  required String name,
}) {
  return InkWell(
    onTap: () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MakePost(
            uid: uid,
            name: name,
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
          backgroundImage: NetworkImage(imgPic),
        ),
      ),
    ),
  );
}
