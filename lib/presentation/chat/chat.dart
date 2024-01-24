import 'package:flutter/material.dart';
import 'package:socialty_with_firebase/constants/constants.dart';
import 'package:socialty_with_firebase/presentation/chat/chat_details/chat_details.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    String searched = '';
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.all(Constants.appPadding),
          child: TextFormField(
            onChanged: (String? value) {
              searched = value.toString();
              print(searched);
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  Constants.appPadding,
                ),
              ),
            ),
          ),
        ),
        (searched == '')
            ? ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (ctx, index) {
                  return buildchatCircle(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ChatDetails(
                            uid: '1234',
                          ),
                        ),
                      );
                    },
                    image: 'https://wallpapercave.com/wp/wp2568544.jpg',
                    name: 'mahmoudbakir',
                    lastMessage: 'hello',
                  );
                },
                separatorBuilder: (ctx, index) {
                  return const SizedBox(
                    height: 20,
                  );
                },
                itemCount: 10,
              )
            : ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (ctx, index) {
                  return buildchatCircle(
                    image: 'https://wallpapercave.com/wp/wp2568544.jpg',
                    name: 'mahmoudbakir',
                    lastMessage: 'hello',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ChatDetails(
                            uid: '1234',
                          ),
                        ),
                      );
                    },
                  );
                },
                separatorBuilder: (ctx, index) {
                  return const SizedBox(
                    height: 20,
                  );
                },
                itemCount: 1,
              ),
      ],
    );
  }

  ListTile buildchatCircle({
    required String image,
    required String name,
    required String lastMessage,
    required Function()? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(
          image,
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name),
          Text(
            lastMessage,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
