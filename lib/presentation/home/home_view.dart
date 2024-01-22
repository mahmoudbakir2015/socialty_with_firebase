import 'package:flutter/material.dart';
import 'package:socialty_with_firebase/presentation/home/make_post/make_post.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        buildMakePost(
          context: context,
          imgPic: '',
        ),
        const SizedBox(
          height: 10,
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.close),
                    const SizedBox(
                      width: 20,
                    ),
                    const Icon(Icons.list),
                    const Spacer(),
                    buildOwnerPost(
                      name: 'MahmoudBakir',
                      time: '12 hours',
                      imgPic: '',
                      status: false,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                  ),
                  child: buildPostContent(
                    text: null,
                    image: null,
                  ),
                ),
                buildNumOfLike(
                  like: '20',
                  comment: '40',
                  share: '5',
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildPostButton(
                      name: 'مشاركة',
                      icon: Icons.share,
                      onTap: () {},
                    ),
                    buildPostButton(
                      name: 'تعليق',
                      icon: Icons.comment,
                      onTap: () {},
                    ),
                    buildPostButton(
                      name: 'اعجبني',
                      icon: Icons.favorite,
                      onTap: () {},
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  InkWell buildPostButton({
    required String name,
    required IconData icon,
    required Function()? onTap,
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
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Row buildNumOfLike({
    required String like,
    required String comment,
    required String share,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          textDirection: TextDirection.rtl,
          '$comment تعليقا' ' ' '$share مشاركة',
        ),
        Text('🌝 $like')
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
    required String imgPic,
  }) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const MakePost(),
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
}
