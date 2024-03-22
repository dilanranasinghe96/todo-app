import 'package:flutter/material.dart';

import '../../components/custom_button.dart';
import '../../components/custom_textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isNotValidate = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomTextField(
              errorText: isNotValidate == true ? "Enter valid email" : null,
              label: 'Enter email',
              controller: emailController,
              prefix: Icons.email_outlined),
          CustomTextField(
              errorText: isNotValidate == true ? "Enter valid password" : null,
              isPassword: true,
              label: 'Enter password',
              controller: pwdController,
              prefix: Icons.lock_outline),
          CustomButton(
              size: size,
              ontap: () {},
              text: 'Login',
              buttonColor: Colors.amber,
              textColor: Colors.black,
              bHeight: size.height * 0.06,
              bWidth: size.width * 0.5,
              fSize: 20)
        ],
      ),
    );
  }
}
