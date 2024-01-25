import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:socialty_with_firebase/constants/constants.dart';
import 'package:socialty_with_firebase/presentation/chat/chat_details/chat_details.dart';
import 'package:socialty_with_firebase/widget/search.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String search = '';
  bool isAddFriend = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(Constants.appPadding),
        child: Column(
          children: [
            buildSearch(
              onChanged: (String value) {
                setState(() {});
                search = value.toString();
                log(search);
              },
            ),
            (search == '')
                ? const Center(
                    child: Text('Search to see ....'),
                  )
                : buildSearchedCard(
                    image: 'https://wallpapercave.com/wp/wp2568544.jpg',
                  )
          ],
        ),
      ),
    );
  }

  InkWell buildSearchedCard({
    required String image,
  }) {
    return InkWell(
      onTap: () {},
      child: Card(
        child: Row(
          children: [
            Expanded(
              child: Image(
                image: NetworkImage(
                  image,
                ),
                fit: BoxFit.fitHeight,
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  FilledButton(
                    onPressed: () {
                      isAddFriend = !isAddFriend;
                      setState(() {});
                    },
                    child: Text(
                      isAddFriend ? 'sended add' : 'Add Friend',
                    ),
                  ),
                  OutlinedButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ChatDetails(
                            uid: '78510',
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Chat',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
