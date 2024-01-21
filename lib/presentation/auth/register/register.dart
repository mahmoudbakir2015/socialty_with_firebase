import 'package:flutter/material.dart';
import 'package:socialty_with_firebase/presentation/auth/sign_in/sign_in.dart';

import '../../../constants/constants.dart';
import '../../../widget/default_text_form.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController();
    TextEditingController name = TextEditingController();
    TextEditingController rePassword = TextEditingController();
    TextEditingController password = TextEditingController();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(
          Constants.appPadding,
        ),
        child: SingleChildScrollView(
          child: Form(
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
                  onValidate: (String? value) {},
                ),
                const SizedBox(
                  height: 20,
                ),
                defaultTextForm(
                  label: 'E-mail',
                  controller: email,
                  textInputType: TextInputType.emailAddress,
                  iconData: Icons.email,
                  onValidate: (String? value) {},
                ),
                const SizedBox(
                  height: 20,
                ),
                defaultTextForm(
                  label: 'password',
                  controller: password,
                  textInputType: TextInputType.emailAddress,
                  iconData: Icons.email,
                  onValidate: (String? value) {},
                ),
                const SizedBox(
                  height: 20,
                ),
                defaultTextForm(
                  label: 're-password',
                  controller: rePassword,
                  textInputType: TextInputType.visiblePassword,
                  iconData: Icons.lock,
                  onValidate: (String? value) {},
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
                        TextSpan(text: "if you  have an account "),
                        TextSpan(
                            text: "SignIn  ",
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
                    onPressed: () {},
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
