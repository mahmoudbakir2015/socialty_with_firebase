import 'package:flutter/material.dart';

import '../../../constants/constants.dart';
import '../../../widget/default_text_form.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(
          Constants.appPadding,
        ),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Sign In'),
              defaultTextForm(
                label: 'E-mail',
                controller: email,
                textInputType: TextInputType.emailAddress,
                iconData: Icons.email,
                onValidate: (String? value) {},
              ),
              defaultTextForm(
                label: 'password',
                controller: password,
                textInputType: TextInputType.visiblePassword,
                iconData: Icons.lock,
                onValidate: (String? value) {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
