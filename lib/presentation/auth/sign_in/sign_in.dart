import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../constants/assets.dart';
import '../../../constants/constants.dart';
import '../../../widget/default_text_form.dart';
import '../../home/home_view.dart';
import '../items.dart';
import '../register/register.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
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
          await GoogleSignIn().signIn().then(
                (value) => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const Home(),
                  ),
                ),
              );

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
                        UserCredential userCredential =
                            await signInWithGoogle();
                        print(userCredential.credential?.accessToken);
                      },
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    buildSocialLogin(
                        icon: Assets.facebookIcon,
                        onTap: () async {
                          UserCredential userCredential =
                              await signInWithFacebook();
                          print(userCredential.credential?.accessToken);
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
                          final credential = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
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
