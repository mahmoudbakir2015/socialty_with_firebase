import 'package:flutter/material.dart';
import 'package:socialty_with_firebase/constants/constants.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          width: double.infinity,
          height: 200,
          color: Colors.red,
          child: const Image(
            image: NetworkImage(
              Constants.imgTest,
            ),
          ),
        ),
      ],
    );
  }
}
