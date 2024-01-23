import 'package:flutter/material.dart';
import 'package:socialty_with_firebase/presentation/home/make_post/make_post.dart';

Card buildPostInfo({
  required String postWriter,
  required String time,
  required String imgPic,
  required bool isOnline,
  bool isTap = false,
  required Function()? close,
  required Function()? option,
  required Function()? onLike,
  required Function()? onComment,
  required Function()? onShare,
  String? postText,
  String? postImg,
  String? numLike = '0',
  String? numComment = '0',
  String? numShare = '0',
}) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: close,
                child: const Icon(
                  Icons.close,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              GestureDetector(
                onTap: option,
                child: const Icon(
                  Icons.list,
                ),
              ),
              const Spacer(),
              buildOwnerPost(
                name: postWriter,
                time: time,
                imgPic: imgPic,
                status: isOnline,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
            ),
            child: buildPostContent(
              text: postText,
              image: postImg,
            ),
          ),
          buildNumOfLike(
            like: numLike,
            comment: numComment,
            share: numShare,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildPostButton(
                  name: 'مشاركة',
                  icon: Icons.share,
                  onTap: onShare,
                ),
                buildPostButton(
                  name: 'تعليق',
                  icon: Icons.comment,
                  onTap: onComment,
                ),
                buildPostButton(
                  isTap: isTap,
                  name: 'اعجبني',
                  icon: Icons.favorite,
                  onTap: onLike,
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}

InkWell buildPostButton({
  required String name,
  required IconData icon,
  required Function()? onTap,
  bool isTap = false,
}) {
  return InkWell(
    onTap: onTap,
    child: Row(
      children: [
        Text(
          name,
        ),
        const SizedBox(
          width: 3,
        ),
        Icon(
          icon,
          color: isTap ? Colors.red : Colors.grey,
        ),
      ],
    ),
  );
}

Row buildNumOfLike({
  String? like,
  String? comment,
  String? share,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        textDirection: TextDirection.rtl,
        '$comment تعليقا' ' ' '$share مشاركة',
      ),
      Text('❤ $like')
    ],
  );
}

Column buildPostContent({
  String? text,
  String? image,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      (text != null) ? Text(text) : const Text(''),
      (image != null)
          ? Image(
              image: NetworkImage(image),
            )
          : const Text(''),
    ],
  );
}

Row buildOwnerPost({
  required String name,
  required String time,
  required String imgPic,
  required bool status,
}) {
  return Row(
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            time,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
      const SizedBox(
        width: 5,
      ),
      Stack(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(imgPic),
          ),
          if (status == true)
            const Positioned(
              bottom: 0,
              left: 0,
              child: CircleAvatar(
                radius: 7,
                backgroundColor: Colors.green,
              ),
            ),
        ],
      ),
    ],
  );
}

InkWell buildMakePost({
  required BuildContext context,
  required String uid,
  required String imgPic,
}) {
  return InkWell(
    onTap: () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MakePost(
            uid: uid,
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
