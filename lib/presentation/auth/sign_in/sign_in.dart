import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:socialty_with_firebase/shared/cache_helper.dart';
import '../../../constants/assets.dart';
import '../../../constants/constants.dart';
import '../../../widget/default_text_form.dart';
import '../../main_screen/main_screen.dart';
import '../items.dart';
import '../register/register.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    Future<UserCredential> signInWithFacebook() async {
      // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance.login();

      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      // Once signed in, return the UserCredential
      return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    }

    Future<UserCredential> signInWithGoogle() async {
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn().signIn().then((user) {
        CacheHelper.saveData(
          key: 'token',
          value: user!.id,
        ).then(
          (value) async => users
              .doc(user.id)
              .set({
                'name': user.displayName,
                'email': user.email,
                'imageProfile': '',
                'imageWall': '',
                'freinds': [],
                'uid': user.id,
                'Fcm': await FirebaseMessaging.instance.getToken(),
              })
              .then(
                (value) => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => MainScreen(
                      uid: user.id.toString(),
                    ),
                  ),
                  (route) => false,
                ),
              )
              .catchError(
                (error) {
                  buildSnackBar(
                    context: context,
                    error: error.toString(),
                  );
                },
              ),
        );
      }).catchError((error) {
        buildSnackBar(
          context: context,
          error: error.toString(),
        );
      });

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    }

    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();
    GlobalKey<FormState> formkey = GlobalKey<FormState>();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(
          Constants.appPadding,
        ),
        child: Form(
          key: formkey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 100,
                ),
                const Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 30,
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
                  height: 30,
                ),
                buildDivider(),
                Row(
                  children: [
                    buildSocialLogin(
                      icon: Assets.googleIcon,
                      onTap: () async {
                        await signInWithGoogle();
                      },
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    buildSocialLogin(
                        icon: Assets.facebookIcon,
                        onTap: () async {
                          await signInWithFacebook();
                        }),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const Register(),
                      ),
                    );
                  },
                  child: const Text.rich(
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    TextSpan(
                      children: [
                        TextSpan(text: "if you don't have an account "),
                        TextSpan(
                            text: "SignUp ",
                            style: TextStyle(
                              color: Colors.blue,
                            )),
                        TextSpan(text: "now "),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (formkey.currentState!.validate()) {
                        try {
                          // ignore: unused_local_variable
                          final credential = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                            email: email.text,
                            password: password.text,
                          )
                              .then((user) {
                            CacheHelper.saveData(
                              key: 'token',
                              value: user.credential!.accessToken,
                            ).then(
                              (value) => Navigator.of(context)
                                  .pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => MainScreen(
                                    uid:
                                        user.credential!.accessToken.toString(),
                                  ),
                                ),
                                (route) => false,
                              )
                                  .catchError(
                                (error) {
                                  buildSnackBar(
                                    context: context,
                                    error: error.toString(),
                                  );
                                },
                              ),
                            );
                          }).catchError((error) {
                            buildSnackBar(
                              context: context,
                              error: error.toString(),
                            );
                          });
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            // ignore: use_build_context_synchronously
                            buildSnackBar(
                              context: context,
                              error: 'No user found for that email.',
                            );
                          } else if (e.code == 'wrong-password') {
                            // ignore: use_build_context_synchronously
                            buildSnackBar(
                              context: context,
                              error: 'Wrong password provided for that user.',
                            );
                          }
                        }
                      }
                    },
                    child: const Text(
                      'Sign Now',
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
