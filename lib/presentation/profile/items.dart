import 'package:flutter/material.dart';

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
            image,
          ),
        ),
      ),
    ),
  );
}

InkWell buildCover() {
  return InkWell(
    onTap: () {},
    child: Container(
      width: double.infinity,
      height: 200,
      color: Colors.red,
      child: const Image(
        fit: BoxFit.cover,
        image: NetworkImage(
          Constants.imgWall,
        ),
      ),
    ),
  );
}
