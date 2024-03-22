import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/components/custom_button.dart';
import 'package:todo_app/components/custom_text.dart';
import 'package:todo_app/components/custom_textfield.dart';
import 'package:todo_app/config.dart';
import 'package:todo_app/screens/auth/login_page.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  bool isNotValidate = false;

  registerUser() async {
    if (emailController.text.isNotEmpty && pwdController.text.isNotEmpty) {
      var regBody = {
        "email": emailController.text,
        "password": pwdController.text
      };

      var respose = await http.post(Uri.parse(registration),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody));

      var jsonResponse = jsonDecode(respose.body);

      print(jsonResponse['status']);

      if (jsonResponse['status']) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ));
      } else {
        print('Something went wrong');
      }
    } else {
      setState(() {
        isNotValidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(
              text: "Create your account",
              color: Colors.black,
              fsize: 25,
              fweight: FontWeight.w500),
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
              ontap: () {
                registerUser();
              },
              text: 'Register',
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
