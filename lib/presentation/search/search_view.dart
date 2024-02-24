import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialty_with_firebase/constants/constants.dart';
import 'package:socialty_with_firebase/presentation/search/items.dart';
import 'package:socialty_with_firebase/widget/search.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  bool isAddFriend = false;
  Stream<QuerySnapshot>? usersStream;

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
                usersStream = FirebaseFirestore.instance
                    .collection('users')
                    .where('name', isEqualTo: value.toString())
                    .snapshots();
              },
            ),
            StreamBuilder<QuerySnapshot>(
              stream: usersStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      'Something went wrong',
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasData) {
                  return ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      log(data['imageProfile'].toString());
                      return SearchCard(
                        image: data['imageProfile'].toString(),
                        uid: data['uid'].toString(),
                      );
                    }).toList(),
                  );
                } else {
                  return const Center(
                    child: Text(
                      'Search now ......',
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
