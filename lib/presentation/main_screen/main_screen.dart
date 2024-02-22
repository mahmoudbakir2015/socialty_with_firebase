// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialty_with_firebase/constants/constants.dart';
import 'package:socialty_with_firebase/presentation/auth/sign_in/sign_in.dart';
import 'package:socialty_with_firebase/presentation/home/home_view.dart';
import 'package:socialty_with_firebase/shared/cache_helper.dart';
import '../chat/chat.dart';
import '../profile/profile.dart';
import '../search/search_view.dart';

// ignore: must_be_immutable
class MainScreen extends StatefulWidget {
  final String uid;
  const MainScreen({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;
  List<Widget> screens = [
    Home(
      uid: CacheHelper.getData(key: 'token').toString(),
    ),
    const Chat(),
    Profile(
      uid: CacheHelper.getData(key: 'token').toString(),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const Search(),
              ),
            );
          },
          child: const Icon(
            Icons.search,
          ),
        ),
        title: (currentIndex == 2)
            ? const Text(
                'Profile',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )
            : const Text(''),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Constants.appPadding,
              ),
              child: Text(
                (currentIndex == 2) ? '' : 'Sociality',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          (currentIndex == 2)
              ? Padding(
                  padding: const EdgeInsets.all(
                    Constants.appPadding,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          actionsAlignment: MainAxisAlignment.spaceEvenly,
                          content: const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Are you sure to exit ?',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Cancel',
                              ),
                            ),
                            OutlinedButton(
                              onPressed: () async {
                                // await CacheHelper.removeData(key: key).then((value) => null)
                                await CacheHelper.clearData(key: 'token').then(
                                  (value) async => await FirebaseAuth.instance
                                      .signOut()
                                      .then(
                                        (value) => Navigator.of(context)
                                            .pushAndRemoveUntil(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const SignIn(),
                                          ),
                                          (route) => false,
                                        ),
                                      ),
                                );
                              },
                              child: const Text(
                                'SignOut',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.exit_to_app,
                      color: Colors.red,
                    ),
                  ),
                )
              : const Text('')
        ],
      ),
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int value) {
          setState(() {
            currentIndex = value;
          });
        },
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
