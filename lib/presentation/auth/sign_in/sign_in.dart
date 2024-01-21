import 'package:flutter/material.dart';
import '../../../constants/constants.dart';
import '../../../widget/default_text_form.dart';
import '../register/register.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();
    GlobalKey<FormState> formkey = GlobalKey<FormState>();
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
                  height: 20,
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
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formkey.currentState!.validate()) {
                        showDialog(
                          context: context,
                          builder: (context) => const Dialog(
                            child: Text('Done'),
                          ),
                        );
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
