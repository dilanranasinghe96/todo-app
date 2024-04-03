import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

import 'components/custom_button.dart';
import 'components/custom_text.dart';
import 'components/custom_textfield.dart';
import 'config.dart';

class DashboardPage extends StatefulWidget {
  final String token;

  const DashboardPage({required this.token, Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late String userId;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    userId = jwtDecodedToken['_id'];
  }

  void addTodo() async {
    if (titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty) {
      var requestBody = {
        "userId": userId,
        "title": titleController.text,
        "desc": descriptionController.text
      };

      var response = await http.post(
        Uri.parse(addtodo),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status']) {
        descriptionController.clear();
        titleController.clear();
        Navigator.pop(context);
      } else {
        print("Something Went Wrong");
      }
    }
  }

  Future<void> _displayDialogBox(BuildContext context) async {
    final size = MediaQuery.of(context).size;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: CustomText(
            text: 'Add To-Do',
            color: Colors.black,
            fsize: 20,
            fweight: FontWeight.w500,
          ),
          content: SizedBox(
            height: size.height * 0.3,
            child: Column(
              children: [
                CustomTextField(
                  label: 'Title',
                  controller: titleController,
                ),
                CustomTextField(
                  label: 'Description',
                  controller: descriptionController,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomButton(
                    size: size,
                    ontap: () {
                      addTodo();
                    },
                    text: 'Add',
                    buttonColor: Colors.blue,
                    textColor: Colors.black,
                    bHeight: size.height * 0.06,
                    bWidth: size.width * 0.3,
                    fSize: 20,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blue,
          title: CustomText(
            text: 'To-Do App',
            color: Colors.black,
            fsize: 20,
            fweight: FontWeight.bold,
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: userId,
                color: Colors.black,
                fsize: 20,
                fweight: FontWeight.w500,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _displayDialogBox(context);
          },
          backgroundColor: Colors.blue,
          shape: const CircleBorder(),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
