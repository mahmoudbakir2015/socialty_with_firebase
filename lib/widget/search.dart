import 'package:flutter/Material.dart';

import '../constants/constants.dart';

buildSearch({required Function(String)? onChanged}) {
  return Padding(
    padding: const EdgeInsets.all(Constants.appPadding),
    child: TextFormField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Search',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            Constants.appPadding,
          ),
        ),
      ),
    ),
  );
}
