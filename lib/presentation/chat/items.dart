import 'package:flutter/material.dart';

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
