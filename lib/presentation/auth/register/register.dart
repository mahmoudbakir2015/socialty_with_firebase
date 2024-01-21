// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialty_with_firebase/presentation/auth/sign_in/sign_in.dart';
import '../../../constants/assets.dart';
import '../../../constants/constants.dart';
import '../../../widget/default_text_form.dart';
import '../../home/home_view.dart';
import '../items.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController();
    TextEditingController name = TextEditingController();
    TextEditingController rePassword = TextEditingController();
    TextEditingController password = TextEditingController();
    GlobalKey<FormState> formkey = GlobalKey<FormState>();
    GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
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
                          final credential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                email: email.text,
                                password: password.text,
                              )
                              .then(
                                (value) => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const Home(),
                                  ),
                                ),
                              );
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
