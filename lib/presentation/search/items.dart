import 'package:flutter/material.dart';

import '../chat/chat_details/chat_details.dart';

// ignore: must_be_immutable
class SearchCard extends StatefulWidget {
  final String image;
  bool isFriend;
  final String uid;

  SearchCard({
    super.key,
    required this.image,
    this.isFriend = false,
    required this.uid,
  });

  @override
  State<SearchCard> createState() => _SearchCardState();
}

class _SearchCardState extends State<SearchCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Card(
        child: Row(
          children: [
            Expanded(
              child: Image(
                image: NetworkImage(
                  widget.image,
                ),
                fit: BoxFit.fitHeight,
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  FilledButton(
                    onPressed: () {
                      widget.isFriend = !widget.isFriend;
                      setState(() {});
                    },
                    child: Text(
                      widget.isFriend ? 'sended add' : 'Add Friend',
                    ),
                  ),
                  OutlinedButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ChatDetails(
                            uid: widget.uid,
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
