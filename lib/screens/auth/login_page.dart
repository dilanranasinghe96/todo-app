import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/dashboard_page.dart';
import 'package:todo_app/screens/auth/registration_page.dart';

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
  late SharedPreferences prefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  void loginUser() async {
    if (emailController.text.isNotEmpty && pwdController.text.isNotEmpty) {
      var regBody = {
        "email": emailController.text,
        "password": pwdController.text
      };

      var respose = await http.post(Uri.parse('http://192.168.56.1:3000/login'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody));

      var jsonResponse = jsonDecode(respose.body);
      if (jsonResponse['status'] == true) {
        var myToken = jsonResponse['token'];
        prefs.setString('token', myToken);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardPage(token: myToken),
            ));
      } else {
        print('Something went wrong');
      }
    }
  }

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
              ontap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => const RegistrationPage(),
                //     ));
                loginUser();
              },
              text: 'Login',
              buttonColor: Colors.amber,
              textColor: Colors.black,
              bHeight: size.height * 0.06,
              bWidth: size.width * 0.5,
              fSize: 20),
          TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegistrationPage(),
                    ));
              },
              child: const Text('SignUp'))
        ],
      ),
    );
  }
}
