import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
  final TextEditingController _todoTitle = TextEditingController();
  final TextEditingController _todoDesc = TextEditingController();
  List? items;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    userId = jwtDecodedToken['_id'];
  }

  void addTodo() async {
    if (_todoTitle.text.isNotEmpty && _todoDesc.text.isNotEmpty) {
      var regBody = {
        "userId": userId,
        "title": _todoTitle.text,
        "desc": _todoDesc.text
      };
      var response = await http.post(Uri.parse(addtodo),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody));
      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse['status']);
      if (jsonResponse['status']) {
        _todoDesc.clear();
        _todoTitle.clear();
        Navigator.pop(context);
        getTodoList(userId);
      } else {
        print("SomeThing Went Wrong");
      }
    }
  }

  void getTodoList(userId) async {
    var regBody = {"userId": userId};
    var response = await http.post(Uri.parse(getToDoList),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody));
    var jsonResponse = jsonDecode(response.body);
    items = jsonResponse['success'];
    setState(() {});
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
                  controller: _todoTitle,
                ),
                CustomTextField(
                  label: 'Description',
                  controller: _todoDesc,
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
        body: items == null
            ? null
            : ListView.builder(
                itemCount: items!.length,
                itemBuilder: (context, int index) {
                  return Slidable(
                    key: const ValueKey(0),
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      dismissible: DismissiblePane(onDismissed: () {}),
                      children: const [
                        // SlidableAction(
                        //   backgroundColor: Color(0xFFFE4A49),
                        //   foregroundColor: Colors.white,
                        //   icon: Icons.delete,
                        //   label: 'Delete',
                        //   onPressed: (BuildContext context) {
                        //     print('${items![index]['_id']}');
                        //     deleteItem('${items![index]['_id']}');
                        //   },
                        // ),
                      ],
                    ),
                    child: Card(
                      borderOnForeground: false,
                      child: ListTile(
                        leading: const Icon(Icons.task),
                        title: Text('${items![index]['title']}'),
                        subtitle: Text('${items![index]['desc']}'),
                        trailing: const Icon(Icons.arrow_back),
                      ),
                    ),
                  );
                }),
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
