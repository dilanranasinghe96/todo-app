import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  CustomTextField(
      {super.key,
      this.isPassword = false,
      required this.label,
      required this.controller,
      required this.prefix,
      required this.errorText});
  bool isPassword;
  String label;
  IconData prefix;
  String? errorText;
  TextEditingController controller = TextEditingController();

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
          controller: widget.controller,
          obscureText: widget.isPassword == false ? !isObscure : isObscure,
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              label: Text(widget.label),
              // errorStyle: const TextStyle(color: Colors.red, fontSize: 15),
              errorText: widget.errorText,
              prefixIcon: Icon(widget.prefix),
              suffixIcon: widget.isPassword == true
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          isObscure = !isObscure;
                        });
                      },
                      child: Icon(
                          isObscure ? Icons.visibility : Icons.visibility_off))
                  : null)),
    );
  }
}
