// ignore_for_file: use_build_context_synchronously
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialty_with_firebase/presentation/auth/sign_in/sign_in.dart';
import '../../../constants/assets.dart';
import '../../../constants/constants.dart';
import '../../../shared/cache_helper.dart';
import '../../../widget/default_text_form.dart';
import '../../main_screen/main_screen.dart';
import '../items.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController();
    TextEditingController name = TextEditingController();
    TextEditingController rePassword = TextEditingController();
    TextEditingController password = TextEditingController();
    GlobalKey<FormState> formkey = GlobalKey<FormState>();
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(
          Constants.appPadding,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 100,
                ),
                const Text(
                  'Register Now',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                defaultTextForm(
                  label: 'Name',
                  controller: name,
                  textInputType: TextInputType.name,
                  iconData: Icons.email,
                  onValidate: (String? value) {
                    if (value!.isEmpty) {
                      return "this field shouldn't be empty";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                defaultTextForm(
                  label: 'E-mail',
                  controller: email,
                  textInputType: TextInputType.emailAddress,
                  iconData: Icons.email,
                  onValidate: (String? value) {
                    if (value!.isEmpty) {
                      return "this field shouldn't be empty";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                defaultTextForm(
                  label: 'password',
                  controller: password,
                  textInputType: TextInputType.visiblePassword,
                  iconData: Icons.email,
                  onValidate: (String? value) {
                    if (value!.isEmpty) {
                      return "this field shouldn't be empty";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                defaultTextForm(
                  label: 're-password',
                  controller: rePassword,
                  textInputType: TextInputType.visiblePassword,
                  iconData: Icons.lock,
                  onValidate: (String? value) {
                    if (value!.isEmpty) {
                      return "this field shouldn't be empty";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                buildDivider(),
                Row(
                  children: [
                    buildSocialLogin(
                      icon: Assets.googleIcon,
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    buildSocialLogin(
                      icon: Assets.facebookIcon,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const SignIn(),
                      ),
                      (route) => false,
                    );
                  },
                  child: const Text.rich(
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "if you  have an account ",
                        ),
                        TextSpan(
                            text: "SignIn  ",
                            style: TextStyle(
                              color: Colors.blue,
                            )),
                        TextSpan(
                          text: "now ",
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (formkey.currentState!.validate()) {
                        try {
                          await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: email.text,
                            password: password.text,
                          )
                              .then((user) {
                            CacheHelper.saveData(
                              key: 'token',
                              value: user.user!.uid,
                            )
                                .then(
                                  (value) async => users
                                      .doc(user.user!.uid)
                                      .set({
                                        'name': name.text,
                                        'email': email.text,
                                        'imgPic': '',
                                        'freinds': [],
                                        'uid': user.user!.uid,
                                        'Fcm': await FirebaseMessaging.instance
                                            .getToken(),
                                      })
                                      .then(
                                        (value) => Navigator.of(context)
                                            .pushAndRemoveUntil(
                                          MaterialPageRoute(
                                            builder: (context) => MainScreen(
                                              uid: user.user!.uid,
                                            ),
                                          ),
                                          (route) => false,
                                        ),
                                      )
                                      .catchError(
                                        (error) {
                                          buildSnackBar(
                                            context: context,
                                            error:
                                                '=========>${error.toString()}',
                                          );
                                        },
                                      ),
                                )
                                .catchError((error) {});
                          }).catchError((error) {
                            buildSnackBar(
                              context: context,
                              error: error.toString(),
                            );
                          });
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            buildSnackBar(
                              context: context,
                              error: 'The password provided is too weak',
                            );
                          } else if (e.code == 'email-already-in-use') {
                            buildSnackBar(
                              context: context,
                              error:
                                  'The account already exists for that email.',
                            );
                          }
                        } catch (e) {
                          buildSnackBar(
                            context: context,
                            error: e.toString(),
                          );
                        }
                      }
                    },
                    child: const Text(
                      'Register Now',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
