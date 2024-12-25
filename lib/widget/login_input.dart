import 'package:bil_app/util/color.dart';
import 'package:flutter/material.dart';

class LoginInput extends StatefulWidget {
  final String title;
  final String hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<bool>? focusChanged;
  final bool lineStretch;
  final bool obscureText;
  final TextInputType? keyboardType;

  const LoginInput(this.title, this.hint,
      {super.key,
      this.onChanged,
      this.focusChanged,
      this.lineStretch = false,
      this.obscureText = false,
      this.keyboardType});

  @override
  State<LoginInput> createState() => _LoginInputState();
}

class _LoginInputState extends State<LoginInput> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // 通知父组件
    _focusNode.addListener(() {
      print('Has focus:${_focusNode.hasFocus}');
      if (widget.focusChanged != null) {
        widget.focusChanged!(_focusNode.hasFocus);
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 15),
            width: 100,
            child: Text(
              widget.title,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          _input(),
        ],
      ),
      Padding(
        padding: EdgeInsets.only(left: !widget.lineStretch ? 15 : 0),
        child: const Divider(
          height: 1,
          thickness: 0.5,
        ),
      )
    ]);
  }

  _input() {
    return Expanded(
        child: TextField(
      focusNode: _focusNode,
      onChanged: widget.onChanged,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      autofocus: !widget.obscureText,
      cursorColor: primary,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: widget.hint ?? "",
          hintStyle: const TextStyle(fontSize: 15, color: Colors.grey),
          contentPadding: const EdgeInsets.only(left: 20, right: 20)),
    ));
  }
}
