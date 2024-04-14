import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/dashboard_page.dart';
import 'package:todo_app/screens/auth/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //user keep login for 1h
  SharedPreferences pref = await SharedPreferences.getInstance();
  runApp(MyApp(
    token: pref.getString('token'),
  ));
}

class MyApp extends StatelessWidget {
  final token;
  const MyApp({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDo App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: token == null
          ? const LoginPage()
          : (JwtDecoder.isExpired(token) == false)
              ? DashboardPage(token: token)
              : const LoginPage(),
    );
  }
}
