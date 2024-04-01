import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class DashboardPage extends StatefulWidget {
  final token;
  const DashboardPage({required this.token, super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late String email;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    email = jwtDecodedToken['email'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text(email)],
      ),
    );
  }
}
